% Seconde partie du programme
% Scripte de calcule de similarité et creation de la playlist

if 0
    %Attention cette etape peut etre tres longue
    [c_mor, dist, D12, D21]=f_similarity_base(c_morceaux, c_chroma_ref);

    save('analysemusic.mat');
else
    fprintf(1, 'Chargement des vecteurs d''observations chromas pour tous les morceaux... \n');
	load('analysemusic.mat');
end
toc;

len_mix=4; %le nombre de morceau dans le mix
v_ind_mor_joue= zeros(len_mix,1);


nom_mor_dep= 'BEATLES_CD01PPM_T01.wav'; % Morceau de depart donné par l'utilisateur
ind_mor_dep= -Inf;

nb_mor= size(c_morceaux,2);

    %trouver le morceau dans la base
for k=1:nb_mor
    if strcmp(nom_mor_dep, c_morceaux{k}.name)
        ind_mor_dep= k;
    end
end

if ind_mor_dep < 1
    disp('Erreur, morceau de depart non trouve');
    assert(true);
end

    
%suppresion de la possibilité de se choisir
for k=1:size(dist,1)
    for l=1:size(dist,2)
        if k==l
            dist(k,l)=+Inf;
        end
    end
end

%liste de morceaux avec leur moment de cross fade
playlist=zeros(len_mix+1,1);
playlist(1)= ind_mor_dep;
c_temps_crossFade= cell(len_mix,1);

for k=1:len_mix  
    
    if mod(k,2)== 1                         % on regarde la fin du morceau de depart 
        dist_tmp= dist(ind_mor_dep,:);      % et debut du morceau suiv    
    else
        dist_tmp= dist(:, ind_mor_dep);      
    end                                     
    
    trouve=false;
    while ~trouve
        [~, ind_mor_suiv]= min(dist_tmp);
        if isempty(find(playlist == ind_mor_suiv,1))
            trouve= true;
        else
            dist_tmp(ind_mor_suiv)= Inf;
        end
    end
    
    chemin= c_mor{ind_mor_dep}.watermanAccords{ind_mor_suiv}.chemin{1};
    ind_temps_1=[ min(chemin(:,1)) max(chemin(:,1)) ];
    ind_temps_2=[ min(chemin(:,2)) max(chemin(:,2)) ];
    t_mor_1=[ c_mor{ind_mor_dep}.tempsAccords(ind_temps_1(1)) c_mor{ind_mor_dep}.tempsAccords(ind_temps_1(2)) ];
    t_mor_2=[ c_mor{ind_mor_suiv}.tempsAccords(ind_temps_2(1)) c_mor{ind_mor_suiv}.tempsAccords(ind_temps_2(2)) ];
    
    Fe1= c_mor{ind_mor_dep}.fe;
    Fe2= c_mor{ind_mor_suiv}.fe;
    
   
    %a la fin de boucle
    ind_mor_dep= ind_mor_suiv;
    playlist(k+1)= ind_mor_suiv;
    c_temps_crossFade{k}=[t_mor_1; t_mor_2];

end
%affichage de la playlist
disp(playlist');