function F0 = f_detect_F0(Xk,Nfft,H,Fs,Fmin,Fmax)

% Plage d'étude
Nmin = floor(Fmin/Fs*Nfft);
Nmax = floor(Fmax/Fs*Nfft);

Rmax = floor((Nfft-1)/2/H);
P = ones(Rmax,1);
for h=1:H
    DecimXk = Xk(1:h:Nfft/2);
    P = P.*DecimXk(1:Rmax);
end

[~,F0] = max(abs(P(Nmin:Nmax)));

% On additionne Nmin car P(Nmin:Nmax) voit
% son premier indice démarrer à Nmin, on recentre donc le F0 trouvé

F0 = F0 + (Nmin-1);
F0 = F0*Fs/Nfft;

end