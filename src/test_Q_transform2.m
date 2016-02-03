% Test de la efficiant Q-transform
% donnée de test un gamme chromatique de do joué au piano

close all;
clear all;
[sig_tmp, Fe]= audioread('audio_gammepno11025.wav');
sig= sig_tmp;


plot(sig);
freq_la_ref= 440;

Q=20;

note_midi_min= 45;  
note_midi_max= 80; 

chroma= f_Q_transform2(sig, Fe, Q, note_midi_min, note_midi_max, freq_la_ref);

figure;
imagesc(chroma);
