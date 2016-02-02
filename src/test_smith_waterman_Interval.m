% script de test de l'algo de smith_waterman avec les intervalles
close all;
clear all;
chaineA=[
        'A  ';
        'D  ';
        'A  ';
        'A  ';
        'D  ';
        'D  ';
        'A  ';
        ];
        
chaineB=[
        'G  ';
        'C  ';
        'G  ';
        'G  ';
        'C  ';
        'C  ';
        'G  ';
        ];

% definition de l'alphabet
% l'ordre: A G C T

chaineA_Interval= f_AccordtoInterval(chaineA);
chaineB_Interval= f_AccordtoInterval(chaineB);
    

    
m_sim= zeros(size(m_cor,1)) -10;
m_sim= m_sim + diag(ones(1,size(m_cor,1))) * 20;

    
    
open_gap= -1;  % ouverture et extension
ext_gap= -0,5; 

nb_match= 1;

[chemins, score]= f_smith_waterman_Interval(chaineA_Interval, chaineB_Interval, m_sim, open_gap, ext_gap, nb_match);

disp('SCORE');
disp(score);
