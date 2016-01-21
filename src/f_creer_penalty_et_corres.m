function [m_seuil, m_penalty, m_corres]= f_creer_penalty_et_corres(ext_gap, open_gap)

m_corres=[
    'C  1';
    'C# 2';% meme note
    'Db 2';%
    'D  3';
    'D# 4';%
    'Eb 4';%
    'E  5';
    'F  6';
    'F# 7';%
    'Gb 7';%
    'G  8';
    'G# 9';%
    'Ab 9';%
    'A 10';
    'A#11';%
    'Bb11';%
    'B 12';
    ];


match= 10;
mismatch= -10;

m_penalty= ones(size(m_corres,1)) * mismatch;
m_penalty= m_penalty + diag(ones(size(m_corres,1),1)* (match-mismatch));

m_seuil= 0; % que choisir ?

end