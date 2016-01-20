function [chemins, score]= f_smith_waterman_mine2(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap, seuil)

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
