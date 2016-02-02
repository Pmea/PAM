% Ce script cr�� les bases d'observations de r�f�rence et les compare 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

%% Fichiers de sauvegarde
FILE_s.EXPE1_OBS    = 'chroma_obs_base.mat'; % Observations chroma
FILE_s.EXPE1_CHORDS_PLAYS    = 'chords_base_plays.mat'; % Accords par morceaux
FILE_s.EXPE1_CHORDS    = 'chords_base.mat'; % Accords globaux
FILE_s.EXPE1_PROBA_CHORDS    = 'proba_chords.mat'; % Probas de passage d'un accord � l'autre
FILE_s.EXPE1_MUSIC    = 'music.mat'; % Analyse par accords pour biblioth�que musicale 

%% Parameters
L_sec					= 0.2;	% --- Analysis window duration in seconds
STEP_sec				= 0.1;	% --- Analysis hop size in seconds

Observations = containers.Map(); % Dictionnaire contenant les vecteurs d'observations chromas pour tous les morceaux
                                 % Keys: noms des morceaux
                                 % Values: matrices d'observations chromas

Chords = containers.Map(); % Dictionnaire contenant les accords pour chaque morceau
                           % Keys: noms des morceaux
                           % Values: liste contenant les accords d�tect�s
                           % et leur temps de d�but et de fin

%% Extraction des vecteurs d'observation chromas 
if 0
    fprintf(1, 'Calcul des vecteurs d''observations chromas pour tous les morceaux: \n\n');
    directory_function = pwd; % Garde en m�moire le r�pertoire des fonctions
    
    % Read Excel file
    corres_piste_titre=tdfread('Corp_Beatles.csv', 'semi');
    pieces_id= corres_piste_titre.mediaID;
    pieces_name= corres_piste_titre.title;
    
	% Parcours de la base de r�f�rence musicale
    cd ./The_Beatles % va dans l'ensemble des albums
    albums = dir(pwd); % r�cup�re tous les albums
    ind_deb= 1;
    while strcmp(albums(ind_deb).name(1), '.')   % Enl�ve le '.', le '..' et le '._corp_...'
        ind_deb= ind_deb + 1;
    end
    albums = albums(ind_deb:end);
    
    for k = 1:length(albums) % On parcourt les albums
        cd(albums(k).name) % Va dans l'album
        morceaux = dir(pwd); % On r�cup�re les morceaux pour chaque album
        
        ind_deb= 1;
        while strcmp(morceaux(ind_deb).name(1), '.')   % Enl�ve le '.', le '..' et le '._corp_...'
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

            % Cr�ation de la base chromas et observation chromas 
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

            addpath(directory_function); % Ajoute le r�pertoire pour runner la fonction
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
    cd ../ % Sort du r�pertoire des albums
    
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
    
    if isKey(Accords_mat, 'N  ')
        remove(Accords_mat, 'N  ');
     end
    if isKey(Accords, 'N  ')
        remove(Accords, 'N  ');
    end
    
    % On sauve le dictionnaire
    save(FILE_s.EXPE1_CHORDS_PLAYS);
    save(FILE_s.EXPE1_CHORDS);
    save(FILE_s.EXPE1_PROBA_CHORDS);
else
    fprintf(1, 'Chargement des accords et des probabilit�s...\n')
	load(FILE_s.EXPE1_CHORDS_PLAYS);
    load(FILE_s.EXPE1_CHORDS);
    load(FILE_s.EXPE1_PROBA_CHORDS);
end

% Dictionnaire contenant les moyennes des chromas des accords
Accords_mat_2 = containers.Map(); 
keykey = Accords_mat.keys();
for k = 1:length(keykey)
    Accords_mat_2(char(keykey(k))) = nanmean(Accords_mat(char(keykey(k))),2);
end

