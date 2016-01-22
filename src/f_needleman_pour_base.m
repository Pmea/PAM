function [c_mor]= f_needleman_pour_base(c_mor)

    % calcule des parametres
    ext_gap=  1;        % a determiner precisement
    open_gap= -2;
    [m_penalty, m_cor]= f_creer_penalty_et_corres_dist(ext_gap, open_gap, c_chroma_ref);
    nb_seq=1;
    
    for ref=1:size(c_mor, 1)          % Le parcours de la base
        for c=etu:size(c_mor,1)
            % recuperation des chaines
            chaine_ref= c_mor{ref}.accords;
            chaine_ref_inter= f_AccordtoInterval(chaine_ref);
            
            chaine_etu= c_mor{etu}.accords;
            chaine_etu_inter= f_AccordtoInterval(chaine_etu);
            
            % application de needleman avec accords  
            score=  f_needlenam2(chaine_ref, chaine_etu, m_penalty, m_cor, open_gap, ext_gap);
            c_mor{ref}.needlemanAccords(etu)= score;
            c_mor{etu}.needlemanAccords(ref)= score;
            
            % application de needleman avec intervals
            score=  f_needlenam2(chaine_ref_inter, chaine_etu_inter, m_penalty, m_cor, open_gap, ext_gap);
            c_mor{ref}.needlemanInterval(etu)= score;
            c_mor{etu}.needlemanInterval(ref)= score;
            
%             % application de waterman avec accords
%             [chemin score]= f_smith_waterman2(chaine_ref, chaine_etu, m_penalty, m_cor, open_gap, ext_gap, nb_seq);
%             c_mor{ref}.watermanAccords{etu}.score= score;
%             c_mor{ref}.watermanAccords{etu}.chemin= chemin;
%             c_mor{etu}.watermanAccords{ref}.score= score; 
%             c_mor{etu}.watermanAccords{ref}.chemin= chemin;
%             
%             % application de waterman avec intervals
%             [chemin score]= f_smith_waterman2(chaine_ref_inter, chaine_etu_inter, m_penalty, m_cor, open_gap, ext_gap,  nb_seq);             
%             c_mor{ref}.watermanInterval{etu}.score= score;
%             c_mor{ref}.watermanInterval{etu}.chemin= chemin;
%             c_mor{etu}.watermanInterval{ref}.scrore= score;
%             c_mor{etu}.watermanInterval{ref}.chemin= chemin;

        end
    end

end