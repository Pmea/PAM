function [chemin, score]= f_needleman2(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap)
% calcul du chemin optial dans la matrice grace a l'algorithme de needleman
% avec les gaps affines
% chaineA et chaineB, les chaines comparer
% matrice de similarite (matrice de poids)
% matrice de correspondence entre l'alphabet et les positions dans la
% matrice de similarite
% poids du gap, l'ouverture et l'expension

%initialisation
chaineTmp= chaineA;
chaineA= chaineB;
chaineB= chaineTmp;

len_A= size(chaineA,1);   
len_B= size(chaineB,1);

m_res= zeros(len_A+1, len_B+1);     % avec length+1 car il y a la case vite
m_Lx= zeros(len_A+1, len_B+1);
m_Ly= zeros(len_A+1, len_B+1);

m_antes_res= zeros(len_A+1, len_B+1);   % au debut du mot
m_antes_Lx= zeros(len_A+1, len_B+1);
m_antes_Ly= zeros(len_A+1, len_B+1);


% pour la recheche d'antessedant on prend la convention gauche/diago/haut
def_ant_Lx=1;  % define variable pour antessedant dans le tableau          
def_ant_res=2;
def_ant_Ly=3;

def_init=0;

m_antes_res(:,:)= -1;
m_antes_Lx(:,:)= -1;
m_antes_Ly(:,:)= -1;

for k=1:len_A+1
    m_res(k,1)=  open_gap + ext_gap * k;
    m_antes_res(k,1)= def_ant_Lx;    
    m_Ly(k,1)= -Inf;
    m_antes_Lx(k,1)= def_ant_Lx;
end

for l=1:len_B+1
    m_res(1,l)=  open_gap + ext_gap * l;
    m_antes_res(1,l)= def_ant_Ly;
    m_Lx(1,l)= -Inf;
    m_antes_Ly(1,l)= def_ant_Ly;
end

m_res(1,1)= def_init;
m_antes_Ly(1,1)= def_init;
m_antes_Lx(1,1)= def_init;
m_antes_res(1,1)= def_init;

% calcule de la matrice

for k=2:len_A+1
    for l=2:len_B+1
        % pour Ly
        val_open_Ly= m_res(k, l-1) + ext_gap + open_gap;
        val_ext_Ly=  m_Ly(k, l-1) + ext_gap;
        [m_Ly(k,l), m_antes_Ly(k,l)]= max([-Inf val_open_Ly val_ext_Ly]);
        
        % pour Lx
        val_open_Lx= m_res(k-1,l) + ext_gap + open_gap;
        val_ext_Lx= m_Lx(k-1,l) + ext_gap;
        [m_Lx(k,l), m_antes_Lx(k,l) ]= max([val_ext_Lx val_open_Lx -Inf]);
        
        % pour res
        ind_A=recheche_cor(chaineA(k-1, 1:3), m_cor);
        ind_B=recheche_cor(chaineB(l-1, 1:3), m_cor);
        delta= m_sim(ind_A, ind_B);

        %calcule du match pour les trois
        val_Lx= m_Lx(k-1, l-1) + delta; 
        val_Ly= m_Ly(k-1, l-1) + delta;
        val_res=  m_res(k-1,l-1) + delta;
        
        [m_res(k,l), m_antes_res(k,l)]= max([val_Lx val_res val_Ly]);
    end
end

% calcule du resultat
k=len_A+1;
l=len_B+1;
score= 0;    %initialisation du score

[~, ind_a]= max([m_Lx(k,l) m_res(k,l) m_Ly(k,l) ]);

switch ind_a
   case def_ant_res
       m_antes=m_antes_res;
   case def_ant_Ly
       m_antes=m_antes_Ly;
   case def_ant_Lx
       m_antes=m_antes_Lx;
    otherwise
       disp('Erreur valeur de l''antessedant');
       assert(false);
end

chemin= [];
score= score + m_res(k,l);

while  m_antes(k,l) ~= def_init

    chemin= [[k l]; chemin];
  
    switch m_antes(k,l)
        case def_ant_res
            k= k-1;
            l= l-1;
            m_antes=m_antes_res;
            score= score + m_res(k,l); 
        case def_ant_Lx
            k=k-1;
            m_antes=m_antes_Lx;
            score= score + m_res(k,l);   
        case def_ant_Ly
            l= l-1;
            m_antes=m_antes_Ly;
            score= score + m_res(k,l);
        otherwise
            disp('Erreur valeur de l''antessedant');
            assert(false);
    end
end
chemin= [[1 1]; chemin];
score= score + m_res(k,l);

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