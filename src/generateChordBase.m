function c_chroma_ref = generateChordBase()
% Création manuelle d'une base de chromas pour les 24 accords.
% Obtenue par rotation de chromas de Do et de Dom obtenus en analysant 
% un accord joué au piano 

%% Lecture des accords joués
inputAudioFile = './DOMAJEUR.wav';
inputAudioFile2 = './DOMINEUR.wav';

[data_v, sr_hz] = audioread(inputAudioFile);
[data_v2, sr_hz] = audioread(inputAudioFile2);

data_v = data_v(:,1);
data_v2 = data_v2(:,1);


%% Paramètres
L_sec					= 0.2;	% --- window duration in seconds
STEP_sec				= L_sec/3;	% --- hop size in seconds
L_n				= round(L_sec*sr_hz);
STEP_n			= round(STEP_sec*sr_hz);

%% Calcul des vecteurs d'observations chroma
detune = f_tuning(inputAudioFile);

obs_m = extractChroma(data_v, sr_hz, L_n, STEP_n, detune);
obs_m2 = extractChroma(data_v2, sr_hz, L_n, STEP_n, detune);

c=obs_m(:,6); % chroma Do majeur   
d=obs_m2(:,3); % chroma Do mineur

%% Rotation des 2 chromas
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

%% Création de la base des chromas de ref
c_chroma_ref= cell(1,24);

for k=1:size(c_chroma_ref, 2)
    c_chroma_ref{k}= mat(k,:)';
end


