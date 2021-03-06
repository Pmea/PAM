function [y_v,tempo_v] = f_rhythm_tfct (x_v, Fs)

step_s = 0.010;
windowtime_s = 0.046;
L_n = floor(Fs * 2 * windowtime_s);
Nfft = 2^nextpow2(L_n);
R = floor(Fs * step_s);

Xtilde_m = f_tfct(x_v, Nfft, L_n, R);

% On passe en logartihmique
LX_m = 20*log(abs(Xtilde_m));
LX_m_max = max(LX_m(:));
    
LX_m_moy = 50;

% On ram�ne les �l�ments trop faibles � M-T
LX_m(LX_m < (LX_m_max - LX_m_moy)) = LX_m_max - LX_m_moy;

% D�rivation et r�cup�ration du maximum pour chaque trame
% Voil� notre vecteurs d'onsets indiquant les attaques
Spectral_flux_v = sum(max(diff(LX_m,[],2), 0), 1);

% Fr�quences d'�chantillonage de la trame des onsets
Fs_flux = floor(Fs/R);

N = length(Spectral_flux_v);

% Pas d'avancement
R_rhythm = floor(.5 * Fs_flux);

% Taille de la fen�tre glissante
N_win = floor(8 * Fs_flux);

if N < N_win
    N_win = N - R_rhythm;
end

% Nombre de fen�tres dans la trame compl�te
Nt = fix((N - N_win)/R_rhythm);

Nfft2 = 8*2^nextpow2(N_win);

% Rythmogramme en frequence
rhythmogram2_m = zeros(Nfft2/2+1,Nt);

for k= 1 : Nt
    deb = 1 + (k - 1) * R_rhythm; % d�but de trame
    fin = deb + N_win; % fin de trame
    
    signal_v = Spectral_flux_v(deb:fin);
    signal_v = signal_v-mean(signal_v);
    
    tmp_v = abs(fft(signal_v, Nfft2));
    rhythmogram2_m(:,k) = tmp_v(1:Nfft2/2+1);
end

% D�termination du vecteur qui indique l'�volution du tempo dans le temps
min_tempo = floor(50 / Nfft2 * Fs_flux * 60);
max_tempo = floor(300 / Nfft2 * Fs_flux * 60);
[~,tempo_v] = max(rhythmogram2_m(min_tempo:max_tempo,:));
tempo_v =  tempo_v + min_tempo;
tempo_v = tempo_v / Nfft2 * Fs_flux * 60;
tempo_v(tempo_v > 300) = [];
tempo_v(tempo_v > 180) = tempo_v(tempo_v > 180) / 2;

Nt = length(tempo_v);

R_flux = floor(N/Nt);
N_win = R_flux;

R = floor(length(x_v)/Nt);
L_n = R;

% Tableau r�f�ren�ant le retard ou avance 
% en sample � effectuer pour chaque frame
pos_n_v = zeros(Nt,1);
pos_s_v = zeros(Nt,1);

y_v = zeros(length(x_v),1);

for k = 1 : Nt
    % Cr�ation du Dirac
    dir_v = zeros(N_win,1);
    period_n = floor(Fs_flux * 60 / tempo_v(k));
    dir_v(1:period_n:end) = 1;
    
    dir_s_v = zeros(L_n,1);
    period_s = floor(Fs * 60 / tempo_v(k));
    dir_s_v(1 : period_s : end) = 1;
    
    deb = 1 + (k - 1) * R_flux; % d�but de trame
    fin = deb + N_win - 1; % fin de trame
    
    deb_s = 1 + (k - 1) * R;
    fin_s = deb_s + L_n;
    
    % On fait la convolution
    conv_flux = conv(Spectral_flux_v(deb:fin), dir_v);
    conv_flux(N_win+1:end) = [];
    
    [~, temp_position] = max(conv_flux);
    
    % On calcule l'intervalle entre le dirac pr�c�dant le temps fort
    pos_n_v(k) = mod(temp_position,period_n);
    
    % On convertit �a en �chantillon pour traiter l'audio
    pos_s_v(k) = floor(pos_n_v(k)/Fs_flux*Fs);
    
    while deb_s+pos_s_v(k) < 1
        deb_s = deb_s + period_s;
        dir_s_v(end-period_s:end) = [];
    end
    
    % Si la derni�re fen�tre d�passe la taille du tableau
    while fin_s + pos_s_v(k) - 1 > length(x_v)
        fin_s = length(x_v) - pos_s_v(k) + 1;
        dir_s_v(fin_s - deb_s + 1:end) = [];
    end
    
    % On aligne le vecteur de Dirac sur le temps fort
    y_v(deb_s + pos_s_v(k):fin_s + pos_s_v(k)-1) = dir_s_v;
    
    % �limination de clics cons�cutifs dus � l'erreur entre chaque fen�tre
    if k > 1
        deb_temp = floor(deb_s + pos_s_v(k) - period_s/3);
        fin_temp = floor(deb_s + pos_s_v(k) + period_s/3);
        if fin_temp > length(y_v)
            fin_temp = length(y_v);
        end
        y_temp = y_v(deb_temp: fin_temp) ;
        is_dir = find(y_temp ~= 0);
        if length(is_dir) >= 2
            y_temp(is_dir) = 0;
            y_temp(floor(mean(is_dir))) = 1;
            y_v(deb_temp:fin_temp) = y_temp;
        end
        
    end
    
end

% On garde des vecteurs de m�me taille entre l'entr�e et la sortie
y_v = y_v(1:length(x_v));

end