function [v_inter] =f_AccordtoInterval (v_accord)
% transforme un suite d'accord en une suite d'interval (l'interval entre accord) 
% On ne fait pas la differance entre le majeur et le mineur.

%matrice de correspence entre accords et distance en demi ton
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

v_inter= zeros(size(v_accord,1)-1,1);     %matrice des intervals
v_val_accord= zeros(size(v_accord,1), 1); %matrice des valeurs pour chaque accord

for k=1:length(v_val_accord) %pour toute la chaine
    s= v_accord(k,1:2);
    
    if s(2)== 'm'           % si mineur, on ignore le caractere
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
        assert(false);
    end
end



end
