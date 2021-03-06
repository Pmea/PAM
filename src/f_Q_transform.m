function [m_spect]= f_Q_transform(v_sig, Fe, Q,note_min, note_max, freq_la_ref)
% Applique une transform� a Q constant et retoune le contenu spectral au cours du
% temps. Pour avoir le chromamagramme, il faut utiliser envoyer ce contenu
% spectral a f_CQTtoChroma
% v_sig: le signal a etudier
% Fe: frequence d'echantillonnage
% Q: facteur de qualit�
% note_min: la note la plus basse de l'analyse (en note midi)
% note_max: la note la plus haut de l'analyse (en note midi)
% freq_la_ref: la frequence de la de reference, si il y a du descordage

% Varible
v_len_sig= length(v_sig);
Cw=1.82; % le Cw de la fenetre de Hann

% Calcule des frequences par rapport au fonction midi
nb_note= note_max - note_min +1;

v_mk= (note_min : note_max);  %les notes midi 
v_f= freq_la_ref * 2.^((v_mk- 69)/12); % les frequences des differentes bandes
v_f_red= v_f/Fe; %frequence reduite

% Creation des longeurs des fenetres
v_len_fen= floor((Q * Cw) ./ (v_f/Fe));  % la longeur de la fenetre pour chaque bande
max_len_fen= v_len_fen(1); 
if mod(max_len_fen/2, 1) ~= 0
    max_len_fen= max_len_fen -1;
    v_len_fen(1)= v_len_fen(1)- 1;
end
min_len_fen= v_len_fen(end);

% Calcule des fenetres a partir des sinosoides
m_fen= zeros(nb_note, max_len_fen);
for k= 1: nb_note
    v_fen_tmp= hann(v_len_fen(k), 'periodic'); 
    deb= floor((max_len_fen - length(v_fen_tmp))/2)+1;
    fin= floor((max_len_fen + length(v_fen_tmp))/2);
    m_fen(k, deb : fin)= v_fen_tmp(1:fin-deb+1);
end


% Application de la CQT
hop = floor(min_len_fen / 3);  

frames= round((v_len_sig - max_len_fen - ceil(max_len_fen/2))/hop-1);  %nb de frame pour la tfct
m_spect= zeros(frames, nb_note);

v_sig= v_sig'; % transposition du vecteur colone en vercteur ligne

v_e= zeros(nb_note, max_len_fen);
for l=1:nb_note
    deb= 1 - ceil(max_len_fen/2);  % on centre le sinus dans le fenetre
    fin= + floor(max_len_fen/2);   % pour avoir de bon resultat avec Q petit
    v_e(l,:)= exp(-1j * 2 * pi * v_f_red(l) * (deb:fin));    
    v_e(l,:)= m_fen(l,:) .* v_e(l,:);
end

for k= 1: frames
   deb= k*hop +max_len_fen/2 - ceil(max_len_fen/2) +1 - hop;
   fin= k*hop +max_len_fen/2  + ceil(max_len_fen/2)- hop ;
   
   % compute de la CQT 
   for l=1:nb_note
       m_spect(k,l)=  sum(v_sig(deb:fin) .* v_e(l, (1:max_len_fen)));
   end
   
end

m_spect= m_spect';
end