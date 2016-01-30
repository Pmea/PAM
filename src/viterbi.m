function path_v = viterbi(probInit_v, probObs_m, probTrans_m)
% S number of States, number of Classes
% T number of Times to decode
% probInit_v    (S,1): WARNING sum_s probInit_v = 1
% probObs_m     (S,T): WARNING, For all t sum_s probObs_m(s,t) = 1   
%       probability of observing chroma given chord s at time t
%       obtained by evaluating mvnpdf(CHROMA_m(:,t), mu(accord_s), std(accord_s))    
% probTrans_m   (S,S): WARNING, For all s, sum_s probTransM(s,s') = 1
%       probability of transit from one chord s to a chord s'

% Returns path_v = chemin des états cachés en nombre

%% Parameters
S = size(probObs_m, 1);
T = size(probObs_m, 2);

%% --- Init
probCumul_m(:,1) =  probInit_v .* probObs_m(:,1);
%probCumul_m(:,1) =  log(probInit_v+eps) + log(probObs_m(:,1)+eps);


%% --- Forward
for t=2:T
    for s=1:S
        % --- tmp_v (S,1)
        [max_value, max_pos]= max(probCumul_m(:,t-1) .* probTrans_m(:,s));
         probCumul_m(s,t)    = max_value * (probObs_m(s,t)+eps);
%        [max_value, max_pos] = max( log(probCumul_m(:,t-1)+eps) + log(probTrans_m(:,s)+eps) );
%        probCumul_m(s,t)     = max_value + log(probObs_m(s,t)+eps);
        forwardPath_m(s,t)   = max_pos;
    end
end

% -- Max ending
[max_value, max_pos] = max(probCumul_m(:,T));
path_v(T) = max_pos;

%% --- Backward
for t = T-1:-1:1
    path_v(t)   = forwardPath_m(max_pos, t+1);
    max_pos     = path_v(t);
end

%keyboard

end
