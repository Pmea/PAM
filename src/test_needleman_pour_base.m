% script de test de l'algo de smith_waterman
close all;
clear all;

% creation fausse matrice de chroma 
c_chroma_ref= cell(1,3);
chroma1= [                                          %donnee piano reel
    129.0964;
    9.8799;
    1.7967;
    1.0914;
    4.4349;
    0.9931;
    0.9967;
   14.6491;
    0.6950;
    0.5997;
    4.5427;
    4.1142;
    ];

chroma2= [
     7.6039;
  150.8403;
   12.0892;
    3.3007;
    2.0548;
   12.0362;
    1.5067;
    0.8430;
   16.2537;
    1.5132;
    1.4324;
    4.4758;
    ];
chroma3= [
     2.6311;
    6.6900;
   93.1436;
    7.4896;
    2.7003;
    2.7234;
   14.0264;
    1.1559;
    1.1608;
   20.9224;
    1.7690;
    1.5270;
    ];

c_chroma_ref{1}= chroma1;
c_chroma_ref{2}= chroma2;
c_chroma_ref{3}= chroma3;

% creation de la fausse structure
% avec 3 morceaux 
nb_morceaux=3;
c_morceaux= cell(1,nb_morceaux);
% premier
c_morceaux{1}.nom='piste1.wav';
c_morceaux{1}.accords=['C  ';
                      'C  ';
                       'Db ';
                       'C  ';
                       'C  ';
                       'Db ';
                       'C  ';
                       'C  ';
                       'Db ';
                       'C  ';
                       'C  ';
                       'Db ']; 
c_morceaux{1}.needlemanInterval= zeros(1,nb_morceaux) -Inf;                   
c_morceaux{1}.needlemanAccords= zeros(1,nb_morceaux) -Inf;                   
                                 
% second

c_morceaux{2}.nom='piste2.wav';
c_morceaux{2}.accords=['Db ';
                      'Db ';
                       'D  ';
                       'Db ';
                       'Db ';
                       'D  ';
                       'Db ';
                       'Db ';
                       'D  ';
                       'Db ';
                       'Db ';
                       'D  ']; 
c_morceaux{2}.needlemanIntervals= zeros(1,nb_morceaux) -Inf;                   
c_morceaux{2}.needlemanAccords= zeros(1,nb_morceaux) -Inf;                   


% troisieme
c_morceaux{3}.nom='piste3.wav';
c_morceaux{3}.accords=['C  ';
                      'Db ';
                       'D  ';
                       'Db ';
                       'C  ';
                       'Db ';
                       'D  ';
                       'Db ';
                       'C  ';
                       'Db ';
                       'D  ';
                       'Db ']; 
c_morceaux{3}.needlemanIntervals= zeros(1,nb_morceaux) -Inf;                   
c_morceaux{3}.needlemanAccords= zeros(1,nb_morceaux) -Inf;                   


% application de la fonction

c_morceaux= f_needleman_pour_base(c_morceaux, c_chroma_ref);

% application de la fonction
