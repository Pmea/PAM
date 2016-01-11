[sig, Fe]= audioread('song.wav');
%Fe= 44100;
Q=1;
Nfft= 2^12;
freq_la_ref= 440;
%sig= zeros(1, Fe*10);

sepctrum= f_Q_transform(sig, Fe, Q, Nfft, freq_la_ref);