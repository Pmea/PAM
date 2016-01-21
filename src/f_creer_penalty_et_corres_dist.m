function [m_seuil, m_penalty, m_corres]= f_creer_penalty_et_corres_dist(ext_gap, open_gap, c_chroma_ref)
%les chromas doivent etre dans cet ordre

m_corres=[
    'C   1';
    'C#  2';% meme note
%    'Db  2';%
    'D   3';
%     'D#  4';%
%     'Eb  4';%
%     'E   5';
%     'F   6';
%     'F#  7';%
%     'Gb  7';%
%     'G   8';
%     'G#  9';%
%     'Ab  9';%
%     'A  10';
%     'A# 11';%
%     'Bb 11';%
%     'B  12';
%     
%     'Cm 13';        % accordm mineur
%     'C#m14';%
%     'Dbm14';%
%     'Dm 15';
%     'D#m16';%
%     'Ebm16';%
%     'Em 17';
%     'Fm 18';
%     'F#m19';%
%     'Gbm19';%
%     'Gm 20';
%     'G#m21';%
%     'Abm21';%
%     'Am 22';
%     'A#m23';%
%     'Bbm23';%
%     'Bm 24';
    ];

% on calcul la distante entre chaque chroma
m_penalty= zeros(size(m_corres,1), size(m_corres,1));


for c=1:size(c_chroma_ref,2);            %on normalise les chromas
    sum_chroma= sum(c_chroma_ref{c});           
    c_chroma_ref{c}=  c_chroma_ref{c}./ sum_chroma;
end


for k=1:size(m_corres,1)     % amelioration possible en parcourant les chromas
    for l=1:size(m_corres,1) % et non les cases (des calculs sont identique
        m_penalty(k,l)= distance(c_chroma_ref{k}, c_chroma_ref{l});
    end
end

moyenne=mean(m_penalty(:));
m_penalty= m_penalty - moyenne;
m_penalty=  m_penalty;

m_seuil=0;
end

function [score] = distance(v_chroma1, v_chroma2)
    v_d= abs(v_chroma1 - v_chroma2);
    
    score= sum(v_d);
end