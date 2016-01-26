function [list_chords, list_times] = extractChroma(data_v, sr_hz, L_n, STEP_n, detune, Accords, Proba)
% 1) Creates a base of vectors chromas for the file
% 2) At each time of the audio input signal, extracts an observation vector of type Chroma
% and compares to the chords in the base

% display = 1 in parameters enables display of filters H and Chroma C.


%% Parameters
Nfft = 4*2^nextpow2(L_n); % Number of points for fft > L_n = length of 
                          % the window, zero-padding rate = 4 > 1
n = 35:95; % MIDI notes we want to filter and to detect
freq_v = (((1:Nfft/2+1)-1)/Nfft*sr_hz); % positive semi-axe of frequencies, 
                                        % Nfft/2+1 frequencies
display = 0; % If display = 1, display semitones filters and chroma filters

list_chords = []; % Liste des accords

list_times = []; % Liste des temps de d�but et de fin associ�s aux accords

%% 1st part: Filters matrix creation 
data_midi_v = 12*log2(freq_v/(440*detune))+69; % Mapping between frequencies and MIDI notes
                                               % Correction of detune

% Filters and Chromas
H_m = zeros(length(n), Nfft/2+1); % Filters for each semitone
C_m = zeros(12, Nfft/2+1); % Filters for each chroma (sum of filters of 
                           % same class's semitones)

for k = 1:length(n)
    H_m(k,:) = 1/2*tanh(pi*(1-2*abs(n(k)-data_midi_v))) + 1/2;
    
    l = mod(n(k), 12)+1; % same class's semtitones
    C_m(l,:) = C_m(l,:)+H_m(k,:);
end

% Display filters H and C
if display
    % Display H
    for k = 1:length(n)     
        figure();
        plot(freq_v, H_m(k,:));
        xlabel('Frequency');
        ylabel('Amplitude');
        xlim([0 2000]);
        str = sprintf('n = %d', n(k));
        title(str);
    end
    
    % Display C
    for k = 1:size(C_m,1)
        figure();
        plot(freq_v, C_m(k,:));
        xlabel('Frequency');
        ylabel('Amplitude');
        xlim([0 2000]);
        str = sprintf('c = %d', k);
        title(str);
    end
end        

% Normalisation
for k = 1:12
    C_m(k,:) = C_m(k,:)/norm(C_m(k,:));
end

% Display results
if display
    figure();
    imagesc(freq_v, (1:12), C_m);
    xlim([0 2000]);
    xlabel('Frequency');
    ylabel('Chroma');
    title('Chromas filters');
end

%% 2nd part: Chromagram with sliding window 
% Parameters
black_v = blackman(L_n); % Blackman window of length L_n
ending = length(data_v)-L_n; % Loop ends when sliding > length(data_v)-L_n
total_nb_trames = floor(ending/STEP_n);

obs_m = zeros(12, total_nb_trames);
nb_trames = 1;

% Parameters for dictionnary
former_chord = 'N'; % In case we have same chords following
begin = 1; % Begin of the chord

% Treatment of data_v with sliding window
for sliding = 1:STEP_n:ending
    % Take play's chroma
    trame_v = data_v(sliding:sliding+L_n-1).*black_v;
    trame_fft_v = abs(fft(trame_v, Nfft)); 
    trame_fft_v = trame_fft_v(1:Nfft/2+1); % Only semi-positive axe interests us    
    obs_m(:, nb_trames) = (C_m*trame_fft_v);
    x_v = (C_m*trame_fft_v)'; % row vector - chroma
    
    % Comparaison with database's chords
    chords_keys = Accords.keys();
    distance_max = 0;
    chord = 'N';

    for k = 1:length(chords_keys)
        y_v = Accords(char(chords_keys(k))); % colmun vector - database's chord chroma

        % Cosinusoidal distance
        num = x_v*y_v; % numerator of the distance
        denum = sqrt(x_v*x_v')*sqrt(y_v'*y_v)+eps; % denominator of the distance, +eps to avoid denum = 0
        dist_chords = num/denum; % distance between chords

        % Compare with other chords
        if dist_chords > distance_max
            chord = char(chords_keys(k));
            distance_max = dist_chords;
        end
    end
    
    % Same chord ?
    if ~strcmp(chord, former_chord) % Si on a chang� d'accord
        if abs(begin/sr_hz-sliding/sr_hz)>0.2
            list_chords = [list_chords, former_chord];
            list_times = [list_times; begin/sr_hz sliding/sr_hz];
            begin = sliding;
        end
    end
         
    former_chord = chord;
    nb_trames = nb_trames + 1;
end

%% Display chroma observation matrix - Question 2.3
if display
    figure();
    imagesc(obs_m);
    title('Matrice d''observations chromas');
    xlabel('Nb frames');
    ylabel('Chromas');
end

end
