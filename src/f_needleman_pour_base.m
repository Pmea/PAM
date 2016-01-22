function [c_mor]= f_needleman_pour_base(c_mor)

    % calcule des parametres
    ext_gap=  1;
    open_gap= -2;
    [m_penalty, m_cor]= f_creer_penalty_et_corres_dist(ext_gap, open_gap, c_chroma_ref);
    
    for ref=1:size(c_mor, 1)          % Le parcours de la base
        for c=etu:size(c_mor,1)
            chaine_ref= c_mor{ref}.accords;
            chaine_etu= c_mor{etu}.accords;
            score=  f_needlenam2(chaine_ref, chaine_etu, m_penalty, m_cor, open_gap, ext_gap);
            c_mor{ref}.needleman(etu)= score;
            c_mor{etu}.needleman(ref)= score;
        end
    end

end