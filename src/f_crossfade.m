function [y_v, ts_factor] = f_crossfade ...
    (x1_v, x2_v, Fs1, t1_start, t1_end, t2)

% On modifie les indices pour ne pas sortir du tableau
t1_start = max([1 t1_start]);
t1_end = min([length(x1_v) t1_end]);
t2 = max([1 t2]);

if t1_end - t1_start > length(x2_v(t2:end))
    t1_end = t1_start + length(x2_v(t2:end));
end

x1temp_v = x1_v(t1_start:t1_end);

t2_end = t2 + t1_end - t1_start;
t2_end = min([length(x2_v) t2_end]);

x2temp_v = x2_v(t2: t2_end);

% Calcul tempo et diracs
[dir1_v,~] = f_rhythm (x1temp_v, Fs1);
[dir2_v,~] = f_rhythm (x2temp_v, Fs1);

dir1_v = find(dir1_v ~= 0);
dir2_v = find(dir2_v ~= 0);

% On fait la dérivation des intervalles des Dirac (périodes)
period1_v = diff(dir1_v);
period2_v = diff(dir2_v);

% On récupère la période médiane
period1_n = median(period1_v);
period2_n = median(period2_v);

% Timestretch

ts_factor = period1_n / period2_n;
% On ramène le facteur à 1 si il y a une erreur dans le calcul des périodes
ts_factor = max([isnan(ts_factor) ts_factor]);

while ts_factor > 1.33
    ts_factor = ts_factor / 2;
end

while ts_factor < .67
    ts_factor = ts_factor * 2;
end

x2_v = f_timestretch(x2_v, ts_factor);


% Alignement des diracs
if size(dir1_v,1) == 0
    phase = 1;
else
    phase = ceil(dir2_v(1) * ts_factor) - dir1_v(1);
end

while phase <= 0
    phase = floor(phase + period1_n); 
end

x2_v = x2_v (phase : end);


% On effectue le crossfade
t2 = max([1 round(t2 * ts_factor)]);
t2_end = min([length(x2_v) (t2 + length(x1temp_v) - 1)]);

x2temp_v = x2_v( t2 : t2_end);
x1temp_v = x1temp_v(1:length(x2temp_v));

% Vecteur du crossfade, fonction de type 1/(.9+x) - 1/10
% Égale à 1 au début du vecteur et 0 à la fin,
% avec une décroissance "naturelle" à l'oreille humaine
L_n = length(x1temp_v);
cross_factor_v = (1 : L_n) / L_n * 9;
cross_factor_v = 1 ./ (.9 + cross_factor_v) - 1/10;
cross_factor_v = cross_factor_v.';


y_v = x1temp_v .* cross_factor_v + x2temp_v .* (1 - cross_factor_v);

if t1_start > 1
    y_v = [x1_v(1 : t1_start - 1) ; y_v];
end

y_v = [y_v ; x2_v(t2_end + 1: end)];

end