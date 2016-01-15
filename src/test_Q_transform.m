close all;
clear all;
[sig, Fe]= audioread('audio_gammepno.wav');
%  Fe= 44100;
%  freq=440;
%  sig= (sin((1:Fe)/Fe*freq*2*pi) + sin((1:Fe)/Fe*freq*1.26*2*pi) + sin((1:Fe)/Fe*freq*1.5*2*pi) )' ;

plot(sig);
freq_la_ref= 440;

Q=20;

note_min=45;
note_max= 104;

spectrum= f_Q_transform(sig, Fe, Q, note_min, note_max, freq_la_ref);

figure;
imagesc(abs(flipud(spectrum)));

[acti_note, frames]= size(spectrum);

chroma= zeros(frames, 12);

for k= 1:frames
    for l=1:acti_note
        pos= mod(l+ note_min -1 , 12)+1;
        chroma(k, pos)= chroma(k, pos) + abs(spectrum(l, k));
    end
end

figure; 
imagesc(chroma');


