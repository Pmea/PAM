function [ output_args ] = detune(name_audio)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% read input signal
[x, Fe] = audioread(name_audio);
%soundsc(x, Fe);

%% Parameters
N = 0.1*Fe; % Nb de points correspondant � 0.1s de signal
Nfft = 512; % Nb de points pour la fft
w = hanning(N); % fen�tre d'analyse
I = floor(N/2); % Recouvrement de 50%
Nt = 20; % nb de trames correspondant � 1s de signal

for k=1:Nt;  % boucle sur les trames
    % Extraction du signal
    deb = (k-1)*I +1; % d�but de trame - x(n+kR)
    fin = deb + N -1; % fin de trame
    tx = x(deb:fin).*w; % calcul de la trame
    Xk = fft(tx, Nfft); % tfd � l'instant b
    
    % Calcul de la fr�quence fondamentale via produit spectral
    F0 = frequence(Xk, Fe, Nfft) % H = 5 par d�faut
end

end

