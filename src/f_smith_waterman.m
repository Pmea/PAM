
function [cout_m]= f_smith_waterman(chaineA, chaineB, penality,gap)
len_A= length(chaineA)+1;
len_B= length(chaineB)+1;
%penalty ici fait office dans penality_m de mismatch
verbose=1;
plotAlignement=1;

penality_m=zeros(len_A,len_B);
for i=1:len_A-1
    for j=1:len_B-1
        if chaineA(i)==chaineB(j)
            penality_m(i+1,j+1)=2;
        else
            penality_m(i+1,j+1)=penality;
        end
    end
end
cout_m=zeros(len_A,len_B);
ligne_pred_M=zeros(len_A,len_B);
col_pred_M=zeros(len_A,len_B);




%penalty fera regle de gap
cout_m=zeros(len_A,len_B);
ligne_pred_M=zeros(len_A,len_B);
col_pred_M=zeros(len_A,len_B);

% debut remplissage des matrice 
for i=2:len_A %pour chaque ligne la premiere ligne reste a zero 
    for j=2:len_B %pour chaque colonne la premiere colonne reste a zero
        temp_max=penality_m(i,j);
        bestPredi=0;
        bestPredj=0;
    %    keyboard;
        %  transition Diagonal
        if cout_m(i-1,j-1)+ penality_m(i,j)>temp_max
            temp_max=cout_m(i-1,j-1)+ penality_m(i,j);
            bestPredi=i-1;
            bestPredj=j-1;
            disp('in1');
        end
      % keyboard;
        % scan vertical: nodes (1,j),(2,j),...,(i-1,j)
        for ligne=1:i-1
            if cout_m(ligne,j)+((penality)*(i-ligne))>temp_max
                temp_max=cout_m(ligne,j)+((penality)*(i-ligne)); % the second term is the penalty term for the vertical transition
                bestPredi=ligne;
                bestPredj=j;
                  disp('in2'); 
            end
%            keyboard;
        end
      %  keyboard;
        % scan Horizontal : nodes (i,1),(i,2),...,(i,j-1)
        for col=1:j-1
            if cout_m(i,col)+((penality)*(j-col))>temp_max
                temp_max= cout_m(i,col)+(penality*(j-col)); % the second term is the penalty term for the horizontal transition
                bestPredi=i;
                bestPredj=col;
                  disp('in3'); 
            end
        end
    %keyboard;
        % Finished (i,j).There only remains to store the winner
        if temp_max>0
            cout_m(i,j)=temp_max;
            ligne_pred_M(i,j)=bestPredi;
            col_pred_M(i,j)=bestPredj;
            disp('change');
        end
%      keyboard;
    end
end
% fin start remplissage des matrice 


maxv=max(max(cout_m)); %similarité accumulé maximun
if maxv==0
    bp=[];
    return;
end

[xc,yc]=find(cout_m==maxv); % where maxv is located
xc=xc(1); yc=yc(1); % in case of ties
keyboard;
% eo initialization

% Backtracking
bp=[xc yc];
while xc>0 && yc>0
    t_ligne=ligne_pred_M(xc,yc);
    t_col=col_pred_M(xc,yc);
    xc=t_ligne;
    yc=t_col;
    bp=[[xc yc];bp];
end



% fin backtracking

bp(1,:)=[];
bp=bp-1;
keyboard;
if verbose==1
    % affiche alignement a l'écran (si verbose~=1 on saute)
    clc
    fprintf('Similarity = %5.2f\n\n',maxv);
    if ischar(chaineA)
        fprintf('%5c <-> %-5c (match)\n',chaineA(bp(1,1)),chaineB(bp(1,2)));
    else
        fprintf('%5d <-> %-5d (match)\n',chaineA(bp(1,1)),chaineB(bp(1,2)));        
    end
    for i=2:size(bp,1)
        Ac=chaineA(bp(i,1));
        Bc=chaineB(bp(i,2));        
        if bp(i,1)==bp(i-1,1)+1 && bp(i,2)==bp(i-1,2)+1
            if Ac==Bc
                if ischar(chaineA)
                    fprintf('%5c <-> %-5c (match)\n',Ac,Bc);
                else
                    fprintf('%5d <-> %-5d (match)\n',Ac,Bc);
                end
            else
                if ischar(chaineA)
                    fprintf('%5c <-> %-5c (replacement)\n',Ac,Bc);
                else
                    fprintf('%5d <-> %-5d (replacement)\n',Ac,Bc);
                end
            end
            continue;
        end
        
        if bp(i,2)==bp(i-1,2)
            for k=bp(i-1,1)+1:bp(i,1)
                if ischar(chaineA)
                    fprintf('%5c  <- %-5c (deleted)\n',chaineA(k),' ');
                else
                    fprintf('%5d  <- %-5c (deleted)\n',chaineA(k),' ');
                end
            end
            continue;
        end
        
        if bp(i,1)==bp(i-1,1)
            for k=bp(i-1,2)+1:bp(i,2)
                if ischar(chaineA)
                    fprintf('%5c  -> %-5c (deleted)\n',' ',chaineB(k));
                else
                    fprintf('%5c  -> %-5d (deleted)\n',' ',chaineB(k));
                end
            end
        end
    end
    % end print
end

if plotAlignement==1
    % Plot Alignment avec graphics (peut etre sauté)
    clf;hold;
    axis([1 length(chaineB) 1 length(chaineA)]);
    plot(bp(:,2),bp(:,1),'r*');
    plot(bp(:,2),bp(:,1));
    grid on
    % end plot
end
keyboard;