function [m_res, score]= f_needlenam(chaineA, chaineB, m_sim, gap)
% chaineA et chaineB, les chaines comparer
% matrice de similarite (matrice de poids)
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


% calcule du resultat

end