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

    
    
open_gap= -1;  % ouverture et extension
ext_gap= 0; 

nb_match= 1;

[chemins, score]= f_smith_waterman_Interval(chaineA_Interval, chaineB_Interval, m_sim, m_cor, open_gap, ext_gap, nb_match);

disp('SCORE');
disp(score);
