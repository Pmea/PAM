% script de test de l'algo de Needlenam avec gap affine
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
%l'ordre: A G C T U 
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

open_gap= -1;  % ouverture et extension
ext_gap= -0.5;

[chemin, score]= f_needleman2(chaineA, chaineB, m_sim, m_cor, open_gap, ext_gap);

disp('SCORE');
disp(score);

disp(chemin);