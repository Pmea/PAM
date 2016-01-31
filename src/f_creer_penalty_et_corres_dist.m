function [m_penalty, m_corres]= f_creer_penalty_et_corres_dist(c_chroma_ref)
%les chromas doivent etre dans cet ordre

% matrice pouvant etre utiliser pour faire
% la correspondence entre 34 et 24 pour les accords
m_corres=[ 
    'C   1';
    'Db  2';%
    'D   3';
    'Eb  4';%
    'E   5';
    'F   6';
    'Gb  7';%
    'G   8';
    'Ab  9';%
    'A  10';
    'Bb 11';%
    'B  12';
     
    'Cm 13';        % accord mineur
    'Dbm14';%
    'Dm 15';
    'Ebm16';%
    'Em 17';
    'Fm 18';
    'Gbm19';%
    'Gm 20';
    'Abm21';%
    'Am 22';
    'Bbm23';%
    'Bm 24';
    'N  25';
    ];

% on calcul la distante entre chaque chroma
m_penalty= zeros(size(m_corres,1), size(m_corres,1));


for c=1:size(c_chroma_ref,2);            %on normalise les chromas
    sum_chroma= sum(c_chroma_ref{c});           
    c_chroma_ref{c}=  c_chroma_ref{c} ./ (sum_chroma+eps);
end


for k=1:size(m_corres,1)
    for l=k:size(m_corres,1) 
        val_tmp= distance(c_chroma_ref{k}, c_chroma_ref{l});
        m_penalty(k,l)= val_tmp;
        m_penalty(l,k)= val_tmp;
    end
end
% 
% moyenne=mean(m_penalty(:));
% m_penalty= m_penalty - moyenne;
m_penalty= -m_penalty;

end

function [score] = distance(v_chroma1, v_chroma2)
    v_d= abs(v_chroma1 - v_chroma2);
    
    score= sum(v_d);
end