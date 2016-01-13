close all;
clear all;
[sig, Fe]= audioread('song.wav');
%  Fe= 44100;
%  freq=440;
%  sig= (sin((1:Fe)/Fe*freq*2*pi) + sin((1:Fe)/Fe*freq*1.26*2*pi) + sin((1:Fe)/Fe*freq*1.5*2*pi) )' ;

plot(sig);
freq_la_ref= 440;

Q=30;

spectrum= f_Q_transform(sig, Fe, Q, freq_la_ref);

figure;
imagesc(abs(flipud(spectrum)));


