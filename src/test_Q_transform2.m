close all;
clear all;
[sig, Fe]= audioread('audio_gammepno.wav');
%  Fe= 44100;
%  freq=440;
%  sig= (sin((1:Fe)/Fe*freq*2*pi) + sin((1:Fe)/Fe*freq*1.26*2*pi) + sin((1:Fe)/Fe*freq*1.5*2*pi) )' ;

plot(sig);
freq_la_ref= 440;

Q=10;

note_midi_min=21;
note_midi_max= 127;

spectrum= f_Q_transform2(sig, Fe, Q, note_midi_min, note_midi_max, freq_la_ref);

figure;
imagesc(abs(flipud(spectrum)));

chroma= f_CQTtoChroma(abs(spectrum), note_midi_min);

figure; 
imagesc(chroma);

