function [chemins, score]= f_smith_waterman2(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap, seuil)

%initialisation

len_A= length(chaineA);
len_B= length(chaineB);

m_res= zeros(len_A+1, len_B+1);     % avec length+1 car il y a la case vite
c_antes= cell(len_A+1, len_B+1);   % au debut du mot

c_antes{1,1}=[0 0];

for k=1:len_B
    m_res(k+1,1)= 0;
    c_antes{k+1,1}(1)= 0;
    c_antes{k+1,1}(2)= 0;
end

for l=1:len_A
    m_res(1,l+1)= 0;
    c_antes{1,l+1}(1)= 0;
    c_antes{1,l+1}(2)= 0;
end


% calcule de la matrice

for k=2:len_B+1
    for l=2:len_A+1
        ind_A=recheche_cor(chaineA(l-1), m_cor);
        ind_B=recheche_cor(chaineB(k-1), m_cor);
        
        max_tmp= 0;
        c_antes{k,l}(1)= 0;
        c_antes{k,l}(2)= 0;
         
        % pour la diagonal (match ou dismatch)
        if m_res(k-1,l-1) + m_sim(ind_A, ind_B) > max_tmp
            max_tmp= m_res(k-1,l-1) + m_sim(ind_A, ind_B);
            c_antes{k,l}(1)= k-1;
            c_antes{k,l}(2)= l-1;
        end
             
        % pour les colones     
        for col=1:k-1
            if (m_res(k-col, l) + (ext_gap * col)+ open_gap) > max_tmp
                max_tmp= m_res(k-col, l) + (ext_gap * col) + open_gap; 
                c_antes{k,l}(1)= k-col;
                c_antes{k,l}(2)= l;
            end
        end
        
        % pour les lignes
        for ligne=1:l-1
            if (m_res(k, l-ligne) + (ext_gap * ligne)+ open_gap) > max_tmp
                max_tmp= m_res(k, l-ligne) + (ext_gap * ligne) + open_gap;
                c_antes{k,l}(1)= k;
                c_antes{k,l}(2)= l-ligne;
            end
        end 
        
        % selection du max, les antes sont deja sauvegarde
        m_res(k,l)= max_tmp;
    end
end


% calcule du resultat
chemins={};

%similarité accumulé maximun

max_tmp = max(max(m_res));

while  max_tmp > seuil
    [max_x, max_y]= find(m_res==max_tmp);
    max_x= max_x(1);
    max_y= max_y(1);
    
    
    % on met la case a 0
    m_res(max_x, max_y)=0;
    
    chemin= [max_x max_y];
    
    while c_antes{max_x, max_y}(1) >0 && c_antes{max_x, max_y}(2) > 0
        tmp_x= c_antes{max_x, max_y}(1);
        tmp_y= c_antes{max_x, max_y}(2);
        
        max_x=tmp_x;
        max_y=tmp_y;
        
        chemin= [[max_x max_y]; chemin];
        
        % on met la case a 0
        m_res(max_x, max_y)= 0;
    end
    
    chemins= [{chemin} chemins];
    max_tmp = max(max(m_res));
end

score= 0;
for k=1:length(chemins)
    if length(chemins{1,k}) > score
        score= length(chemins{1,k});
    end
end

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
