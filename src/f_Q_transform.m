function [m_spect]= f_Q_transform(sig, Fe, Q, Nfft, freq_la_ref)
% Pour l'instant, on ne peut utiliser que la fenetre de hann. 
% A voir si on a besoin de pouvoir proposer plusieurs fenetre
% si on voulait on pourrait fournir en argument une fenetre et un Cw 
% et on l'agrandrirai avec des interp

v_len_sig= length(sig);
v_len_frames= Fe/10;        % on veut 10 frames par second
hop= floor(v_len_frames/4);

Cw= 1.82; % Cw de la fenetre de hann

note_min= 21;   % valeur midi de note min et max
note_max= 128;
nb_note= note_max - note_min;

v_mk= (note_min : note_max);  %les note midi du A0 au G#8
v_f= freq_la_ref * 2.^((v_mk- 69)/12); % les frequences des differentes bandes

%c'est quoi l'unité ? les frequences on les changes en bin ?
v_len_fen= floor((Q * Cw) ./ (v_f/Fe)); % la longeur de la fenetre pour chaque bande

% il faut calculer la premiere pour definir la taille
len_fen= v_len_fen(1); % la taille la plus grande ( le plus bas en freq)
v_fen= zeros(nb_note, len_fen); % on met toute les valeurs 

% il faut encore faire des trucs la pour que ca marche
for k= 1: nb_note
    v_fen_tmp= hann( v_len_fen(k), 'periodic'); 
    deb= floor((len_fen - length(v_fen_tmp))/2)+1;
    fin= floor((len_fen + length(v_fen_tmp))/2);
    v_fen(k, deb : fin)= v_fen_tmp(1:fin-deb+1);
end

%tfct 
m_spect= zeros(1, nb_note);
frames= round((v_len_sig - v_len_frames)/hop-1);  %nb de frame pour la tfct


for k= 1: frames;
   v_fensig= sig(k* hop: k*hop+len_fen-1) .* v_fen(k,:);
   m_spect(k,:)= abs(fft(v_fensig, Nfft));  %faut il garder la phase
end

end