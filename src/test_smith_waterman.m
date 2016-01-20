% script de test de l'algo de smith_waterman
close all;
clear all;

chaineA= 'ACACACTA';
chaineB= 'AGCACACA';

% definition de l'alphabet
% l'ordre: A G C T
m_cor= ['A1'; 'G2'; 'C3'; 'T4'];
m_sim= [2 -1 -1 -1; -1 2 -1 -1 ; -1 -1 2 -1; -1 -1 -1 2];

gap= -1;  % ouverture et extension

seuil= 9;

[chemins, m_res, score]= f_smith_waterman_mine(chaineA, chaineB, m_sim, m_cor, gap, seuil);

disp('SCORE');
disp(score);
figure;
imagesc(m_res);