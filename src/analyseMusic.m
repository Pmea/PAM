% Ce script créé les bases d'observations de référence et les compare 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

%% Fichiers de sauvegarde
FILE_s.EXPE1_OBS    = 'chroma_obs_base.mat'; % Observations chroma
FILE_s.EXPE1_CHORDS_PLAYS    = 'chords_base_plays.mat'; % Accords par morceaux
FILE_s.EXPE1_CHORDS    = 'chords_base.mat'; % Accords globaux
FILE_s.EXPE1_PROBA_CHORDS    = 'proba_chords.mat'; % Probas de passage d'un accord à l'autre
FILE_s.EXPE1_MUSIC    = 'music.mat'; % Analyse par accords pour bibliothèque musicale 

%% Parameters
L_sec					= 0.2;	% --- Analysis window duration in seconds
STEP_sec				= 0.1;	% --- Analysis hop size in seconds

Observations = containers.Map(); % Dictionnaire contenant les vecteurs d'observations chromas pour tous les morceaux
                                 % Keys: noms des morceaux
                                 % Values: matrices d'observations chromas

Chords = containers.Map(); % Dictionnaire contenant les accords pour chaque morceau
                           % Keys: noms des morceaux
                           % Values: liste contenant les accords détectés
                           % et leur temps de début et de fin

%% Extraction des vecteurs d'observation chromas 
if 0
    fprintf(1, 'Calcul des vecteurs d''observations chromas pour tous les morceaux: \n\n');
    directory_function = pwd; % Garde en mémoire le répertoire des fonctions
    
    % Read Excel file
    %[numbers, pieces_id, everything] = xlsread('Corp_Beatles.xls', 'A:A'); % Get ID of pieces
    %[numbers, pieces_name, everything] = xlsread('Corp_Beatles.xls', 'E:E'); % Get name of pieces
    corres_piste_titre=tdfread('Corp_Beatles.csv', 'semi');
    pieces_id= corres_piste_titre.mediaID;
    pieces_name= corres_piste_titre.title;
    
	% Parcours de la base de référence musicale
    cd ./The_Beatles % va dans l'ensemble des albums
    albums = dir(pwd); % récupère tous les albums
    ind_deb= 1;
    while strcmp(albums(ind_deb).name(1), '.')   % Enlève le '.', le '..' et le '._corp_...'
        ind_deb= ind_deb + 1;
    end
    albums = albums(ind_deb:end);
    
    for k = 1:length(albums) % On parcourt les albums
        cd(albums(k).name) % Va dans l'album
        morceaux = dir(pwd); % On récupère les morceaux pour chaque album
        
        ind_deb= 1;
        while strcmp(morceaux(ind_deb).name(1), '.')   % Enlève le '.', le '..' et le '._corp_...'
            ind_deb= ind_deb + 1;
        end
        morceaux = morceaux(ind_deb:end);
        
        for k = 1:length(morceaux) % On parcourt les morceaux
            % On obtient name_file = name.wav
            file_id = morceaux(k).name; % fichier.wav
            
            % On lit le fichier .mp3
            [data_v, sr_hz] = audioread(file_id);
            data_v = data_v(:,1); % Takes only 1st channel for stereo sounds

            % Get file's detune
            addpath(directory_function);
            detune = f_tuning(file_id);
            rmpath(directory_function);

%             % Resample
%             data_v = resample(data_v, sr_hz, floor(detune*sr_hz));
%             detune = 1;

%             % Calcul du tempo
%             addpath(directory_function);
%             [y_v, tempo_v] = f_rhythm(data_v(1:10000), sr_hz);
%             rmpath(directory_function);
%             tempo = mean(tempo_v);
%             figure();
%             plot(1:length(tempo_v), tempo_v);
            
            % Création de la base chromas et observation chromas 
            file_id = file_id(1:end-4); % Removes '.wav' at the end
            
            % Map name with excel file
            index=1;
            found=false;
            while strcmp(pieces_id(index,1:length(file_id)), file_id) ~= 1
                index= index+1;
            end
            if strcmp(pieces_id(index,1:length(file_id)), file_id) ~= 1
                warning('Pas de correspondance trouve entre le fichier et les noms de morceaux');
            end
            
            %[truefalse, index] = ismember(file_id, pieces_id); % Returns the index of the id  
            ind_fin= length(pieces_name(index,:));
            while strcmp(pieces_name(index,ind_fin), ' ')
                ind_fin= ind_fin - 1;
            end
            
            file_key = lower(pieces_name(index,1:ind_fin)); % Get piece name in lower case
            
            str = sprintf('%s: Calcul de la matrice des observations chroma\n', file_key);
            fprintf(1, str);

            addpath(directory_function); % Ajoute le répertoire pour runner la fonction
            L_n				= round(L_sec*sr_hz); % window duration in points
            STEP_n			= round(STEP_sec*sr_hz); % Hop size in points
            obs_m	= extractChroma(data_v, sr_hz, L_n, STEP_n, detune);
            rmpath(directory_function);
            
            % On le met dans le dictionnaire
            Observations(file_key) = obs_m;
        end
        
        cd ../ % Sort de l'album
    end
    % Fin du parcours des fichiers audio
    cd ../ % Sort du répertoire des albums
    
    % On sauve le dictionnaire
    save(FILE_s.EXPE1_OBS);
