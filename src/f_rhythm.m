function [y_v,tempo_v] = f_rhythm (x_v, Fs)

% Facteur de décimation
factor = round(Fs/100);
Fs_flux = floor(Fs/factor);

halfhann = hann(round(Fs_flux*2/5));
halfhann = halfhann(round(Fs_flux/5):end);

% On récupère les onsets, décimation pour calculer plus vite
% Val absolue du signal, puis convolution pour obtenir l'enveloppe
% Dérivation puis redressement mono-alternance pour obtenir uniquement
% les attaques (montées) et pas les descentes.

onsets_v = decimate(x_v,factor);
onsets_v = abs(onsets_v);
onsets_v = conv(onsets_v,halfhann);
onsets_v = diff(onsets_v);
onsets_v = (onsets_v + abs(onsets_v))/2;
onsets_v = onsets_v.';

N_SF = length(onsets_v);

% Taille de la fenêtre glissante
N_win_s = 8;
N_win = N_win_s * Fs_flux;

if length(x_v)/Fs < N_win_s
    N_win = floor(length(x_v)/Fs - 1) * Fs_flux;
    N_win_s = floor(length(x_v)/Fs - 1);
end

% Pas d'avancement
R_rhythm = floor(.5 * Fs_flux);

% Nombre de fenêtres dans la trame complète
Nt = fix( (N_SF - N_win) / R_rhythm);

Nfft2 = floor( N_win_s * 2^nextpow2(N_win) );

% Rythmogramme en frequence
rhythmogram2_m = zeros(Nfft2/2+1,Nt);

for k= 1 : Nt
    deb = 1 + (k - 1) * R_rhythm; % début de trame
    fin = deb + N_win; % fin de trame
    
    signal_v = onsets_v(deb:fin);
    signal_v = signal_v-mean(signal_v);
    
    tmp_v = abs(fft(signal_v, Nfft2));
    rhythmogram2_m(:,k) = tmp_v(1:Nfft2/2+1);
end

% % Rythmogramme fréquentiel, analogue à un spectrogramme (~ sur 0-5 Hz)
% imagesc((1:Nt), (0:Nfft2) / Nfft2 * Fs_flux * 60, rhythmogram2_m);
% axis xy, colorbar('vert')
% ax = axis;
% axis([ax(1) ax(2) 0 300])
% 
% pause;

% Détermination du vecteur qui indique l'évolution du tempo dans le temps
min_tempo = floor(60 / Nfft2 * Fs_flux * 60);
max_tempo = floor(300 / Nfft2 * Fs_flux * 60);
[~,tempo_v] = max(rhythmogram2_m(min_tempo:max_tempo,:));
tempo_v =  tempo_v + min_tempo;
tempo_v = tempo_v / Nfft2 * Fs_flux * 60;
tempo_v(tempo_v > 300) = [];
tempo_v(tempo_v > 180) = tempo_v(tempo_v > 180) / 2;
tempo_v(tempo_v < 70) = tempo_v(tempo_v < 70) * 2;

Nt = length(tempo_v);

R_flux = floor(N_SF/Nt);
N_win = R_flux;

R = floor(length(x_v)/Nt);
L_n = R;

% Tableau référençant le retard ou avance en sample
% Calcul à effectuer pour chaque frame
pos_n_v = zeros(Nt,1);
pos_s_v = zeros(Nt,1);

y_v = zeros(length(x_v),1);

for k = 1 : Nt
    % Création du Dirac
    dir_v = zeros(N_win,1);
    period_n = floor(Fs_flux * 60 / tempo_v(k));
    dir_v(1:period_n:end) = 1;
    
    dir_s_v = zeros(L_n,1);
    period_s = floor(Fs * 60 / tempo_v(k));
    dir_s_v(1 : period_s : end) = 1;
    
    deb = 1 + (k - 1) * R_flux; % début de trame
    fin = deb + N_win - 1; % fin de trame
    % On évite de sortir du tableau par erreur
    deb = max([1 deb]);
    fin = min([length(onsets_v) fin]);
    
    deb_s = 1 + (k - 1) * R;
    fin_s = deb_s + L_n;
    % On évite de sortir du tableau par erreur
    deb_s = max([1 deb_s]);
    fin_s = min([length(y_v) fin_s]);
    
    % On effectue la convolution
    conv_flux = conv(onsets_v(deb:fin), dir_v);
    conv_flux(N_win+1:end) = [];
    
    [~, temp_position] = max(conv_flux);
    
    % On calcule l'intervalle entre le dirac précédant et le temps fort
    pos_n_v(k) = mod(temp_position,period_n);
    
    % On convertit ça en échantillon pour traiter l'audio
    pos_s_v(k) = floor(pos_n_v(k)/Fs_flux*Fs);
    
    while deb_s + pos_s_v(k) < 1
        deb_s = deb_s + period_s;
        dir_s_v(end - period_s :end) = [];
    end
    
    % Si la dernière fenêtre dépasse la taille du tableau
    while fin_s + pos_s_v(k) - 1 > length(x_v)
        fin_s = length(x_v) - pos_s_v(k) + 1;
        dir_s_v(fin_s - deb_s + 1:end) = [];
    end
    
    % On aligne le vecteur de Dirac sur le temps fort
    y_v(deb_s + pos_s_v(k):fin_s + pos_s_v(k)-1) = dir_s_v;
    
    % Élimination de clics consécutifs dus à l'erreur entre chaque fenêtre
    if k > 1
        deb_temp = floor(deb_s + pos_s_v(k) - period_s/3);
        fin_temp = floor(deb_s + pos_s_v(k) + period_s/3);
        
        deb_temp = max([deb_temp 1]);
        fin_temp = min([fin_temp length(y_v)]);
        
        y_temp = y_v(deb_temp: fin_temp);
        
        % On cherche deux diracs consécutifs sur un court intervalle
        is_dir = find(y_temp ~= 0);
        if length(is_dir) >= 2
            y_temp(is_dir) = 0;
            % Si c'est le cas, on les remplace par un seul centré
            % sur la valeur moyenne des deux
            y_temp(floor(mean(is_dir))) = 1;
            y_v(deb_temp:fin_temp) = y_temp;
        end
        
    end
    
end

% On garde des vecteurs de même taille entre l'entrée et la sortie
y_v = y_v(1:length(x_v));

end