function [path_v] = HMM(Accords_mat, obs_m)
% Reconnaissance d'accords par HMM

% Accords_mat: matrice des chromas pour chaque accord
% obs_m: matrice des observations chroma pour le morceau �tudi�

%% D�finitions des param�tres
parameters_gaussian = cell(length(Accords_mat.keys()),1); % Garder les param�tres des gaussiennes 
keys_chords = Accords_mat.keys(); % Nom des accords

% Param�tres pour la likehood: de chaque matrice, on n'extrait plu
% seulement un vecteur moyen, mais aussi une matrice de covariance pour
% obtenir les probabilit�s d'obtenir un accord, sachant l'observation
for k = 1:length(keys_chords) 
    chroma_m = Accords_mat(char(keys_chords(k)))';
    parameters_gaussian{k} = [mean(chroma_m); cov(chroma_m)]; % Matrice 13*12 
                                                              % avec la moyenne sur 
                                                              % la 1�re ligne et la 
                                                              % matrice de covariance 
                                                              % sur les autres
end

%% Initial proba
probInit_v = 1/length(keys_chords)*ones(length(keys_chords), 1); % 1/24 pour chaque accord

%% Probabilit�s de passage inter-accords
probTrans_m = f_cycle_des_quintes(); % Calcul� avec le cycle des quintes

%% Likehood proba
% Calcul de la likehood pour chaque accord - on a la proba d'avoir un
% accord sachant le chroma - Accords rang�s dans l'ordre alphab�tique
probObs_m = zeros(length(keys_chords), size(obs_m, 2)); % Dimensions accords * nb_trames

for k = 1:size(obs_m, 2) % Boucle sur les trames
    for h = 1:length(keys_chords) % Boucle sur les accords
        probObs_m(h,k) = mvnpdf(obs_m(:,k)', parameters_gaussian{h}(1,:), parameters_gaussian{h}(2:end,:));
    end
    probObs_m(:,k) = probObs_m(:,k)/sum(probObs_m(:,k)); % Normalis�e
end


%% Viterbi
path_v = viterbi(probInit_v, probObs_m, probTrans_m);

end

