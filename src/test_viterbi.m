% --- DESC_m est la matrice de descripteurs représentant les MFCC (à 13 
% dimensions) à chaque trame: 100 trames pour la classe 1, 100 trames pour 
%la classe 2
DESC_m = [randn(100,13); 1+randn(100,13)];
CLASS_v = [ones(100,1); 2*ones(100,1)];
nbClass = 2;

% --- TRAINING: Calcul pour chaque classe des paramètres du modèle gaussien
for numClass=1:nbClass
     pos_v = find(CLASS_v==numClass);
     model_s(numClass).mu_v         = mean(DESC_m(pos_v,:));
     model_s(numClass).sigma_m     = cov(DESC_m(pos_v,:));
end

% --- EVAL: Calcul de la likelihood pour chaque classe
for numClass=1:nbClass
     model_s(numClass).prob_v = mvnpdf(DESC_m, model_s(numClass).mu_v, model_s(numClass).sigma_m);
     subplot(nbClass,1,numClass), plot(model_s(numClass). prob_v)
end