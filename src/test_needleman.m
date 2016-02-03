%script de test de l'algo de Needlenam dans ca version classique 

close all;
clear all;

chaineA=[
        'G  ';
        'C  ';
        'A  ';
        'T  ';
        'G  ';
        'C  ';
        'U  ';
        'G  ';
        'C  ';
        'A  ';
        'T  ';
        'G  ';
        'C  ';
        'U  ';
        ];
        
chaineB=[
        'G  ';
        'A  ';
        'T  ';
        'T  ';
        'A  ';
        'C  ';
        'A  ';
        'G  ';
        'A  ';
        'T  ';
        'T  ';
        'A  ';
        'C  ';
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
        -1 -1 -1 -1 1
        ];
    
gap= -0.5;  % ouverture et extension

[chemin, score]= f_needleman(chaineA, chaineB, m_sim, m_cor, gap);

disp('SCORE');
disp(score);

disp(chemin);