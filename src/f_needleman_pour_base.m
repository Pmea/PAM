function [c_mor]= f_needleman_pour_base(c_mor, c_chroma_ref)

    % calcule des parametres
    ext_gap= -0.5;        % a determiner precisement
    open_gap= -1;
    [m_penalty, m_cor]= f_creer_penalty_et_corres_dist(c_chroma_ref);
    m_penalty_inter= zeros(12) -10;
    m_penalty_inter= m_penalty_inter + diag(ones(1,12)) * 20;
    nb_seq=1;
    
    for ref=1:size(c_mor, 2)          % Le parcours de la base
        for etu=1:size(c_mor, 2)
            % recuperation des chaines
            chaine_ref= c_mor{ref}.accords;
            chaine_ref_inter= f_AccordtoInterval(chaine_ref);
            
            chaine_etu= c_mor{etu}.accords;
            chaine_etu_inter= f_AccordtoInterval(chaine_etu);
            
            % application de needleman avec accords  
            [~, score]=  f_needleman2(chaine_ref, chaine_etu, m_penalty, m_cor, open_gap, ext_gap);
            c_mor{ref}.needlemanAccords(etu)= score;
 %          disp([chaine_ref'; chaine_etu']);
 %          disp([ref etu score]);
            % application de needleman avec intervals
             [~, score]=  f_needleman2_Interval(chaine_ref_inter, chaine_etu_inter, m_penalty_inter, open_gap, ext_gap);
             c_mor{ref}.needlemanInterval(etu)= score;
            
            % application de waterman avec accords
            [chemin, score]= f_smith_waterman2(chaine_ref, chaine_etu, m_penalty, m_cor, open_gap, ext_gap, nb_seq);
            c_mor{ref}.watermanAccords{etu}.score= score;
            c_mor{ref}.watermanAccords{etu}.chemin= chemin;
            
            % application de waterman avec intervals
            [chemin, score]= f_smith_waterman_Interval(chaine_ref_inter, chaine_etu_inter, m_penalty, m_cor, open_gap, ext_gap,  nb_seq);             
            c_mor{ref}.watermanInterval{etu}.score= score;
            c_mor{ref}.watermanInterval{etu}.chemin= chemin;

        end
    end
    % affichage avec needleman
    dist= zeros(size(c_mor, 2));
    for k=1:size(c_mor, 2)          % pour tous les morceaux
        dist(k,:)= - c_mor{k}.needlemanAccords;
    end
    
    D=[];
    for k=1:size(c_mor,2)
        for l=k+1:size(c_mor,2)
            D=[D dist(k,l)];
        end
    end
    
    Y = mdscale(D,2);
    figure;
    title('Affichage');
    axis([min(min(Y)) max(max(Y)) min(min(Y)) max(max(Y))]);
    hold on;
    for k=1:size(c_mor,2)
        scatter(Y(k, 1), Y(k, 2), 'filled');
    end
    hold off;
end