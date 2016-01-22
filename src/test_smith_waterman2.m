% script de test de l'algo de smith_waterman
close all;
clear all;

chaineA=['A  ';
        'C  ';
        'A  ';
        'C  ';
        'A  ';
        'C  ';
        'T  ';
        'A  '];
        
chaineB=['A  ';
         'G  ';
         'C  ';
         'A  ';
         'C  ';
         'A  ';
         'C  ';
         'A  '];

% definition de l'alphabet
% l'ordre: A G C T
m_cor= ['A   1'; 
        'G   2'; 
        'C   3'; 
        'T   4'; 
        'U   5'];
    
m_sim=  [2 -1 -1 -1; 
        -1 2 -1 -1 ; 
        -1 -1 2 -1; 
        -1 -1 -1 2];
    
    
open_gap= -1;  % ouverture et extension
ext_gap= 0; 

seuil= 9;

[chemins, score]= f_smith_waterman2(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap, seuil);

disp('SCORE');
disp(score);
