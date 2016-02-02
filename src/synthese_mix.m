% Programme de transitions entre les morceaux
Fs = 44100;

% On récupère les fichiers du dossier courant pour former le mix
% On les lit par ordre alphabétique
directory = dir;
filenames = {directory.name};
findfiles = strfind(filenames,'.wav');
emptyCells = cellfun('isempty',findfiles);
notemptyCells = ~emptyCells;
filenames = filenames(notemptyCells);

disp(filenames(1));
[x_v, Fs_temp] = audioread( filenames{1} );

if size(x_v,2) >= 2 
    x_v = (x_v(:,1) + x_v(:,2)) / 2;
end

x_v = resample(x_v,Fs,Fs_temp);
% On effectue un fadein sur 2 secondes
x_v = f_fadein(x_v, 2 * Fs);

t1_start = floor(length(x_v) / 4);
t1_end = floor( length(x_v) * 3 / 4);

N = length(x_v);

for k = 2 : length(filenames)
    disp(filenames(k));
    [x2_v,Fs_temp]=audioread(filenames{k});

    % On passe le signal en mono et à la même fréquence d'échantillonnage
    if size(x2_v,2) >= 2 
        x2_v = (x2_v(:,1) + x2_v(:,2)) / 2;
    end
    x2_v = resample(x2_v,Fs,Fs_temp);
    
    % On commence au début du morceau
    t2 = 1;
    % On effectue la transition
    [x_v , ts_factor] = f_crossfade (x_v, x2_v, Fs, t1_start, t1_end, t2);
    N = length(x_v);
    
    t1_start = N - floor(length(x2_v) / 2);
    t1_start = max([1 t1_start]);
    t1_end = length(x_v) - 1;
end

% On lance la lecture avec un play(player), on arrête avec stop(player)
player = audioplayer(x_v, Fs);