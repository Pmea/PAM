function [y_v, ts_factor] = f_crossfade ...
    (x1_v, x2_v, Fs1, Fs2, t1_start, t1_end, t2)

x2_v = resample(x2_v,Fs1,Fs2);

if t2 ~= 1
    t2 = floor(t2 * Fs1 / Fs2);
end

x1_v = x1_v(t1_start:t1_end);
x2_v = x2_v(t2:t2 + floor(1.4 * (t1_end - t1_start)));

% Vecteur du crossfade, fonction de type 1/(.9+x) - 1/10
% Égale à 1 au début du vecteur et 0 à la fin,
% avec une décroissance "naturelle" à l'oreille humaine

% Calcul tempo et diracs
[dir1_v,tempo1_v] = f_rhythm (x1_v, Fs1);
[dir2_v,tempo2_v] = f_rhythm (x2_v, Fs1);
period1_v = find(dir1_v ~= 0);
period2_v = find(dir2_v ~= 0);

% plot(tempo1_v)
% pause;
% plot(tempo2_v)
% pause;

% On fait la dérivation des intervalles des Dirac (périodes)
period1_v = diff(period1_v);
period2_v = diff(period2_v);

% On récupère la période médiane
period1_n = median(period1_v);
period2_n = median(period2_v);


% Timestretch
%ts_factor = 1;

ts_factor = period1_n / period2_n;

while ts_factor > 1.33
    ts_factor = ts_factor / 2;
end

while ts_factor < .67
    ts_factor = ts_factor * 2;
end

ts_factor

x2_v = f_timestretch(x2_v, ts_factor);

% Alignement des diracs


% Génération du vecteur de crossfade
L_n = t1_end - t1_start + 1;
cross_factor_v = (1:L_n);
cross_factor_v = cross_factor_v/L_n*9;
cross_factor_v = 1./(.9+cross_factor_v) - 1/10;
cross_factor_v = cross_factor_v.';

% On effectue le crossfade
size(x1_v)
size(cross_factor_v)
x2_v = x2_v(1:t1_end-t1_start+1);
size(x2_v)

y_v = x1_v .* cross_factor_v + x2_v .* (1-cross_factor_v);

end