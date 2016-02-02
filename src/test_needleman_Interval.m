%script de test de l'algo de Needlenam avec des intervals

close all;
clear all;

chaineA=[
        'G  ';
        'C  ';
        'G  ';
        'G  ';
        'C  ';
        'C  ';
        'G  ';
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

chaineA_Interval= f_AccordtoInterval(chaineA);
chaineB_Interval= f_AccordtoInterval(chaineB);
    
m_sim= zeros(size(m_cor,1)) -10;
m_sim= m_sim + diag(ones(1,size(m_cor,1))) * 20;

gap= -1;  % ouverture et extension

[chemin, score]= f_needleman_Interval(chaineA_Interval, chaineB_Interval, m_sim, gap);

disp('SCORE');
disp(score);

disp(chemin);