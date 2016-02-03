% Ce script créé les bases d'observations de référence et les compare aux morceaux 
% de notre bibliothèque musicale 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

%% Fichiers de sauvegarde
FILE_s.EXPE1_OBS    = 'chroma_obs_base.mat'; % Observations chroma
FILE_s.EXPE1_CHORDS_PLAYS    = 'chords_base_plays.mat'; % Chromas par accords par morceaux 
                                                        % Matrice de chromas par accord 
                                                        % Probabilités de passage entre accords  

FILE_s.EXPE1_BASE_CREATED    = 'base_created.mat'; % Création manuelle d'une base chroma 

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

%             % Resample - 1ère méthode: ramener le morceau à l'accordage
%             % La440 Hz, n'est pas utilisée ici.
%             data_v = resample(data_v, sr_hz, floor(detune*sr_hz));
%             detune = 1;

            % Création de la base chromas et observation chromas:
            % Récupération du nom du morceau
            ind_fin=0;
            while file_id(end - ind_fin) ~= '.'
                ind_fin = ind_fin + 1 ;
            end
            ind_fin = ind_fin + 1 ;

            file_id = file_id(1:end - ind_fin); % Removes '.wav' at the end
            
            % Map name with excel file
            index=1;
            found=false;
            while strcmp(pieces_id(index,1:length(file_id)), file_id) ~= 1
                index= index+1;
            end
            if strcmp(pieces_id(index,1:length(file_id)), file_id) ~= 1
                warning('Pas de correspondance trouve entre le fichier et les noms de morceaux');
            end
            
            ind_fin= length(pieces_name(index,:));
            while strcmp(pieces_name(index,ind_fin), ' ')
                ind_fin= ind_fin - 1;
            end
            
            file_key = lower(pieces_name(index,1:ind_fin)); % Get piece name in lower case
            
            str = sprintf('%s: Calcul de la matrice des observations chroma\n', file_key);
            fprintf(1, str);

            % Calcul des matrices d'observations chroma
            addpath(directory_function); % Ajoute le répertoire pour runner la fonction
            L_n				= round(L_sec*sr_hz); % window duration in points
            STEP_n			= round(STEP_sec*sr_hz); % Hop size in points
            obs_m	= extractChroma(data_v, sr_hz, L_n, STEP_n, detune); % Extrait tous les vecteurs
                                                                         % d'observations chroma pour chaque morceau
                                                                         % avec une base de filtres recalée sur le
                                                                         % La440 avec le bon "détunage"
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

else % On charge le dictionnaire Observations pré-calculé
    fprintf(1, 'Chargement des vecteurs d''observations chromas pour tous les morceaux... \n');
	load(FILE_s.EXPE1_OBS);
end


%% Mapping avec les annotations
if 0
    fprintf(1, 'Mapping with annotations - Dictionnary with plays:\n\n')
    
    % Mapping avec les annotations
    [Accords_morceaux, Accords_mat, Proba] = mapping(Observations, STEP_sec); 
    
    % On sauve les dictionnaires
    save(FILE_s.EXPE1_CHORDS_PLAYS);
    
else % On charge les dictionnaires pré-calculés
    fprintf(1, 'Chargement des accords et des probabilités...\n')
	load(FILE_s.EXPE1_CHORDS_PLAYS);
end

Accords = containers.Map();  % Dictionnaire contenant les moyennes des chromas pour chaque accord
                             % Keys: Accords
                             % Values: vecteur chroma, moyenne de tous les vecteurs d'observations
                             % chromas correspondant
 
key_chords = Accords_mat.keys();
for k = 1:length(key_chords)
    Accords(char(key_chords(k))) = mean(Accords_mat(char(key_chords(k))),2); % On moyenne les matrices chroma
end

%% Création d'une base de référence - Alternative à l'apprentissage des Beatles
if 0
    fprintf(1, 'Création manuelle d''une autre base de chromas\n\n')
    chords_base = generateChordBase();
    save(FILE_s.EXPE1_BASE_CREATED);
else % On charge les dictionnaires pré-calculés
    fprintf(1, 'Chargement de la base créée manuellement...\n')
    load(FILE_s.EXPE1_BASE_CREATED);
end

%% Analyser la bibliothèque musicale
fprintf(1, 'Analyse de la bibliothèque musicale: \n\n');
if 1    
    directory_function = pwd; % Garde en mémoire le répertoire des fonctions
    
	% Parcours de la base de référence musicale
    cd ./The_Beatles % va dans l'ensemble des albums de la bibliothèque musicale
                     % Ici, la base des Beatles
    albums = dir(pwd); % récupère tous les albums
    ind_deb= 1;
    while strcmp(albums(ind_deb).name(1), '.')   % Enlève le '.', le '..' et le '._corp_...'
        ind_deb= ind_deb + 1;
    end
    albums = albums(ind_deb:end);
    
    c_morceaux= cell(1,1);
    
    for k = 1:1 %length(albums) % On parcourt les albums
        cd(albums(k).name) % Va dans l'album
        morceaux = dir(pwd); % On récupère les morceaux pour chaque album
        ind_deb = 1;
        while strcmp(morceaux(ind_deb).name(1), '.')   % Enlève le '.', le '..' et le '._corp_...'
            ind_deb= ind_deb + 1;
        end
        
        morceaux = morceaux(ind_deb:end);
        
        for k = 1:length(morceaux) % On parcourt les morceaux
            % On obtient name_file = name.mp3
            name_file = morceaux(k).name;
            
            % On lit le fichier .mp3
            [data_v, sr_hz] = audioread(name_file);
            data_v = data_v(:,1); % Takes only 1st channel for stereo sounds

            %--- Get file's detune
            addpath(directory_function);
            detune = f_tuning(name_file);
            rmpath(directory_function);
            
            %--- Resample - 1ère méthode: ramener le morceau à l'accordage
            %--- La440 Hz, n'est pas utilisée ici.
