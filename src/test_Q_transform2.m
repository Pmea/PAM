close all;
clear all;
[sig_tmp, Fe]= audioread('audio_gammepno11025.wav');
sig= sig_tmp;%(1:4*Fe);
 %Fe= 44100;
 %freq=440;
 %sig= (sin((1:Fe*3)/Fe*freq*2*pi) + sin((1:Fe*3)/Fe*freq*1.26*2*pi) + sin((1:Fe*3)/Fe*freq*1.5*2*pi) )' ;

plot(sig);
freq_la_ref= 440;

Q=20;

note_midi_min= 33;  
note_midi_max= 92; 

chroma= f_Q_transform2(sig, Fe, Q, note_midi_min, note_midi_max, freq_la_ref);

figure;
imagesc(chroma);
