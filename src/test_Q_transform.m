close all;
clear all;
[sig, Fe]= audioread('song.wav');
Nfft= 2^12;
freq_la_ref= 440;

Q=10;

sepctrum= f_Q_transform(sig, Fe, Q, freq_la_ref);