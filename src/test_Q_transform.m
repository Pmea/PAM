close all;
clear all;
%[sig, Fe]= audioread('song.wav');
Fe= 44100;
sig= sin((1:2*Fe/3)/Fe*440*2*pi)';  %un sinus pur de 1/4 de seconde
plot(sig);
freq_la_ref= 440;

Q=10;

sepctrum= f_Q_transform(sig, Fe, Q, freq_la_ref);