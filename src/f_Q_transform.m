function [m_spect]= f_Q_transform(sig, Fe, Q, freq_la_ref)

% Varible
Cw=1.82;
% Calcule des frequences par rapport au fonction midi
note_min= 21;   % valeur midi de note min et max
note_max= 128;
nb_note= note_max - note_min;

v_mk= (note_min : note_max);  %les note midi du A0 au G#8
v_f= freq_la_ref * 2.^((v_mk- 69)/12); % les frequences des differentes bandes

% figure;
% plot(v_f);

% Creation des sinusoides pour les fenetres
v_len_fen= floor((Q * Cw) ./ (v_f/Fe));  % la longeur de la fenetre pour chaque bande
max_len_fen= v_len_fen(1);
%v_period_f= floor(Fe./ v_len_fen); % peut etre que seul la premiere et utilise

period_f=floor(Fe/v_f(1));
m_sinus= zeros(nb_note,period_f);

a= (1: period_f)/Fe; %changer le nom de la variable
for k=1:nb_note
    m_sinus(k,:)= sin(a * v_f(k)*2*pi);
end

figure;
hold on;
plot(m_sinus(1,:));
plot(m_sinus(13,:));
hold off;
% Calcule des fenetres a partir des sinosoides

% Application de la fft

v_mk= (note_min : note_max);  %les note midi du A0 au G#8
v_f= freq_la_ref * 2.^((v_mk- 69)/12); % les frequences des differentes bandes

%c'est quoi l'unité ? les frequences on les changes en bin ?
v_len_fen= floor((Q * Cw) ./ (v_f/Fe)); % la longeur de la fenetre pour chaque bande

% il faut calculer la premiere pour definir la taille
len_fen= v_len_fen(1); % la taille la plus grande ( le plus bas en freq)
m_fen= zeros(nb_note, len_fen); % on met toute les valeurs 

% il faut encore faire des trucs la pour que ca marche
for k= 1: nb_note
    v_fen_tmp= hann( v_len_fen(k), 'periodic'); 
    deb= floor((len_fen - length(v_fen_tmp))/2)+1;
    fin= floor((len_fen + length(v_fen_tmp))/2);
    m_fen(k, deb : fin)= v_fen_tmp(1:fin-deb+1);
end

%tfct 
frames= round((v_len_sig - v_len_frames)/hop-2);  %nb de frame pour la tfct
m_spect= zeros(frames, Nfft);


for k= 1: frames
   deb= k*hop;
   fin= k*hop + len_fen-1;
   
   v_fensig= sig(deb: fin)' .* m_fen(1,:);
   m_spect(k,:)= abs(fft(v_fensig, Nfft));  %faut il garder la phase
end
figure;
imagesc(flipud(m_spect(:,1:Nfft/4)'));

end