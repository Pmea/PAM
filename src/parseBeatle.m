clear all;
close all;

%Nous voulons récupérer les accords de maniere simplifier, dans un fichier
%txt , avec leur durée et la position de leurs commencement.
%a partir des fichiers  de la base de données des beatles.
folderName = '../The_Beatles_Annotations/chordlab/The_Beatles';
%ici il y a plein de dossier :  chaque album
%pour chaque album on va chercher dans les fichiers lab représentant les morceaux, les accords
%puis on les simplifieras...
beginfolder=pwd;
mkdir_if_not_exist('Beatles_Annotations_simple');
cd ../The_Beatles_Annotations/chordlab/The_Beatles;
%on retient la chemin absolut vers les album et leurs annotations d'accords
albumsfolder=pwd;
A=ls;
albums = strsplit(A);
    %on va parser chaque élément de la chaine de caractere  : c'est
    %l'ensemble des dossiers

for p=1:length(albums)-1
    name = char(albums(p)); 
    
    
    cd(char(beginfolder));
    cd('Beatles_Annotations_simple');
    
    if name(end) ~= '/', name = [name '/']; end
   if (exist(name, 'dir') == 0), mkdir(name); end
   
    cd(char(name));
    simplealbumfolder=pwd;
   
    cd(char(beginfolder));
    cd(char(albumsfolder));
    cd(char(name));
    albumxfolder=pwd;
    B = ls('*.lab'); %on recupere l'ensemble des fichier lab
    morceaux = strsplit(B);
   
       %parsing on
     

    %recuperer commencement de l'accord format seconde
    %recuperer l'accord puis le simplifier si besoin
    %marqué dans un fichier les deux information sauté une ligne pour
    %chaque morceau un nouveau fichier.
    
     % k = strfind(S, ' ')  
 
      for l=1:length(morceaux)-1
          %on regarde dans quel dossier on est (cela peut changer)
          check=pwd;
          
    %si les deux chaîne sont différentes on retourne au dossier de l'album
          if strcmp(char(check),char(albumxfolder))==0 
              cd(char(albumxfolder));
          end
     
            [fid,message]=fopen(char(morceaux(l)),'r'); 
             M_morceau=[];
   
         while(1)
        
          if feof(fid) break; end
       
            ligne = fgetl(fid);	% caractère(s) de fin de ligne non gardé(s)
            disp(ligne);
            values = strsplit(ligne);
            % faire une structure enregistrer en point mat pour l'apprentissage
            % numero d'accord / 
           
            chord = char(values(3));
          if length(chord)>2
         
                 if  any(ismember(chord, 'min')) %l'accord est mineur
                     expression = '(:|/)(.)*'     %'(:|/)\w*(\(/)*\w*'%'(:|/)\w*/*\w*';
                     replace = 'm';

                     newStr = regexprep(char(values(3)),expression,replace);
                        
                     values(3) = cellstr(newStr);
                 else
                   
                     %l'accord est majeur
                       expression = '(:|/)(.)*'     %'(:|/)\w*(\(/)*\w*';%'(:|/)\w*/*\w*';
                       replace = '';
                       newStr = regexprep(char(values(3)),expression,replace)
                       values(3) =  cellstr(newStr)
                 end
                   

   
        
           end
   


    M_morceau=[[values(1) values(3)];M_morceau];
         end
    % keyboard;
     cd(char(simplealbumfolder));
     nameMorceaux = char(morceaux(l));
     nameMorceaux = nameMorceaux(1:length(nameMorceaux)-4);
%     
     M_morceau =flipud(M_morceau); 
     %pour commencer par le debut
     %enregistrer matrice dans un .mat dans le dossier
     %Beatles_Annotations_simplifié
     save(char(strcat(char(nameMorceaux),'.mat')),'M_morceau');
    fclose(fid);

     end
     
     
   
       %parsing off
       
 
    cd ../  %on revient dans le dossier des albums
    
   

end
fclose all


