close all;

filename='loop1.wav';

%Lecture du signal
[x_v,Fs]=audioread(filename);
% Passage en mono si audio en stéréo (ou plus)
if size(x_v,2) >= 2 
    x_v = (x_v(:,1) + x_v(:,2)) / 2;
end

overlap_s = 0.010;
windowtime_s = 0.046;
L_n = floor(Fs * 2 * windowtime_s);
Nfft = 2^nextpow2(L_n);
R = floor(Fs * overlap_s);

Xtilde_m = f_tfct(x_v, Nfft, L_n, R);

% Dérivation
if 1
    
    LX_m = 20*log(abs(Xtilde_m)); %en echelle logarithmique
    LX_m_max = max(LX_m(:));
    
    LX_m_moy = 50;
    % On ramène les éléments trop faibles à M-T
    LX_m(LX_m < (LX_m_max - LX_m_moy)) = LX_m_max - LX_m_moy;
    
    Spectral_flux_v = sum(max(diff(LX_m,[],2), 0), 1);
%     subplot(211), imagesc(LX_m), axis xy
%     subplot(212), plot(Spectral_flux_v)
    
else
    Spectral_flux_v = diff(abs(sum(Xtilde_m,1)));
    % Redressement mono-alternance (Half-wave rectification)
    Spectral_flux_v = (Spectral_flux_v + abs(Spectral_flux_v))/2;
end

% Fréquences d'échantillonage de la trame des onsets
Fs_flux = floor(Fs/R);

N = length(Spectral_flux_v);

% Taille de la fenêtre glissante
N_win = floor(8 * Fs_flux);

% Overlap
R_rhythm = floor(.5 * Fs_flux);

% Nombre de fenêtres dans la trame complète
Nt = fix((N - N_win)/R_rhythm);

axeLag_sec_v = (0:N_win)/Fs_flux;

Nfft2 = 8*2^nextpow2(N_win); 

% Rythmogramme en temporel (autocorrélation)
rhythmogram_m = zeros(N_win+1,Nt); 

% Rythmogramme en frequence
rhythmogram2_m = zeros(Nfft2/2+1,Nt);

for k= 1 : Nt
    deb = 1 + (k - 1) * R_rhythm; % début de trame
    fin = deb + N_win; % fin de trame
    
    signal_v = Spectral_flux_v(deb:fin);
    signal_v = signal_v-mean(signal_v);
    
    tmp_v = xcorr(signal_v, 'coef');     
    rhythmogram_m(:,k) = tmp_v(N_win+1:end);
    
    tmp_v = abs(fft(signal_v, Nfft2));
    rhythmogram2_m(:,k) = tmp_v(1:Nfft2/2+1);
    
end

% Rythmogramme temporel, autocorrélation des onsets dans le temps
% figure;
% imagesc([1:Nt], axeLag_sec_v, abs(rhythmogram_m));
% axis xy,colorbar('vert')

%Rythmogramme fréquentiel, analogue à un spectrogramme (~ sur 0-5 Hz)
figure;
imagesc((1:Nt), (0:Nfft2) / Nfft2 * Fs_flux * 60, rhythmogram2_m);
axis xy, colorbar('vert')
ax = axis;
axis([ax(1) ax(2) 0 300])

min_tempo = floor(50 / Nfft2 * Fs_flux * 60);
max_tempo = floor(300 / Nfft2 * Fs_flux * 60);
[~,tempo_v] = max(rhythmogram2_m(min_tempo:max_tempo,:));
tempo_v =  tempo_v + min_tempo;
tempo_v = tempo_v / Nfft2 * Fs_flux * 60;
tempo_v(tempo_v > 300) = [];
tempo_v(tempo_v > 180) = tempo_v(tempo_v > 180) / 2;

figure;
plot(tempo_v);

Nt = length(tempo_v);%floor((length(Spectral_flux_v) - N_win)/R);

R_flux = floor(N/Nt);
N_win = R_flux;

R = floor(length(x_v)/Nt);
L_n = R;

% Tableau référençant le retard ou avance 
% en sample à effectuer pour chaque frame
pos_n_v = zeros(Nt,1);
pos_s_v = zeros(Nt,1);

y_v = zeros(length(x_v),1);

for k= 1 : Nt
    % Création du Dirac
    dir_v = zeros(N_win,1);
    period_n = floor(Fs_flux * 60 / tempo_v(k));
    dir_v(1:period_n:end) = 1;
    
    dir_s_v = zeros(L_n,1);
    period_s = floor(Fs * 60 / tempo_v(k));
    dir_s_v(1 : period_s : end) = 1;
    
    deb = 1 + (k - 1) * R_flux; % début de trame
    fin = deb + N_win; % fin de trame
    
    deb_s = 1 + (k - 1) * R;
    fin_s = deb_s + L_n;
    
    conv_flux = conv(Spectral_flux_v(deb:fin), dir_v);
    conv_flux(N_win+1:end) = [];
    
    [~, temp_position] = max(conv_flux);
    
    % On calcule l'intervalle entre le dirac précédant le temps fort
    pos_n_v(k) = mod(temp_position,period_n);
    
    % On convertit ça en échantillon pour traiter l'audio
    pos_s_v(k) = floor(pos_n_v(k)/Fs_flux*Fs);
    
    while deb_s+pos_s_v(k) < 1
        deb_s = deb_s + period_s;
        dir_s_v(end-period_s:end) = [];
    end
    
    while fin_s + pos_s_v(k)-1 > length(x_v)
        fin_s = fin_s - period_s - 1;
        dir_s_v(end-period_s:end) = [];
    end
    
    y_v(deb_s + pos_s_v(k):fin_s + pos_s_v(k)-1) = dir_s_v;
    
    % Élimination de clics consécutifs
    if k > 1
        deb_temp = floor(deb_s + pos_s_v(k) - period_s/3);
        fin_temp = floor(deb_s + pos_s_v(k) + period_s/3);
        y_temp = y_v(deb_temp: fin_temp);
        is_dir = find(y_temp ~= 0);
        if length(is_dir) >= 2
            y_temp(is_dir) = 0;
            y_temp(floor(mean(is_dir))) = 1;
            y_v(deb_temp:fin_temp) = y_temp;
        end
    end
end

y_v = y_v(1:length(x_v));
y_v = y_v + x_v/16;
player = audioplayer(y_v, Fs);