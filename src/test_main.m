% Programme de transitions entre les morceaux

Fs = 44100;

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

x_v = f_fadein(x_v, 4 * Fs);

t1_start = floor( length(x_v) / 2);
t1_end = length(x_v) - 1;

N = length(x_v);

for k = 2 : 4
    disp(filenames(k));
    [x2_v,Fs_temp]=audioread(filenames{k});

    if size(x2_v,2) >= 2 
        x2_v = (x2_v(:,1) + x2_v(:,2)) / 2;
    end
    
    x2_v = resample(x2_v,Fs,Fs_temp);
    
    % On commence au début du morceau
    t2 = 1;
    [x_v , ts_factor] = f_crossfade (x_v, x2_v, Fs, t1_start, t1_end, t2);
    N + length(x2_v) * ts_factor + t1_end - t1_start
    N = length(x_v)
    
    t1_start = length(x_v) - 5 * Fs;
    t1_end = length(x_v) - 1;
end