%% Analyser la biblioth�que musicale
fprintf(1, 'Analyse de la biblioth�que musicale\n\n');
if 0
    directory_function = pwd; % Garde en m�moire le r�pertoire des fonctions
    
	% Parcours de la base de r�f�rence musicale
    cd ./The_Beatles % va dans l'ensemble des albums de la biblioth�que musicale
    albums = dir(pwd); % r�cup�re tous les albums
    ind_deb= 1;
    while strcmp(albums(ind_deb).name(1), '.')   % Enl�ve le '.', le '..' et le '._corp_...'
        ind_deb= ind_deb + 1;
    end
    albums = albums(ind_deb:end);
    
    c_morceaux= cell(1,1);
    
    for k = 1:1%length(albums) % On parcourt les albums
        cd(albums(k).name) % Va dans l'album
        morceaux = dir(pwd); % On r�cup�re les morceaux pour chaque album
        ind_deb = 1;
        while strcmp(morceaux(ind_deb).name(1), '.')   % Enl�ve le '.', le '..' et le '._corp_...'
            ind_deb= ind_deb + 1;
        end
        
        morceaux = morceaux(ind_deb:end);
        
        for k = 1:length(morceaux) % On parcourt les morceaux
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

           % Get file's tempo
%             addpath(directory_function);
%             [y_v, tempo_v] = f_rhythm (data_v, sr_hz);
%             rmpath(directory_function);
%             
%             med = median(tempo_v); % Get BPM
%             dir1_v = find(y_v ~= 0); % Get onsets
            
           % Cr�ation de la base chromas et calcul des observations chromas           
           % param�tres pour la d�tection sur le rythme
           L_sec					= 0.2; %60/med;	% --- Analysis window duration in seconds
           STEP_sec				= L_sec/2;	% --- Analysis hop size in seconds
%           data_v = data_v(dir1_v(1):end); % Le morceau d�marre sur le premier onset
            
            ind_fin=0;
            while name_file(end - ind_fin) ~= '.'
                ind_fin = ind_fin + 1 ;
            end
            ind_fin = ind_fin + 1 ;

            file_key = name_file(1:end - ind_fin); % Removes '.mp3' at the end
            
            str = sprintf('%s: Analyse des accords\n', file_key);
            fprintf(1, str);   

            addpath(directory_function); % Ajoute le r�pertoire pour runner la fonction
            L_n				= round(L_sec*sr_hz); % window duration in points
            STEP_n			= round(STEP_sec*sr_hz); % Hop size in points
            [list_chords, list_times]	= extractChords(data_v, sr_hz, L_n, STEP_n, detune, Accords_mat_2, Proba);
            rmpath(directory_function);
            
            % D�tection d'accords par HMM
            addpath(directory_function); % Ajoute le r�pertoire pour runner la fonction
            obs_m = extractChroma(data_v, sr_hz, L_n, STEP_n, detune);
            path_v = HMM(Accords_mat, obs_m);
            rmpath(directory_function); % Ajoute le r�pertoire pour runner la fonction
    
            keys_chords = Accords_mat.keys();
            list_chords_2 = [];
            for k = 1:length(path_v)
                list_chords_2 = [list_chords_2 keys_chords(path_v(k))];
            end
            
            % On le met dans le dictionnaire
            Chords(file_key) = list_chords;
            
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
    cd ../ % Sort du r�pertoire des albums
    
    c_morceaux= c_morceaux(2:end);
    % On sauve le dictionnaire
    save(FILE_s.EXPE1_MUSIC);
else
	load(FILE_s.EXPE1_MUSIC);
end

%% recuperation chroma de reference

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
    'N  '; % faut il ajouter a la detection
    ];
for k = 1: size(m_ordre_chords,1)
    if isKey(Accords_mat_2, m_ordre_chords(k,:))
       c_chroma_ref{k}= Accords_mat_2(m_ordre_chords(k,:));
    end
end
c_chroma_ref{k}= [0;0;0;0;0;0;0;0;0;0;0;0];


clearvars -except c_chroma_ref c_morceaux %pour la version final