%             data_v = resample(data_v, sr_hz, floor(detune*sr_hz));
%             detune = 1;

            %--- Get file's tempo - 1ère méthode: analyse des chromas suivant
            %--- le tempo
            addpath(directory_function);
            [y_v, tempo_v] = f_rhythm (data_v, sr_hz); % On récupère le
                                                    % vecteur de tempo
                                                    % et le vecteur de
                                                    % diracs correspondant                                                       
            rmpath(directory_function);
            
            BPM = median(tempo_v); % Get BPM
            dir1_v = find(y_v ~= 0); % Get onsets / diracs
            
            % Création de la base chromas et calcul des observations chromas           
            % paramètres pour la détection sur le rythme
            L_sec					= 60/BPM;	% --- Analysis window duration in seconds
            STEP_sec				= L_sec/2;	% --- Analysis hop size in seconds
            data_v = data_v(dir1_v(1):end); % Le morceau démarre sur le premier onset
                                            % Pour être sûr de ne pas
                                            % être décalé

            %-- 2ème méthode, on garde les mêmes paramètres que pour
            %-- l'analyse i.e. on met en commentaire la partie ci-dessus
            % sur le rythme.
            
            % Get file_key
            ind_fin=0;
            while name_file(end - ind_fin) ~= '.'
                ind_fin = ind_fin + 1 ;
            end
            ind_fin = ind_fin + 1 ;

            file_key = name_file(1:end - ind_fin); % Removes '.mp3' at the end
            
            str = sprintf('%s: Analyse des accords\n', file_key);
            fprintf(1, str);   
            
            %-- Extrait la liste des accords et des temps de début et de
            %-- fin pour chaque accord. Méthode de comparaison directe.
            addpath(directory_function); % Ajoute le répertoire pour runner la fonction
            L_n				= round(L_sec*sr_hz); % window duration in points
            STEP_n			= round(STEP_sec*sr_hz); % Hop size in points
            [list_chords, list_chords_2, list_times]	= extractChords(data_v, sr_hz, L_n, STEP_n, detune, Accords, Proba);
            rmpath(directory_function);

            % Traduction numérique - séquences d'accords
            keys_chords = Accords_mat.keys();
            list_chords_3 = [];
            for k = 1:length(list_chords_2)
                list_chords_3 = [list_chords_3 keys_chords(list_chords_2(k))];
            end
            
            %-- Détection d'accords par HMM
            addpath(directory_function); % Ajoute le répertoire pour runner la fonction
            obs_m = extractChroma(data_v, sr_hz, L_n, STEP_n, detune); % Extrait les chromas du morceau
            path_v = HMM(Accords_mat, obs_m); % renvoie une autre séquence d'accords par HMM
            rmpath(directory_function); 
            
            % Transforme la séquence numérique en séquence d'accords
            list_chords_4 = [];
            for k = 1:length(path_v)
                list_chords_4 = [list_chords_4 keys_chords(path_v(k))];
            end
            
            % On le met dans le dictionnaire
            Chords(file_key) = list_chords_4; % On met le résultat de la HMM
            
            % creation de la structure
            nouv_morceau.name= name_file;
            nouv_morceau.fe= sr_hz;
            indice_debut=1;
            while strcmp(list_chords(indice_debut,:), 'N  ')
                indice_debut= indice_debut +1;
            end
            nouv_morceau.accords= list_chords(indice_debut:end,:);
            nouv_morceau.tempsAccords= list_times(indice_debut:end,:);
            
            % concatenation de la structure
            c_morceaux= [c_morceaux nouv_morceau];
        end
        cd ../ % Sort de l'album
    end
    % Fin du parcours des fichiers audio
    cd ../ % Sort du répertoire des albums
    
    c_morceaux= c_morceaux(2:end);
    % On sauve le dictionnaire
    save(FILE_s.EXPE1_MUSIC);
else
	load(FILE_s.EXPE1_MUSIC);
end

%% Récuperation chroma de reference
m_ordre_chords=[ 
    'C  ';
    'Db ';%
    'D  ';
    'Eb ';%
    'E  ';
    'F  ';
    'Gb ';%
    'G  ';
    'Ab ';%
    'A  ';
    'Bb ';%
    'B  ';
     
    'Cm ';        % accord mineur
    'Dbm';%
    'Dm ';
    'Ebm';%
    'Em ';
    'Fm ';
    'Gbm';%
    'Gm ';
    'Abm';%
    'Am ';
    'Bbm';%
    'Bm ';
    'N  '; % l'accords nul, si il y a un moment de silence dans le morceau
    ];

% creation des chromas de references pour la second partie
for k = 1: size(m_ordre_chords,1)
    if isKey(Accords, m_ordre_chords(k,:))
       c_chroma_ref{k}= Accords(m_ordre_chords(k,:));
    end
end
c_chroma_ref{k}= [0;0;0;0;0;0;0;0;0;0;0;0];


%clearvars -except c_chroma_ref c_morceaux 