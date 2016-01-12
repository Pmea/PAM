close all;
clear all;
%[sig, Fe]= audioread('song.wav');
Fe= 44100;
sig= sin((1:Fe)/Fe*440*2*pi)';

plot(sig);
freq_la_ref= 440;

Q=10;

spectrum= f_Q_transform(sig, Fe, Q, freq_la_ref);

figure;
imagesc(abs(flipud(spectrum)));