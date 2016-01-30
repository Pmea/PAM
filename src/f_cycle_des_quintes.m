%fct pour créé la matrice de probabilité chromatique
%accord global ->deux convention
%accord Min ou Maj  -> et oui.ed' c

function prob_trans = f_cycle_des_quintes()

% Probabilités de transitions - Forme générale
probas = ((0:12)+eps)/(144+24*eps);

% Probabilités de transition pour La
prob_A = zeros(1,24);  
prob_A = [probas(13) probas(3) probas(10) probas(6) probas(9) probas(3) probas(6) probas(10) probas(7) probas(2) probas(11) probas(5) probas(12) probas(4) probas(11) probas(1) probas(8) probas(8) probas(5) probas(4) probas(9) probas(7) probas(12) probas(2)]; 

% Probabilités de transition pour tous les accords
prob_trans = zeros(24, 24);
prob_trans(1,:) = prob_A;

for k = 2:24
    prob_trans(k,:) = (circshift(prob_A', k-1))'; 
end

% cycle_quinte_Maj_v = {'C','F','Bb','Eb','Ab','Db','Gb','B','E','A','D','G'};
% 
% cycle_quinte_Maj_interval = [];
% 
% for k=1:length(cycle_quinte_Maj_v )
%     cycle_quinte_Maj_interval = [cycle_quinte_Maj_interval equivalent_accord_g(cycle_quinte_Maj_v(k))];
% end
% 
% %don't workcycle_quinte_min_v = relative_mineur(cycle_quinte_Maj_interval);
% %Weird...
% cycle_quinte_min_v = {'A','D','G','C','F','Bb','Eb','Ab','Db','Gb','B','E'};
% mat_24 = matrice_distance();
% %keyboard;
% %to_proba(mat_24);
% %a faire a fire...
% distance_m_12 = 1;
% 
% distance_m_24 = to_proba(mat_24);
% 
% distance_m_34 = 1;
% 
% end
% 
% function res = matrice_distance()
% res = [0 5 2 3 4 1 6 1 4 3 2 5  4 5 2 7 2 5 4 3 6 1 6 3;
%        5 0 5 2 3 4 1 6 1 4 3 2  3 4 5 2 7 2 5 4 3 6 1 6;
%        2 5 0 5 2 3 4 1 6 1 4 3  6 3 4 5 2 7 2 5 4 3 6 1;
%        3 2 5 0 5 2 3 4 1 6 1 4  1 6 3 4 5 2 7 2 5 4 3 6;
%        4 3 2 5 0 5 2 3 4 1 6 1  6 1 6 3 4 5 2 7 2 5 4 3;
%        1 4 3 2 5 0 5 2 3 4 1 6  3 6 1 6 3 4 5 2 7 2 5 4;
%        6 1 4 3 2 5 0 5 2 3 4 1  4 3 6 1 6 3 4 5 2 7 2 5;
%        1 6 1 4 3 2 5 0 5 2 3 4  5 4 3 6 1 6 3 4 5 2 7 2;
%        4 1 6 1 4 3 2 5 0 5 2 3  2 5 4 3 6 1 6 3 4 5 2 7;
%        3 4 1 6 1 4 3 2 5 0 5 2  7 2 5 4 3 6 1 6 3 4 5 2;
%        2 3 4 1 6 1 4 3 2 5 0 5  2 7 2 5 4 3 6 1 6 3 4 5;
%        5 2 3 4 1 6 1 4 3 2 5 0  5 2 7 2 5 4 3 6 1 6 3 4;
%        4 5 2 7 2 5 4 3 6 1 6 3  0 5 2 3 4 1 6 1 4 3 2 5;
%        3 4 5 2 7 2 5 4 3 6 1 6  5 0 5 2 3 4 1 6 1 4 3 2; 
%        6 3 4 5 2 7 2 5 4 3 6 1  2 5 0 5 2 3 4 1 6 1 4 3; 
%        1 6 3 4 5 2 7 2 5 4 3 6  3 2 5 0 5 2 3 4 1 6 1 4;
%        6 1 6 3 4 5 2 7 2 5 4 3  4 3 2 5 0 5 2 3 4 1 6 1; 
%        3 6 1 6 3 4 5 2 7 2 5 4  1 4 3 2 5 0 5 2 3 4 1 6;
%        4 3 6 1 6 3 4 5 2 7 2 5  6 1 4 3 2 5 0 5 2 3 4 1;
%        5 4 3 6 1 6 3 4 5 2 7 2  1 6 1 4 3 2 5 0 5 2 3 4;
%        2 5 4 3 6 1 6 3 4 5 2 7  4 1 6 1 4 3 2 5 0 5 2 3;
%        7 2 5 4 3 6 1 6 3 4 5 2  3 4 1 6 1 4 3 2 5 0 5 2;
%        2 7 2 5 4 3 6 1 6 3 4 5  2 3 4 1 6 1 4 3 2 5 0 5;
%        5 2 7 2 5 4 3 6 1 6 3 4  5 2 3 4 1 6 1 4 3 2 5 0;
%        ];
% end
% 
% 
% function res = to_proba(mat_poids_24)
% res = zeros(24,24);
% %syms a b c x y z t  ;
% %S = solve('3*x + 4*y + 4*z+ 4*a + 4*b + 3*c + 2*t = 1') ;
% %S = [S.x S.y S.z S.a S.b S.c S.t];
% mat_temp = zeros(24,24);
% for i=1:24
%     for j=1:24
%         %pour zeros il y a probabilité que..
%       if   mat_poids_24(i,j)==0
%         mat_temp(i,j) =  0; %prob max
%       end  
%       if   mat_poids_24(i,j)~=-1
%         mat_temp(i,j) =  7- mat_poids_24(i,j);
%       end
%       if   mat_temp(i,j)==0
%         mat_temp(i,j) =  0.01;
%       end
%     end
% end
% %keyboard;
% for k= 1:24
%     res(k,:) = mat_temp(k,:)/sum(mat_temp(k,:));
% end
% 
% 
% 
% 
% %keyboard;
% 
% %for i=1:24
% %    for j=1:24
% %        if mat_poids_24(i,j)==1
% %            res(i,j)=S.x;
% %        end
% %        if mat_poids_24(i,j)==2
% %            res(i,j)=S.y;
% %        end
% %        if mat_poids_24(i,j)==3
% %            res(i,j)=S.z;
% %        end
% %        if mat_poids_24(i,j)==4
% %            res(i,j)=S.a;
% %        end
% %        if mat_poids_24(i,j)==5
% %            res(i,j) = S.b;
% %        end
% %        if mat_poids_24(i,j)==6
% %            res(i,j)=S.c;
% %        end
% %        if mat_poids_24(i,j)==7 || mat_poids_24(i,j)==0
% %            res(i,j)=S.t;
% %        end
%         
%         
%         
% %    end
% %end
% 
% 
% end 
% 
% function res =relative_mineur(val_demi_ton_v)
%     %combien de ton perdu pour relative mineur?
%     temp=val_demi_ton_v;
%     val_demi_ton_v = mod(val_demi_ton_v-1-3,12)+1;
%      disp(temp);
%     disp(val_demi_ton_v);
%     res=[]
%     for i=1:length(val_demi_ton_v)
%         res=[res equivalent_interval_g(val_demi_ton_v(i))];
%     end
% end
% 
% 
% 
% function indice = equivalent_accord_g(S)
%   
% if strcmp(S,'C')==1; 
%         indice =1;
%     end 
%     if strcmp(S,'C#')==1; 
%         indice =2;
%     end
%     if strcmp(S,'Db')==1; 
%         indice =2;
%     end
%     if strcmp(S,'D')==1; 
%         indice =3;
%     end
%     if strcmp(S,'D#')==1; 
%         indice =4;
%     end
%     if strcmp(S,'Eb')==1; 
%         indice =4;
%     end
%     if strcmp(S,'E')==1; 
%         indice =5;
%     end
%      if strcmp(S,'F')==1; 
%         indice =6;
%      end
%        if strcmp(S,'F#')==1; 
%         indice =7;
%        end
%        if strcmp(S,'Gb')==1; 
%         indice =7;
%        end
%      if strcmp(S,'G')==1; 
%         indice =8;
%      end
%      if strcmp(S,'G')==1; 
%         indice =9;
%      end
%     if strcmp(S,'Ab')==1; 
%         indice =9;
%     end
%     if strcmp(S,'A')==1; 
%         indice =10;
%     end
%      if strcmp(S,'A#')==1; 
%         indice =11;
%      end
%      if strcmp(S,'Bb')==1; 
%         indice =11;
%      end
%      if strcmp(S,'B')==1; 
%         indice =12;
%      end
% end
% 
% function chord = equivalent_interval_g(S)
%   
%     if S==1
%         chord='C'
%     end
%     if S==2
%         chord='Db'
%     end
%     if S==3
%         chord='E'
%     end
%     if S==4
%         chord='Eb'
%     end
%     if S==5
%         chord='E'
%     end
%     if S==6
%         chord='F'
%     end
%     if S==7
%         chord='Gb'
%     end
%     if S==8
%         chord='G'
%     end
%     if S==9
%         chord='Ab'
%     end
%     if S==10
%         chord='A'
%     end
%      if S==11
%         chord='Bb'
%      end
%      if S==12
%         chord='A'
%      end
% end 
% 
% function indice = equivalent_chroma(S)
% %retourne l'indice de valeur du chroma
% 
% 
%     if strcmp(S,'CM_')==1; 
%         indice =1;
%     end 
%     if strcmp(S,'CM#')==1; 
%         indice =2;
%     end
%     if strcmp(S,'DMb')==1; 
%         indice =2;
%     end
%     if strcmp(S,'DM_')==1; 
%         indice =3;
%     end
%     if strcmp(S,'DM#')==1; 
%         indice =4;
%     end
%     if strcmp(S,'EMb')==1; 
%         indice =4;
%     end
%     if strcmp(S,'EM_')==1; 
%         indice =5;
%     end
%      if strcmp(S,'FM_')==1; 
%         indice =6;
%      end
%        if strcmp(S,'FM#')==1; 
%         indice =7;
%        end
%        if strcmp(S,'GMb')==1; 
%         indice =7;
%        end
%      if strcmp(S,'GM_')==1; 
%         indice =8;
%      end
%      if strcmp(S,'GM#')==1; 
%         indice =9;
%      end
%     if strcmp(S,'AMb')==1; 
%         indice =9;
%     end
%     if strcmp(S,'AM_')==1; 
%         indice =10;
%     end
%      if strcmp(S,'AM#')==1; 
%         indice =11;
%      end
%      if strcmp(S,'BMb')==1; 
%         indice =11;
%      end
%      if strcmp(S,'BM_')==1; 
%         indice =12;
%      end
%     if strcmp(S,'Cm_')==1; 
%         indice =1;
%     end 
%     if strcmp(S,'Cm#')==1; 
%         indice =2;
%     end
%     if strcmp(S,'Dmb')==1; 
%         indice =2;
%     end
%     if strcmp(S,'Dm_')==1; 
%         indice =3;
%     end
%     if strcmp(S,'Dm#')==1; 
%         indice =4;
%     end
%     if strcmp(S,'Emb')==1; 
%         indice =4;
%     end
%     if strcmp(S,'Em_')==1; 
%         indice =5;
%     end
%      if strcmp(S,'Fm_')==1; 
%         indice =6;
%      end
%        if strcmp(S,'Fm#')==1; 
%         indice =7;
%        end
%        if strcmp(S,'Gmb')==1; 
%         indice =7;
%        end
%      if strcmp(S,'Gm_')==1; 
%         indice =8;
%      end
%      if strcmp(S,'Gm#')==1; 
%         indice =9;
%      end
%     if strcmp(S,'Amb')==1; 
%         indice =9;
%     end
%     if strcmp(S,'Am_')==1; 
%         indice =10;
%     end
%      if strcmp(S,'Am#')==1; 
%         indice =11;
%      end
%      if strcmp(S,'Bmb')==1; 
%         indice =11;
%      end
%      if strcmp(S,'Bm_')==1; 
%         indice =12;
%     end
%      
% end
% 
% function m = distance_cycle()


end