% Programme de test pour effectuer le crossfade entre deux morceaux
f1 = 't01.wav';
f2 = 't05.wav';

% Audio de départ
[x1_v,Fs1]=audioread(f1);
% Audio de destination
[x2_v,Fs2]=audioread(f2);

% Passage en mono si audio en stéréo (ou plus)
if size(x1_v,2) >= 2 
    x1_v = (x1_v(:,1) + x1_v(:,2)) / 2;
end

if size(x2_v,2) >= 2 
    x2_v = (x2_v(:,1) + x2_v(:,2)) / 2;
end

% Temps de départ et de fin pour le premier morceau
t1_start = floor(87.5 * Fs1);
t1_end = floor(98.6 * Fs1);

% Temps de départ pour le deuxième
% Le temps de fin est relatif au facteur de timestretch calculé après
t2 = floor(70.2 * Fs2);

x2_v = resample(x2_v,Fs1,Fs2);

if t2 ~= 1
    t2 = floor(t2 * Fs1 / Fs2);
end

[y_v, ts_factor] = f_crossfade...
    (x1_v, x2_v, Fs1, t1_start, t1_start + floor(length(x2_v)/3), t2);

% On lance la lecture avec play(player), on arrête avec stop(player)
player = audioplayer(y_v,Fs1);