else
    fprintf(1, 'Chargement des vecteurs d''observations chromas pour tous les morceaux... \n');
	load(FILE_s.EXPE1_OBS);
end


%% Mapping avec les annotations
if 0
    fprintf(1, 'Mapping with annotations - Dictionnary with plays:\n\n')
    [Accords_morceaux, Accords, Accords_mat, Proba] = mapping(Observations, STEP_sec);    
    
    % On sauve le dictionnaire
    save(FILE_s.EXPE1_CHORDS_PLAYS);
    save(FILE_s.EXPE1_CHORDS);
    save(FILE_s.EXPE1_PROBA_CHORDS);
else
    fprintf(1, 'Chargement des accords et des probabilités...\n')
	load(FILE_s.EXPE1_CHORDS_PLAYS);
    load(FILE_s.EXPE1_CHORDS);
    load(FILE_s.EXPE1_PROBA_CHORDS);
end

Accords_mat_2 = containers.Map(); % Dictionnaire contenant les moyennes des chromas des accords
keykey = Accords_mat.keys();
for k = 1:length(keykey)
    Accords_mat_2(char(keykey(k))) = mean(Accords_mat(char(keykey(k))),2);
end

%% Analyser la bibliothèque musicale
fprintf(1, 'Analyse de la bibliothèque musicale\n\n');
if 1
    directory_function = pwd; % Garde en mémoire le répertoire des fonctions
    
	% Parcours de la base de référence musicale
    cd ./The_Beatles % va dans l'ensemble des albums de la bibliothèque musicale
    albums = dir(pwd); % récupère tous les albums
    ind_deb= 1;
    while strcmp(albums(ind_deb).name(1), '.')   % Enlève le '.', le '..' et le '._corp_...'
        ind_deb= ind_deb + 1;
    end
    albums = albums(ind_deb:end);
    
    %c_morceaux= cell();
    
    for k = 1:1%length(albums) % On parcourt les albums
        cd(albums(k).name) % Va dans l'album
        morceaux = dir(pwd); % On récupère les morceaux pour chaque album
        ind_deb= 1;
        while strcmp(morceaux(ind_deb).name(1), '.')   % Enlève le '.', le '..' et le '._corp_...'
            ind_deb= ind_deb + 1;
        end
        
        morceaux = morceaux(ind_deb:end);
        
        for k = 1:1%length(morceaux) % On parcourt les morceaux
            % On obtient name_file = name.mp3
            name_file = morceaux(k).name;
            
            % On lit le fichier .mp3
            [data_v, sr_hz] = audioread(name_file);
            data_v = data_v(:,1); % Takes only 1st channel for stereo sounds

            % Get file's detune
            addpath(directory_function);
            detune = f_tuning(name_file);
            rmpath(directory_function);
            
%             data_v = resample(data_v, sr_hz, floor(detune*sr_hz));
%             detune = 1;
            
            % Création de la base chromas et observation chromas 
            file_key = name_file(1:end-4); % Removes '.mp3' at the end
            str = sprintf('%s: Analyse des accords\n', file_key);
            fprintf(1, str);   
            
            addpath(directory_function); % Ajoute le répertoire pour runner la fonction
            L_n				= round(L_sec*4*sr_hz); % window duration in points
            STEP_n			= round(STEP_sec*4*sr_hz); % Hop size in points
            [list_chords, list_times]	= extractChords(data_v, sr_hz, L_n, STEP_n, detune, Accords_mat_2, Proba);
            rmpath(directory_function);
            
            % Détection d'accords par HMM
            addpath(directory_function); % Ajoute le répertoire pour runner la fonction
            obs_m = extractChroma(data_v, sr_hz, L_n, STEP_n, detune);
            path_v = HMM(Accords_mat, obs_m);
            rmpath(directory_function); % Ajoute le répertoire pour runner la fonction

            % On le met dans le dictionnaire
            Chords(file_key) = list_chords;
            
            % creation de la structure
            nouv_morceau.name= name_file;
            nouv_morceau.fe= sr_hz;
            nouv_morceau.accords= list_chords;
            nous_morceau.temps_accords= list_times;
            
            % concatenation de la structure
            c_morceaux= [c_morceaux nouv_morceau];
        end
        cd ../ % Sort de l'album
    end
    % Fin du parcours des fichiers audio
    cd ../ % Sort du répertoire des albums
    
    % On sauve le dictionnaire
    save(FILE_s.EXPE1_MUSIC);
else
	load(FILE_s.EXPE1_MUSIC);
end

%% recuperation chroma de reference

m_ordre_chords=[          
    'C  ';
    'C# ';% meme note
    'Db ';%
    'D  ';
    'D# ';%
    'Eb ';%
    'E  ';
    'F  ';
    'F# ';%
    'Gb ';%
    'G  ';
    'G# ';%
    'Ab ';%
    'A  ';
    'A# ';%
    'Bb ';%
    'B  ';
     
    'Cm ';        % accord mineur
    'C#m';%
    'Dbm';%
    'Dm ';
    'D#m';%
    'Ebm';%
    'Em ';
    'Fm ';
    'F#m';%
    'Gbm';%
    'Gm ';
    'G#m';%
    'Abm';%
    'Am ';
    'A#m';%
    'Bbm';%
    'Bm ';
    ];

for k = 1: size(m_ordre_chords,1)
    c_chroma_ref= Accords_mat(m_ordre_chords(k));
end

%clearvars -except c_chroma_ref c_morceaux  %pour la version final