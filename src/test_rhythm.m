% Lecture du signal
% Passage en mono si audio en st�r�o (ou plus)

directory = dir;
filenames = {directory.name};
findfiles = strfind(filenames,'.wav');
emptyCells = cellfun('isempty',findfiles);
notemptyCells = ~emptyCells;
filenames = filenames(notemptyCells);

tic

% Audio de d�part
for k = 1:length(filenames)
    disp(filenames(k));
    [x_v,Fs]=audioread(filenames{k});

    if size(x_v,2) >= 2 
        x_v = (x_v(:,1) + x_v(:,2)) / 2;
    end
    
    x_v = resample(x_v,44100,Fs);
    
    [y_v, tempo_v] = f_rhythm(x_v, 44100);
    
end

toc