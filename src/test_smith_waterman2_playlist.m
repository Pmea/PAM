% script de test de l'algo de smith_waterman
close all;
clear all;

chaineA=['U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'U  ';
        'A  ';
        'G  ';
        'T  '];
       
    
chaineB=['A  ';
         'G  ';
         'T  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  ';
         'C  '];

% definition de l'alphabet
% l'ordre: A G C T
m_cor= ['A   1'; 
        'G   2'; 
        'C   3'; 
        'T   4'; 
        'U   5'];
    
m_sim= [ 10 -1 -1 -1 -1; 
         -1 10 -1 -1 -1; 
         -1 -1 10 -1 -1; 
         -1 -1 -1 10 -1; 
         -1 -1 -1 -1 10];
    
    
open_gap= -1;  % ouverture et extension
ext_gap= -1; 

nb_match= 1;

[chemins, score]= f_smith_waterman2_playlist(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap, nb_match);

disp('SCORE');
disp(score);
