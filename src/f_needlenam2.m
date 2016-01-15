function [m_res, score]= f_needlenam2(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap)
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

for l=1:len_B+1
    m_res(l,1)=  open_gap + ext_gap * l;
    m_Ly(l,1)= open_gap + ext_gap * l;
end

for k=1:len_A+1
    m_res(1,k)=  open_gap + ext_gap * k;
    m_Lx(1,k)= open_gap + ext_gap * k;
end

m_res(1,1)=0;

% calcule de la matrice

for k=2:len_B+1
    for l=2:len_A+1
        
        % pour Ly
        val_open_Ly= m_res(k, l-1) + ext_gap + open_gap;
        val_ext_Ly=  m_Ly(k, l-1) + ext_gap;
        m_Ly(k,l)= max([val_open_Ly val_ext_Ly]);
        %il faudra faire la sauvegarde l'antecedant
        
        % pour Lx
        val_open_Lx= m_res(k-1,l) + ext_gap + open_gap;
        val_ext_Lx= m_Lx(k-1,l) + ext_gap;
        m_Lx(k,l)= max([val_open_Lx val_ext_Lx]);
        %il faudra faire la sauvegarde de l'antecedant
        
        
        % pour res
        ind_A=recheche_cor(chaineA(l-1), m_cor);
        ind_B=recheche_cor(chaineB(k-1), m_cor);
        delta= m_sim(ind_A, ind_B);
        %calcule du match pour les trois
    
        val_Lx= m_Lx(k-1, l-1) + delta; 
        val_Ly= m_Ly(k-1, l-1) + delta;
        val_res=  m_res(k-1,l-1) + delta;
        
        m_res(k,l)= max([val_Lx val_res val_Ly]);
    end
end

score=0;
end


function indice = recheche_cor (car, m_cor)
%retourne l'indice du caractere dans la matrice de similarite
%a l'aide de la matrice de correspondance
    for k=1: size(m_cor,1)
        if m_cor(k,1) == car
            indice = k;
        end
    end
end