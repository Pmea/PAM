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

for k=2:len_B+1
    for l=2:len_A+1
        disp([k l]);
        ind_A=recheche_cor(chaineA(l-1), m_cor);
        ind_B=recheche_cor(chaineB(k-1), m_cor);
        
        % pour la diagonal (match ou dismatch)
        val_diago= m_res(k-1,l-1) + m_sim(ind_A, ind_B);
        % sauvegarde du prec ?
        
        % pour les colones
        max_col= m_res(k-1, l) + gap * 1;
        for col=1:k-1
            if (m_res(k-col, l) + (gap * col)) > max_col
                disp('colone !');
                max_col= (m_res(k-col, l) + (gap * col)); 
                % sauvegarde du prec ? 
            end
        end
        
        % pour les lignes
        max_ligne= m_res(k,l-1) + gap * 1;        %on init a la prec du haut
        for ligne=1:l-1
            if (m_res(k, l-ligne) + (gap * ligne)) > max_ligne
                disp('ligne !');
                max_ligne= (m_res(k, l-ligne) + (gap * ligne));
                % sauvegarde du prec ?
            end
        end 
        
        % selection du max
        [m_res(k,l),~]= max([max_ligne val_diago max_col 0]);
        
        % savegarde du prec
    end 
end


% calcule du resultat
score= 1;

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
