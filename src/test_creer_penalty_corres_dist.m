% script pour tester f_create_penalty_corres_dist
% avec matrice de penalité 
close all;
clear all;


% creation des chromas de referance par analyse d'accords de piano
inputAudioFile = './DOMAJEUR.wav';
inputAudioFile2 = './DOMINEUR.wav';

[data_v, sr_hz] = audioread(inputAudioFile);
[data_v2, sr_hz] = audioread(inputAudioFile2);

L_sec					= 0.2;	% --- window duration in seconds
STEP_sec				= L_sec/3;	% --- hop size in seconds
L_n				= round(L_sec*sr_hz);
STEP_n			= round(STEP_sec*sr_hz);


data_v = data_v(:,1);
data_v2 =data_v2(:,1);


detune=f_tuning(inputAudioFile);

obs_m = extractChroma(data_v, sr_hz, L_n, STEP_n, detune);
obs_m2 = extractChroma(data_v2, sr_hz, L_n, STEP_n, detune);

c=obs_m(:,6); %chroma domajeur   
d=obs_m2(:,3);%chroma domineur

%decaler
mat = zeros(24,11);
decalage =0;
for j= 1:24
    if j<=12
        for i=1:12
            mat(j,i)=c(mod(i-1-decalage,12)+1);
        end
    end 
    if j>12
         for i=1:12
         mat(j,i)=d(mod(i-1-decalage,12)+1);
         end
    end
    

    decalage= decalage+1;
end

% creation des chromas de ref
c_chroma_ref= cell(1,34);
v_cor=[1;2;2;3;4;4;5;6;7;7;8;9;9;10;11;11;12;
           13;14;14;15;16;16;17;18;19;19;20;21;21;22;23;23;24];  
     
    

for k=1:size(c_chroma_ref,2)
    c_chroma_ref{k}= mat(v_cor(k),:)';
end

[m_penalty, m_corres]= f_creer_penalty_et_corres_dist(c_chroma_ref);
