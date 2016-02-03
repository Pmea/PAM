function prob_trans = f_cycle_des_quintes()
% Calcule le sprobabilit�s de transition entre accords
% Mod�le bas� sur le cycle des quintes.

%% Probabilit�s de transitions - Forme g�n�rale
probas = ((0:12)+eps)/(144+24*eps);

%% Probabilit�s de transition pour La
prob_A = [probas(13) probas(3) probas(10) probas(6) probas(9) probas(3) probas(6) probas(10) probas(7) probas(2) probas(11) probas(5) probas(12) probas(4) probas(11) probas(1) probas(8) probas(8) probas(5) probas(4) probas(9) probas(7) probas(12) probas(2)]; 

%% Probabilit�s de transition pour tous les accords
prob_trans = zeros(24, 24);
prob_trans(1,:) = prob_A;

for k = 2:24
    prob_trans(k,:) = (circshift(prob_A', k-1))'; % Permutation circulaire des probabilit�s 
end

end