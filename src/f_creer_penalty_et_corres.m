function [m_penalty, m_corres]= f_creer_penalty_et_corres(ext_gap, open_gap)

m_corres=[
    'C   1';
    'C#  2';% meme note
    'Db  2';%
    'D   3';
    'D#  4';%
    'Eb  4';%
    'E   5';
    'F   6';
    'F#  7';%
    'Gb  7';%
    'G   8';
    'G#  9';%
    'Ab  9';%
    'A  10';
    'A# 11';%
    'Bb 11';%
    'B  12';
    
    'Cm 13';        % accordm mineur
    'C#m14';%
    'Dbm14';%
    'Dm 15';
    'D#m16';%
    'Ebm16';%
    'Em 17';
    'Fm 18';
    'F#m19';%
    'Gbm19';%
    'Gm 20';
    'G#m21';%
    'Abm21';%
    'Am 22';
    'A#m23';%
    'Bbm23';%
    'Bm 24';
    ];

match= 0;
mismatch=  -1.5731;

m_penalty= ones(size(m_corres,1)) * mismatch;
m_penalty= m_penalty + diag(ones(size(m_corres,1),1)* (match-mismatch));


end