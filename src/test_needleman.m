%script de test de l'algo de Needlenam
close all;
clear all;

chaineA= 'GCATGCU';
chaineB= 'GATTACA';

%definition de l'alphabet
%l'ordre: A G C T
m_cor= ['A1'; 'G2'; 'C3'; 'T4'; 'U5'];
m_sim= [1 -1 -1 -1 -1; -1 1 -1 -1 -1; -1 -1 1 -1 -1; -1 -1 -1 1 -1; -1 -1 -1 -1 1];
%m_sim= [10 -1 -3 -4 -1; -1 7 -5 -3 -2; -3 -5 9 0 -2; -4 -3 0 8 -3; -1 -2 -2 -3 10];

gap= -1;  % ouverture et extension

[m_res, score]= f_needlenam(chaineA, chaineB, m_sim, m_cor, gap);

disp('SCORE');
disp(score);
figure;
imagesc(m_res);