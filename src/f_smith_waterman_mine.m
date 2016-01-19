function [m_res, score]= f_smith_waterman_mine(chaineA, chaineB, m_sim, m_cor, gap)

%initialisation

len_A= length(chaineA);
len_B= length(chaineB);

m_res= zeros(len_A+1, len_B+1);     % avec length+1 car il y a la case vite
m_antes= zeros(len_A+1, len_B+1);   % au debut du mot

% pour la recheche d'antessedant on prend la convention gauche/diago/haut
def_gau=1;  % define variable pour antessedant dans le tableau          
def_dia=2;
def_hau=3;
def_ini=0;

for k=1:len_B
    m_res(k+1,1)= 0;
    m_antes(k+1,1)= def_hau;
end

for l=1:len_A
    m_res(1,l+1)= 0;
    m_antes(1,l+1)= def_gau;
end

% calcule de la matrice



% calcule du resultat


end
