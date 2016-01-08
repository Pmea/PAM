% Analyse d'un signal � l'aide de la TFCT
% Transform�e de Fourier � Court Terme
clear all;
close all;
clc;

%% Lecture du signal
[x,Fe] = audioread('signaux/signal40.wav');
x = x(1:10*Fe,1);
x = x(:); % ainsi x est un vect. colonne
% monovoie (voie gauche si st�r�o)

%% Param�tres
affich = 0; % pour affichage du spectrogramme, 0 pour
% pour faire analyse/modif/synth�se sans affichage
% note: cf. spectrogram sous matlab
window = 0; % 0: fen�tre de Hann, else: fen�tre de Blackman-Harris
stretch = 2; % Facteur de streching

N = length(x); % longueur du signal
Nw = 1024; % longueur de la fen�tre
Nfft = 1024; % ordre de la TFD 

if window == 0
    % fen�trage - Hann
    w = hanning(Nw); % d�finition de la fenetre d'analyse
    ws = w; % d�finition de la fen�tre de synth�se
    
    I = floor(Nw/8); % incr�ment sur les temps d'analyse,
    % appel� hop size, t_a=uR
    % Recouvrement de 88%
else
    w = blackmanharris(Nw); % d�finition de la fenetre d'analyse
    
    ws = rectwin(Nw); % d�finition de la fen�tre de synth�se: fen�tre
    % rectangulaire de m�me longueur
    
    I = floor(Nw/12); % incr�ment sur les temps d'analyse,
    % Blackman-Harris - Question 1.2.f
    % recouvrement: 92%
end

R = floor(stretch*I); % Etirement du signal: 2 fois plus long

Nt = fix((N-Nw)/I); % calcul du nombre de tfd � calculer
y = zeros(floor(N*stretch),1); % signal de synth�se

%% Condition de reconstruction parfaite
% Question 1.2.d et 1.2.f
h = w.*ws;
output = ola(h, I, 30); % recouvrement de 75% si Hann, 92% si Blackman

% Normalisation de la fen�tre
amp = max(output);
ws = ws./amp; % On nomralise la fen�tre de synth�se pour avoir une
% reconstruction = 1, peut aussi se faire sur la fen�tre
% d'analyse

if affich
    Xtilde = zeros(Nfft,Nt);
end

%% Initialisations
% Phases et pulsations
phase_X = zeros(Nfft, 1); % Phase de X
phase_Y = zeros(Nfft, 1); % Phase de Y
puls_instant = zeros(Nfft, Nt);

puls = 2*pi*(0:Nfft-1)'/Nfft; % Pulsations des canaux

%% Analyse-Synth�se par TFCT
for k=1:Nt;  % boucle sur les trames
    % Analyse
    deb = (k-1)*I +1; % d�but de trame - x(n+kR)
    fin = deb + Nw -1; % fin de trame
    tx = x(deb:fin).*w; % calcul de la trame
    X = fft(tx,Nfft); % tfd � l'instant b
    
    % Estimation des pulsations instantan�es
    % Param�tres
    phase_ant_X = phase_X; % phase du tour d'avant/ant�rieure, 0 au premier tour
    phase_X = angle(X); % Phases pour tous les canaux du tour pr�sent
    
    % Calcul des pulsations instantan�es
    phase_instant = (phase_X-phase_ant_X);
    puls_instant = phase_instant./I + puls;
    
    % Synth�se
    deb = (k-1)*R +1; % d�but de trame - on �carte les instants de synth�se
    fin = deb + Nw -1; % fin de trame
    
    % Incr�ment de phase
    if k == 1 % premier tour
        phase_Y = phase_X;
    else
        phase_Y = phase_Y + (puls_instant - puls)*R;
    end
    
    % op�rations de transformation - Etirement temporel

    Y = abs(X).*exp(1i*phase_Y); 

    % fin des op�ration de transformation
    
    % Reconstruction
    ys = real(ifft(Y)); % TFD inverse
    ys = ys(1:Nw).*ws; % pond�ration par la fen�tre de synth�se
    y(deb:fin)=y(deb:fin)+ys; % overlap add
end

%soundsc(y, Fe);

if affich
    figure();
    plot(y);
    title('Signal reconstruit');
    
    %% Affichage spectrogramme
    figure();
    freq = (0:Nfft/2)/Nfft*Fe; % �chelle de fr�quence
    b = ([0:Nt-1]*I+Nw/2)/Fe; % tps d'analyse (centre de la fen�tre)
    imagesc(b,freq,db(abs(Xtilde(1:L,:))))
    axis xy    
end