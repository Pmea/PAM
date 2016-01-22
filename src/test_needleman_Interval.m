%script de test de l'algo de Needlenam
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
    
%definition de l'alphabet
%l'ordre: A G C T
m_cor= ['1   1'; 
        '2   2'; 
        '3   3'; 
        '4   4'; 
        '5   5';
        '6   6'; 
        '-1  7'; 
        '-2  8'; 
        '-3  9'; 
        '-4 10';
        '-5 11';
        '-6 12'];
    
m_sim= zeros(size(m_cor,1)) -10;
m_sim= m_sim + diag(ones(1,size(m_cor,1))) * 20;

  

gap= -1;  % ouverture et extension

[chemin, score]= f_needleman_Interval(chaineA_Interval, chaineB_Interval, m_sim, gap);

disp('SCORE');
disp(score);

disp(chemin);