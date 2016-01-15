function [m_res, score]= f_needlenam(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap)
% chaineA et chaineB, les chaines comparer
% matrice de similarite (matrice de poids)
% matrice de correspondence entre l'alphabet et les positions dans la
% matrice de similarite
% poids du gap, l'ouverture et l'expension

%initialisation

len_A= length(chaineA);
len_B= length(chaineB);

m_res= zeros(len_A+1, len_B+1);     % avec length+1 car il y a la case vite
m_Lx= zeros(len_A+1, len_B+1);
m_Ly= zeros(len_A+1, len_B+1);
m_antes= zeros(len_A+1, len_B+1);   % au debut du mot

% pour la recheche d'antessedant on prend la convention gauche/diago/haut
def_gau=1;  % define variable pour antessedant dans le tableau          
def_dia=2;
def_hau=3;
def_ini=0;

for l=1:len_B
    m_Ly(l+1,1)= open_gap + ext_gap * k;
end

for k=1:len_A
    m_Lx(1,k+1)= open_gap + ext_gap * l;
end

% calcule de la matrice

for k=2:len_B+1
    for l=2:len_A+1
        % pour Lx
        val_open_Lx= m_res(k, l-1) + ext_gap + open_gap;
        val_ext_Lx=  m_Lx(k, l-1) + ext_gap;
        m_Lx(k,l)= max([val_open_Lx val_ext_Lx]);
        %il faudra faire la sauvegarde l'antecedant
        
        % pour Ly
        val_open_Ly= m_res(k-1,l) + ext_gap + open_gap;
        val_ext_Ly= m_Ly(k-1,l) + exp_gap;
        m_Ly(k,l)= max([val_open_Ly val_ext_Ly]);
        %il faudra faire la sauvegarde de l'antecedant
        
        % pour res
        val_haut= m_res(k-1, l) + gap;
        val_gauche= m_res(k, l-1) + gap;
        
        ind_A=recheche_cor(chaineA(l-1), m_cor);
        ind_B=recheche_cor(chaineB(k-1), m_cor);
        
        val_diago= m_res(k-1,l-1) + m_sim(ind_A, ind_B);
        
        [m_res(k,l), ind_antes]= max([val_gauche val_diago val_haut]);
        m_antes(k,l)= ind_antes;
    end
    
end

end