function [v_inter] =f_AccordtoInterval (v_accord)

% par convention on va dire qu'il y a toujours deux caracteres
m_corres=[
    'C  1';
    'C# 2';% meme note
    'Db 2';%
    'D  3';
    'D# 4';%
    'Eb 4';%
    'E  5';
    'F  6';
    'F# 7';%
    'Gb 7';%
    'G  8';
    'G# 9';%
    'Ab 9';%
    'A 10';
    'A#11';%
    'Bb11';%
    'B 12';
];

v_inter= zeros(size(v_accord,1)-1,1);
v_val_accord= zeros(size(v_accord,1), 1);

for k=1:length(v_val_accord) %pour toute la chaine
    s= v_accord(k,1:2);
    
    if s(2)== 'm'
        s(2)= ' ';
    end
    
    found=false;
    for l=1:length(m_corres)  % on chercher le bon element
        if strcmp(m_corres(l, 1:2), s(1:2))
            v_val_accord(k)= str2double(m_corres(l, end-1:end));
            found=true;
            
            if k > 1
                v_inter(k-1)=  mod(v_val_accord(k)-v_val_accord(k-1) +6, 12);
                v_inter(k-1)= v_inter(k-1) -6;
            end
            continue;
        end
    end
    
    if found == false
        disp('Accord non trouvé');
        disp('Erreur format suite accord');
        assert(true);
    end
end



end
