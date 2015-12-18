% script de test de l'algo de Needlenam


chaineA= 'GCATGCU';
chaineB= 'GATTACA';

m_sim_simple= [1 -1 -1 -1; -1 1 -1 -1; -1 -1 1 -1; -1 -1 -1 1];
m_sim_complex= [10 -1 -3 -4; -1 7 -5 -3; -3 -5 9 0; -4 -3 0 8 ];

gap= -1;

[m_res, score]= f_needlenam(chaineA, chaineB, m_sim_simple, gap);

disp(score);
imagesc(m_res);