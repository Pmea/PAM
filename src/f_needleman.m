function [chemin, score]= f_needlenam(chaineA, chaineB, m_sim, m_cor, gap)
% chaineA et chaineB, les chaines comparer
% matrice de similarite (matrice de poids)
% matrice de correspondence entre l'alphabet et les positions dans la
% matrice de similarite
% poid du gap

%initialisation

len_A= size(chaineA,1);   
len_B= size(chaineB,1);

m_res= zeros(len_A+1, len_B+1);     % avec length+1 car il y a la case vite
m_antes= zeros(len_A+1, len_B+1);   % au debut du mot

% pour la recheche d'antessedant on prend la convention gauche/diago/haut
def_gau=1;  % define variable pour antessedant dans le tableau          
def_dia=2;
def_hau=3;
def_ini=0;

for k=1:len_B
    m_res(k+1,1)= gap * k;
    m_antes(k+1,1)= def_hau;
end

for l=1:len_A
    m_res(1,l+1)= gap * l;
    m_antes(1,l+1)= def_gau;
end

% calcule de la matrice
for k=2:len_B+1
    for l=2:len_A+1
        val_haut= m_res(k-1, l) + gap;
        val_gauche= m_res(k, l-1) + gap;
        
        ind_A=recheche_cor(chaineA(l-1, 1:3), m_cor);
        ind_B=recheche_cor(chaineB(k-1, 1:3), m_cor);
        
        val_diago= m_res(k-1,l-1) + m_sim(ind_A, ind_B);
        
        [m_res(k,l), ind_antes]= max([val_gauche val_diago val_haut]);
        m_antes(k,l)= ind_antes;
    end
    
end
% calcule du resultat

l=len_A+1;
k=len_B+1;
score=1;    %initialisation du score

chemin= [];

while  m_antes(k,l) ~= def_ini
    chemin= [[k l]; chemin];    
    
    score= score + 1 ;    
    switch m_antes(k,l)
        case def_gau
            l= l-1;
        case def_dia 
            k= k-1;
            l= l-1;
        case def_hau
            k= k-1;
        otherwise
            disp('Erreur valeur de l''antecedant');
            assert(true);
    end
end

chemin= [[1 1]; chemin];

end



function indice = recheche_cor (s, m_cor)
%retourne l'indice du caractere dans la matrice de similarite
%a l'aide de la matrice de correspondance
    for k=1: size(m_cor,1)
        if strcmp(m_cor(k,1:3), s);
            indice = k;
        end
    end
end