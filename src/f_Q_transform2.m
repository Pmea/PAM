function [m_spect]= f_Q_transform(v_sig, Fe, Q,note_min, note_max, freq_la_ref)

% Varible
Nfft= 2^15;

v_len_sig= length(v_sig);

Cw=1.82; % le Cw de la fenetre de Hann
% Calcule des frequences par rapport au fonction midi

nb_note= note_max - note_min +1;

v_mk= (note_min : note_max);  %les notes midi 
v_f= freq_la_ref * 2.^((v_mk- 69)/12); % les frequences des differentes bandes
v_f_red= v_f/Fe;  % inutile 

% Creation des longeurs des fenetres
v_len_fen= floor((Q * Cw) ./ (v_f/Fe));  % la longeur de la fenetre pour chaque bande
max_len_fen= v_len_fen(1); 
if mod(max_len_fen/2, 1) ~= 0
    max_len_fen= max_len_fen -1;
    v_len_fen(k)= v_len_fen(k)- 1;
end

min_len_fen= v_len_fen(end);

% Calcule des fenetres a partir des sinosoides
m_fen= zeros(nb_note, max_len_fen);

for k= 1: nb_note
    v_fen_tmp= hann(v_len_fen(k), 'periodic'); 
    deb= floor((max_len_fen - length(v_fen_tmp))/2) +1;
    fin= floor((max_len_fen + length(v_fen_tmp))/2);
    m_fen(k, deb : fin)= v_fen_tmp(1:fin-deb+1);
end

% Application de la CQT
hop = floor(min_len_fen / 3);  

frames= round((v_len_sig - max_len_fen - ceil(max_len_fen/2))/hop-1);  %nb de frame pour la tfct
m_spect= zeros(frames, nb_note);

disp(frames);         % affichage
% disp('appuyez pour lancer');
% pause();

v_sig= v_sig'; % transposition du vecteur colone en vercteur ligne

m_e= zeros(nb_note, max_len_fen);
m_e_freq=  zeros(nb_note, Nfft);

nb_chroma= 12;

a= (1: ceil(max_len_fen/2))/Fe;
disp('calcul filtre');
for l=1:nb_note
    v_demi_conus= cos(a .* v_f(l) .* 2 .*pi);
    m_e(l,:)= [fliplr(v_demi_conus) v_demi_conus];   
    m_e(l,:)= m_fen(l,:) .* m_e(l,:);
    corres_chroma= mod(l + note_min -2,12)+1;
    m_e_freq(corres_chroma,:)= m_e_freq(corres_chroma,:) + abs(fft(m_e(l,:), Nfft)); 
end

%normalisation 

% creation de la tfct
 disp('calcule TFCT');
m_tfct_sig= zeros(frames, Nfft);
for k=1: frames
   deb= k*hop + ceil(max_len_fen/2);
   fin= k*hop + max_len_fen - 1 + ceil(max_len_fen/2);
   m_tfct_sig(k,:) = abs(fft(v_sig(deb:fin), Nfft));
end

% application des filtres
m_spect= zeros(frames, nb_chroma);

disp('application filtre');
for k= 1: frames
    for l=1:nb_chroma
       v_tmp= m_tfct_sig(k,:) .* m_e_freq(l,:);
       m_spect(k,l)= m_spect(k,l) + sum(v_tmp);
    end
end

m_spect= m_spect';
end