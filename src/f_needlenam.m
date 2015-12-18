function [m_res, score]= f_needlenam(chaineA, chaineB, m_sim, m_cor, gap)
% chaineA et chaineB, les chaines comparer
% matrice de similarite (matrice de poids)
% matrice de correspondence entre l'alphabet et les positions dans la
% matrice de similarite
% poid du gap

score=0;

%initialisation

len_A= length(chaineA);
len_B= length(chaineB);

m_res= zeros(len_A+1, len_B+1); % avec length+1 car il y a la case vite
                                % au debut du mot
for k=0:len_A
    m_res(k+1,1)= gap * k;
end

for k=0:len_B
    m_res(1,k+1)= gap * k;
end

% calcule de la matrice

for k=2:len_B+1
    for l=2:len_A+1
        val_haut= m_res(k-1, l) + gap;
        val_gauche= m_res(k, l-1) + gap;
        
        ind_A=recheche_cor(chaineA(l-1), m_cor);
        ind_B=recheche_cor(chaineB(k-1), m_cor);
        
        val_diago= m_res(k-1,l-1) + m_sim(ind_A, ind_B);
        
        m_res(k,l)= max([val_gauche val_haut val_diago]);
    end
    
end

% calcule du resultat

end


function indice = recheche_cor (car, m_cor)
    for k=1: size(m_cor,1)
        if m_cor(k,1) == car
            indice = k;
        end
    end
end