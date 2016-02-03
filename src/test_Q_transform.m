% test Q_transforme classique avec une gamme de piano

close all;
clear all;
[sig, Fe]= audioread('audio_gammepno11025.wav');

plot(sig);
freq_la_ref= 440;

Q=20;

note_midi_min= 21;  
note_midi_max= 104; 

spectrum= f_Q_transform(sig, Fe, Q, note_midi_min, note_midi_max, freq_la_ref);

figure;
imagesc(abs(flipud(spectrum)));

chroma= f_CQTtoChroma(abs(spectrum), note_midi_min);

figure; 
imagesc(chroma);

