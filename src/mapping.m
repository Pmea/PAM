function [Accords_morceaux, Accords, Accords_mat, Proba] = mapping(Observations, STEP_sec)
% Fait le mapping entre les annotations et les accords
% 1) pour chaque morceaux, on a le dictionnaire Accords_morceaux
% 2) Regroupe les accords dans Accords
% 3) Calcule les probabilit� de passage d'un accord � l'autre

Accords_morceaux = containers.Map(); % Dictionnaire contenant pour chaque morceau les chromas de r�f�rence pour tous les accords
                                     % Keys: nom des morceaux
                                     % Values: Dictionnaire avec les noms
                                     % d'accords et les chromas associ�s

Accords = containers.Map(); % Dictionnaire contenant les chromas de r�f�rence pour chaque accord
                            % Keys: Accords
                            % Values: chromas associ�s
                            
Accords_mat = containers.Map();

Proba = containers.Map(); % Dictionnaire contenant les probabilit�s de passage d'un accord � l'autre
                          % Keys: Accords sachant qu'il y a eu un autre
                          % accord
                          % Values: valeur de probabilit�

Proba_tot = containers.Map(); % Dictionnaire contenant le nombre total d'�v�nements
                              % Keys: Accords
                              % Values: nombre de fois qu'il a �t�
                              % rencontr�
                              
%% Trouve les annotations - lanc� depuis le r�pertoire courant
% Parcours de la base de r�f�rence musicale
cd ./The_Beatles_annot % va dans l'ensemble des annotations des albums
albums = dir(pwd); % r�cup�re les annotations de tous les albums

ind_deb= 1;
while strcmp(albums(ind_deb).name(1), '.')   % Enl�ve le '.', le '..' et le '._corp_...'
    ind_deb= ind_deb + 1;
end
albums = albums(ind_deb:end);

for k = 1:length(albums) % On parcourt les albums
    cd(albums(k).name) % Va dans l'album
    annots = dir('*.lab'); % On r�cup�re les annotations des morceaux
                           % pour chaque album
    
    for k = 1:length(annots) % On parcourt les annotations de chaque morceaux
        name_file = annots(k).name;        
        
        % Read annotations
        fileID = fopen(name_file, 'r'); % read file
        formatSpec = '%f %f %s';
        
        data = textscan(fileID, formatSpec);
        fclose(fileID);
        
        debut = data{1,1}; % Temps de d�but
        fin = data{1,2}; % Temps de fin
        chords = data{1,3}; % Accord
        nb_lines = length(debut); % Nb de lignes dans le document,
        % peut aussi �tre length(fin) ou length(notes)
        
        % Retrouve la matrice d'observations chroma correspondante
        name_file = name_file(6:end-4); % remove 01_-_ and '.lab'
        name_file = lower(strrep(name_file, '_', ' ')); % Met au m�me format que les titres
        
        % Affiche o� on est
        str = sprintf('Mapping with annotations: %s\n', name_file);
        fprintf(1, str);

        if isKey(Observations, name_file) % s'il est d�j� pr�sent
        % Extrait la matrice d'observations chroma correspondante
            obs_m = Observations(name_file); % A changer suivant le nom des fichiers
        else
            warning(name_file);
            break;
        end
        
        %% Mapping
        accords = containers.Map(); % Ensemble d'accords pour chaque morceau
        former_chord = 'N';
        
        for k = 2:nb_lines-1 % Commence par N et finit par N
            
            % Trames de d�but et de fin
            if floor(debut(k)/STEP_sec) == debut(k)/STEP_sec % Cas entier
                deb_trame = debut(k)/STEP_sec; % debut en trames
            else
                deb_trame = floor(debut(k)/STEP_sec) + 1; % debut en trames
            end
            if floor(fin(k)/STEP_sec) == fin(k)/STEP_sec % Cas entier
                fin_trame = fin(k)/STEP_sec; % fin en trames
            else
                fin_trame = floor(fin(k)/STEP_sec) + 1; % fin en trames
            end
            
            % R�cup�ration de l'accord
            chord = chords{k}; % Accord - string
            min_chord = strfind(chord, ':mi'); % renvoie l'index du mineur
            if isempty(min_chord) % Si il n'y a pas de mineur
                if length(chord) == 2 && (chord(2) == 'b' || chord(2) == '#') % Case b or #
                    chord = [chord(1:2), ' '];
                else % Other case
                    chord = [chord(1), '  '];
                end
            else % Cas mineur, on enl�ve le ':'
                chord = strcat(chord(1:min_chord-1), 'm');
                if chord(2) ~= 'b' && chord(2) ~= '#'
                    chord = [chord(1:2), ' '];
                end
            end
            
            % Mapping # - b
            if length(chord) > 1 && chord(2) == '#'
                if chord(1) == 'G'
                    chord(1) = 'A';
                else
                    chord(1) = char(chord(1)+1); % lettre sup�rieure
                end
                chord(2) = 'b';
            end
            
            if chord(1) == 'N'
                break;
            end
            
%             min_chord = strfind(chord, ':'); % renvoie l'index du mineur
%             if ~isempty(min_chord) % S'il y a un ':'
%                 chord = strcat(chord(1:min_chord-1), chord(min_chord+1:end));
%             end

           chroma = mean(obs_m(:, deb_trame:fin_trame), 2); % On moyenne les chromas correspondant

            % Matrice d'observations des accords
            if isKey(Accords_mat, chord) % s'il est d�j� pr�sent
                Accords_mat(chord) = [Accords_mat(chord) obs_m(:, deb_trame:fin_trame)];
            else
                Accords_mat(chord) = obs_m(:, deb_trame:fin_trame);
            end
            
            % D�j� rencontr� ? - Accords pour chaque morceau
            if isKey(accords, chord) % s'il est d�j� pr�sent
                accords(chord) = (accords(chord)+chroma)/2; % On moyenne les chromas obtenus
            else
                accords(chord) = chroma; % Nouvelle key
            end
            
            % D�j� rencontr� ? - Accords totaux
            if isKey(Accords, chord) % s'il est d�j� pr�sent
                Accords(chord) = (Accords(chord)+chroma)/2; % On moyenne les chromas obtenus
            else
                Accords(chord) = chroma; % Nouvelle key
            end
            
            % Proba de passage entre accords
            % Proba totale
            if isKey(Proba_tot, chord) % s'il est d�j� pr�sent
                Proba_tot(chord) = Proba_tot(chord) + 1; % On incr�mente le nombre total
                                                     % d'�v�nements pour
                                                     % l'accord
            else
                Proba_tot(chord) = 1;
            end
            
            % Proba de passage
            str = sprintf('%s/%s', chord, former_chord);
            if isKey(Proba, str) % s'il est d�j� pr�sent
                Proba(str) = Proba(str)+1;
            else
                Proba(str) = 1;
            end
            
            former_chord = chord;
            
            
        end
        
        Accords_morceaux(name_file) = accords; % On met les accords pour chaque morceau

    end
    cd ../

end
cd ../

% divise les probas par le nombre total d'�v�nements
fprintf(1, '\n\nCalcul des probabilit�s de passage:\n\n');
prob_keys = Proba.keys();

% for k = 1:length(prob_keys)
%     pattern = '/(.*)';
%     chord = char(regexp(char(prob_keys(k)), pattern, 'match')); % cast to string and get /***
%     chord = chord(2:end); % cast to string
%     Proba(char(prob_keys(k))) = Proba(char(prob_keys(k)))/Proba_tot(chord);
% end

end

