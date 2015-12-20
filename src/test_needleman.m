% script de test de l'algo de Needlenam
close all;
clear all;

chaineA= 'GCATGCU';
chaineB= 'GATTACA';

% definition de l'alphabet
% l'ordre: A G C T
m_cor= ['A1'; 'G2'; 'C3'; 'T4'; 'U5'];
m_sim_simple= [1 -1 -1 -1 -1; -1 1 -1 -1 -1; -1 -1 1 -1 -1; -1 -1 -1 1 -1; -1 -1 -1 -1 1];
%m_sim_complex= [10 -1 -3 -4; -1 7 -5 -3; -3 -5 9 0; -4 -3 0 8 ];

gap= -1;

[m_res, score]= f_needlenam(chaineA, chaineB, m_sim_simple, m_cor, gap);

disp('SCORE');
disp(score);
figure;
imagesc(m_res);