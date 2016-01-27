function [path_v] = HMM(Accords_mat, obs_m)
% Reconnaissance d'accords par HMM
%   Accords_mat est déjà modifié et a pour clés le nom des accords, et pour
%   values le chroma moyen pour chaque accord

% Accords_mat: matrice des chromas pour les accords
% obs_m: matrice des observations chroma pour le morceau étudié

%% Définitions des paramètres
parameters_gaussian = cell(length(Accords_mat.keys()),1); % Garder les paramètres des gaussiennes 
keys_chords = Accords_mat.keys(); % Nom des accords
keys_chords = keys_chords(1:end-3);

% Paramètres pour la likehood
% chroma_m = zeros(length(keys_chords), 12);
% for k = 1:length(keys_chords) 
%     chroma_m(k,:) = Accords_mat(char(keys_chords(k)))';
%     parameters_gaussian{k} = [mean(chroma_m(k,:)) cov(chroma_m(k,:))];
% end

for k = 1:length(keys_chords) 
    chroma_m = Accords_mat(char(keys_chords(k)))';
    parameters_gaussian{k} = [mean(chroma_m); cov(chroma_m)]; % Matrice 13*12 
                                                              % avec la moyenne sur 
                                                              % la 1ère ligne et la 
                                                              % matrice de covariance 
                                                              % sur les autres
end

%% Initial proba
probInit_v = 1/length(keys_chords)*ones(length(keys_chords), 1);

%% Probabilités de passage inter-accords
probTrans_m = f_cycle_des_quintes();

%% Likehood proba
% Calcul de la likehood pour chaque accord - on a la proba d'avoir un
% chroma sachant l'accord
probObs_m = zeros(length(keys_chords), size(obs_m, 2)); % Dimensions accords * nb_trames
for k = 1:size(obs_m, 2) % Boucle sur les trames
    for h = 1:length(keys_chords) % Boucle sur les accords
        probObs_m(h,k) = mvnpdf(obs_m(:,k)', parameters_gaussian{h}(1,:), parameters_gaussian{h}(2:end,:));
    end
end


%% Viterbi
path_v = viterbi4(probInit_v, probObs_m, probTrans_m);

end

