% script de test de l'algo de Needlenam
close all;
clear all;

chaineA=[
        'A  ';
        'C  ';
        'T  ';
        'T  ';
        'A  ';
        'C  ';
        'U  ';
        ];
        
chaineB=[
        'A  ';
        'A  ';
        'T  ';
        'T  ';
        'A  ';
        'A  ';
        'A  ';
        ];

%definition de l'alphabet
%l'ordre: A G C T
m_cor= ['A   1'; 
        'G   2'; 
        'C   3'; 
        'T   4'; 
        'U   5'];
    
m_sim= [1 -1 -1 -1 -1; 
        -1 1 -1 -1 -1; 
        -1 -1 1 -1 -1; 
        -1 -1 -1 1 -1; 
        -1 -1 -1 -1 1];
%m_sim= [10 -1 -3 -4 -1; 
%          -1 7 -5 -3 -2; 
%          -3 -5 9 0 -2; 
%          -4 -3 0 8 -3; 
%          -1 -2 -2 -3 10];
open_gap= 0;  % ouverture et extension
ext_gap= -1;

[chemin, score]= f_needleman2(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap);

disp('SCORE');
disp(score);

disp(chemin);