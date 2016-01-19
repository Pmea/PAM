nbiterations = 100;
valeurs = zeros(1,nbiterations);

% Ta musique préférée
filename = 'hold.wav';

tic;

for n = 1:nbiterations
    valeurs(n) = f_tuning(filename);
end

toc;

disp(min(valeurs))
disp(max(valeurs))
disp(max(valeurs) - min(valeurs))
disp(mean(valeurs))