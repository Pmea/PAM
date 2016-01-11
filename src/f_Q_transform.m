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

period_f= max_len_fen;          % variable a supprimer car inutile
m_cosin= zeros(nb_note,period_f);

a= (1: period_f)/Fe; %changer le nom de la variable
for k=1:nb_note
    m_cosin(k,:)= cos(a * v_f(k)*2*pi);
end

% figure;
% hold on;
% plot(m_cosin(1,:));
% plot(m_cosin(13,:));
% title('Les cosinusoides');
% hold off;

% Calcule des fenetres a partir des sinosoides

for k= 1: nb_note
    v_fen_tmp= hann(v_len_fen(k), 'periodic'); 
    deb= floor((max_len_fen - length(v_fen_tmp))/2)+1;
    fin= floor((max_len_fen + length(v_fen_tmp))/2);
%     figure;
%     hold on;
%     plot(m_cosin(k,:),'blue');
    m_fen(k, deb : fin)= v_fen_tmp(1:fin-deb+1);
%     plot(m_fen(k,:), 'green');
    m_fen(k, deb : fin)= m_fen(k, deb : fin) .* m_cosin(k,deb:fin); %
%     plot(m_fen(k,:), 'red');
%     hold off;
end

figure;
hold on;
plot(m_fen(1,:));
plot(m_fen(13,:));
title('Les fenetres');
hold off;

disp('youyou');

% Application de la fft

hop =  / 3; % va etre dirigier par la taille de la plus petite fenetre 

frames= round((v_len_sig - v_len_frames*10)/hop-1);  %nb de frame pour la tfct
m_spect= zeros(frames, nb_note);

for k= 1: frames
   deb= k*hop;
   fin= k*hop + len_fen-1;
   
   v_fensig= sig(deb: fin)' .* m_fen(1,:);
   m_spect(k,:)= abs(fft(v_fensig, Nfft));  %faut il garder la phase
end
figure;
imagesc(flipud(m_spect(:,1:Nfft/4)'));

end