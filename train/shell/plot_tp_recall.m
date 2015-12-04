clear; close all; clc;

N = 25401;

% load data
DATA = dlmread ('../../data/predict/summary/TP.combined.augmented.tsv', '\t', 1, 0);
threshold = DATA(:,1);
coverage = DATA(:,9);
common_nbr = DATA(:,2) ./ coverage;
pref = DATA(:,3) ./ coverage;
jaccard = DATA(:,4) ./ coverage;
adamic = DATA(:,5) ./ coverage;
delta = DATA(:,6) ./ coverage;
random = DATA(:,7) ./ coverage;
nmf = DATA(:,8) ./ coverage;

% plot
figure; hold on;
plot(threshold, adamic, 'r-');
plot(threshold, common_nbr, 'b-');
plot(threshold, delta, 'c-');
plot(threshold, jaccard, 'm-');
plot(threshold, nmf, 'k-');
plot(threshold, pref, 'y-');
plot(threshold, random, 'g-');
grid on;
xlabel('Pruning Threshold','Fontsize', 14);
ylabel('Recall','Fontsize', 14);
title('Link Prediction - Recall vs Pruning Threshold', 'Fontsize', 18);
h = legend('Adamic-Adar','Common-Neighbors','Delta','Jaccard','Matrix Factorization','Preferential-Attachment','Random');
legend (h, 'location', 'northwest');
set (h, 'fontsize', 8);

% print
print -dpng '../../report/TP.recall.png';
close all;