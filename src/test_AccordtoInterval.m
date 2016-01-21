% script de test pour la conversion la grille d'accords vers la liste 
%des intervalles

% format
% A [b/#] [m/Ø] 
% exemple [Ab ], [A  ], [A#m]

close all;
clear all;

accords= ['C  ';'B  ';'B  '; 'C  '];

inteval= f_AccordtoInterval(accords);

figure;
disp(inteval);