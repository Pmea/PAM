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
    disp(k);
    for l=2:len_A+1
        val_haut= m_res(k-1, l) + gap;
        val_gauche= m_res(k, l-1) + gap;
        
        % recherche ind_A
        for m=1: size(m_cor,1)         % faire de la recheche une fonction
            if m_cor(m,1) == chaineA(l-1)
                ind_A= m;
            end
        end
        
        % recherche ind_B
        for m=1: size(m_cor,1)         % faire de la recheche une fonction
            if m_cor(m,1) == chaineB(k-1)
                ind_B= m;
            end
        end
                
        val_diago= m_res(k-1,l-1) + m_sim(ind_A, ind_B);
        
        disp([val_gauche val_haut val_diago]);

        m_res(k,l)= max([val_gauche val_haut val_diago]);
    end
     imagesc(m_res);
     %pause;
end

% calcule du resultat

end