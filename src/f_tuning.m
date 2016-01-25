function accordage = f_tuning(filename)

%Lecture du signal
[x_v,Fs]=audioread(filename);

% Passage en mono si audio en st�r�o (ou plus)
if size(x_v,2) >= 2 
    x_v = (x_v(:,1) + x_v(:,2)) / 2;
end

% Tableau des fr�quences des notes MIDI
tabnotes_v = zeros(26,1);
for n = 1:26
    tabnotes_v(n) = 440*2^((n-15)/12);
end

% Fen�tre d'�tude
L_sec = 1;
N = floor(L_sec * Fs);

w_v = hann(N+1);
                     
% Bande passante �tudi�e
Fmin = 200;
Fmax = 800;

H = 10; % Nb de compressions successives du spectre
p = nextpow2(N);
Nfft = 2^p;

nbiterations = 100;
tuning_v = zeros(1,nbiterations);

for n = 1:nbiterations
    % Intervalle d'�tudes de L_sec al�atoire dans le morceau
    
    start = 1 + floor(rand(1) * (size(x_v,1) - N));
    x_abridged_v = x_v(start:start+N);
    x_abridged_v = x_abridged_v.*w_v;

    Xk_v=fft(x_abridged_v,Nfft);

    F0 = f_detect_F0(Xk_v,Nfft,H,Fs,Fmin,Fmax);

    % On cherche la note la plus proche de la fr�quence la plus pr�sente
    temp = abs(tabnotes_v - F0);
    [~,ind] = min(temp);
    
    %Facteur de drift ( 1.00 �0.03 environ)
    percent = F0/tabnotes_v(ind);
    
    % Accordage par rapport au La 440
    %accordage = 440*percent;
    tuning_v(n) = percent;
end

accordage = median(tuning_v);

end