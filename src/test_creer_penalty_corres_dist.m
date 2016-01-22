% script pour tester f_create_penalty_corres_dist
% avec la distance de chaque chroma

close all;
clear all;


c_chroma_ref= cell(1,3);
% chroma1=[1;0;0;0;1;0;0;1;0;0;0;0];                %donnee genere
% chroma1= chroma1 .* 0.1 .* rand(12,1);
% chroma2=[0;1;0;0;0;1;0;0;1;0;0;0]; 
% chroma2= chroma2 .* 0.1 .* rand(12,1);
% chroma3=[0;0;1;0;0;0;1;0;0;1;0;0]; 
% chroma3= chroma3 .* 0.1 .* rand(12,1);

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
[m_penalty, m_corres]= f_creer_penalty_et_corres_dist(c_chroma_ref);
