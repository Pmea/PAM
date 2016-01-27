%Lecture du signal
% Passage en mono si audio en stéréo (ou plus)

f1 = 'hol.wav';
f2 = 'glorybox.wav';

% Audio de départ
[x1_v,Fs1]=audioread(f1);
% Audio de destination
[x2_v,Fs2]=audioread(f2);

if size(x1_v,2) >= 2 
    x1_v = (x1_v(:,1) + x1_v(:,2)) / 2;
end

if size(x2_v,2) >= 2 
    x2_v = (x2_v(:,1) + x2_v(:,2)) / 2;
end

t1_start = 3000;
t1_end = length(x1_v)/2;
t2 = 5000;

x2_v = resample(x2_v,Fs1,Fs2);

if t2 ~= 1
    t2 = floor(t2 * Fs1 / Fs2);
end

[y_v, ts_factor, total_length] = f_crossfade...
    (x1_v, x2_v, Fs1, t1_start, t1_start + floor(length(x2_v)/3), t2);

player = audioplayer(y_v,Fs1);