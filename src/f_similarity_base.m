function [c_mor, dist,D12, D21]= f_similarity_base(c_mor, c_chroma_ref)
% calcul la similarit� entre tout les morceaux de la structure
% c_mor: la structue contenant les morceaux leurs accords et le minutages de
% chaque accords
% c_chroma_ref: correspond au chroma de reference pour les 24 accords
% qui vont etre utilis� pour calculer la matrice de penalit�


    % calcule des parametres
    ext_gap= -0.5;        
    open_gap= -1;
    [m_penalty, m_cor]= f_creer_penalty_et_corres_dist(c_chroma_ref);
    m_penalty_inter= zeros(12) -10;
    m_penalty_inter= m_penalty_inter + diag(ones(1,12)) * 20;
    nb_seq=1;
    
    % le parcours de la base
    for ref=1:size(c_mor, 2)
        for etu=1:size(c_mor, 2)
            disp('analyse restante:');
            disp([ (ref-1)*size(c_mor, 2)+etu , size(c_mor, 2)* size(c_mor, 2)])
            % recuperation des chaines
            chaine_ref= c_mor{ref}.accords;
            chaine_ref_inter= f_AccordtoInterval(chaine_ref);
            
            chaine_etu= c_mor{etu}.accords;
            chaine_etu_inter= f_AccordtoInterval(chaine_etu);
            
            % application de waterman avec accords
            [chemin, score]= f_smith_waterman2_playlist(chaine_ref, chaine_etu, m_penalty, m_cor, open_gap, ext_gap, nb_seq);
            c_mor{ref}.watermanAccords{etu}.score= score;
            c_mor{ref}.watermanAccords{etu}.chemin= chemin;
            
%           Autre calcule possible, non effectu� a chaque fois du au temps de calcule 
            
%             % application de needleman avec accords  
%             [~, score]=  f_needleman2(chaine_ref, chaine_etu, m_penalty, m_cor, open_gap, ext_gap);
%             c_mor{ref}.needlemanAccords(etu)= score;
 
%             % application de needleman avec intervals
%              [~, score]=  f_needleman2_Interval(chaine_ref_inter, chaine_etu_inter, m_penalty_inter, open_gap, ext_gap);
%              c_mor{ref}.needlemanInterval(etu)= score;
                       
%             % application de waterman avec intervals
%             [chemin, score]= f_smith_waterman_Interval(chaine_ref_inter, chaine_etu_inter, m_penalty, m_cor, open_gap, ext_gap,  nb_seq);             
%             c_mor{ref}.watermanInterval{etu}.score= score;
%             c_mor{ref}.watermanInterval{etu}.chemin= chemin;

        end
    end
       
    % affichage de la non metric dimensional scale avec les distances
    % calcul� avec le smith waterman 
    dist= zeros(size(c_mor, 2),size(c_mor, 2));
    for k=1:size(c_mor, 2)          % pour tous les morceaux
        for l=1:size(c_mor,2)
            dist(k,l)= c_mor{k}.watermanAccords{l}.score;
        end
    end
    moy_dist= mean(mean(dist));
    dist=  - dist + max(max(dist));
    dist= dist + 0.4;  % dist + une seuil car l'algorithme ne marche qu'avec 
                       % des valeurs positives. Si le morceau est le m�me
                       % la distance peut etre de 0
                       
    D21=[];
    for k=1:size(c_mor,2)
        for l=k+1:size(c_mor,2)
            D21=[D21 dist(k,l)];
        end
    end
    
    Y21 = mdscale(D21,2);
    figure;
    title('Affichage Wateman fin de 1-> debut 2');
    margin= 10;
    axis([min(min(Y21))-margin max(max(Y21))+margin min(min(Y21))-margin max(max(Y21))+margin]);
    hold on;
    for k=1:size(c_mor,2)
        scatter(Y21(k, 1), Y21(k, 2), 'filled');
    end
    hold off;
    
    %debut des colones et debut des lignes
    D12=[];
    for k=1:size(c_mor,2)
        for l=k+1:size(c_mor,2)
            D12=[D12 dist(l,k)];
        end
    end
    
    Y12 = mdscale(D12,2);
    figure;
    title('Affichage Wateman debut de 2 -> fin de 1');
    margin= 10;
    axis([min(min(Y12))-margin max(max(Y12))+margin min(min(Y12))-margin max(max(Y12))+margin]);
    hold on;
    for k=1:size(c_mor,2)
        scatter(Y12(k, 1), Y12(k, 2), 'filled');
    end
    hold off;
    
end