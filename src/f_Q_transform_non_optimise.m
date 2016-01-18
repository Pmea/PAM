function [m_spect]= f_Q_transform(v_sig, Fe, Q, freq_la_ref)

% Varible
v_len_sig= length(v_sig);

Cw=1.82;
% Calcule des frequences par rapport au fonction midi
note_min= 45;   % valeur midi de note min et max
note_max= 104;
nb_note= note_max - note_min +1;

v_mk= (note_min : note_max);  %les note midi du A0 au G#8
v_f= freq_la_ref * 2.^((v_mk- 69)/12); % les frequences des differentes bandes

% figure;
% plot(v_f);

% Creation des longeurs des fenetres
v_len_fen= floor((Q * Cw) ./ (v_f/Fe));  % la longeur de la fenetre pour chaque bande
max_len_fen= v_len_fen(1); 
min_len_fen= v_len_fen(end);

% Calcule des fenetres a partir des sinosoides
m_fen= zeros(nb_note, max_len_fen);
for k= 1: nb_note
    v_fen_tmp= hann(v_len_fen(k), 'periodic'); 
    deb= floor((max_len_fen - length(v_fen_tmp))/2)+1;
    fin= floor((max_len_fen + length(v_fen_tmp))/2);
    m_fen(k, deb : fin)= v_fen_tmp(1:fin-deb+1);
end

% figure;
% hold on;
% plot(m_fen(1,:));
% plot(m_fen(13,:));
% title('Les fenetres');
% hold off;

% Application de la fft
hop = floor(min_len_fen / 3);  

frames= round((v_len_sig - max_len_fen)/hop-1);  %nb de frame pour la tfct
m_spect= zeros(frames, nb_note);

disp(frames);
disp('appuyez pour lancer');
pause();

v_sig= v_sig';      %on transpose le signal un fois pour ne pas avoir a le faire a chaque fois
for k= 1: frames
   deb= k*hop;
   fin= k*hop + max_len_fen - 1;
   disp(k);

   % compute de la CQT 
   for l=1:nb_note
       m_spect(k,l)=  sum( m_fen(l,:) .* v_sig(deb:fin) .* exp(-1j * 2 * pi * v_f(l)/Fe * (deb:fin)));
   end
   
end

m_spect= m_spect';
end