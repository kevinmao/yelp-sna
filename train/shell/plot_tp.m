clear; close all; clc;

N = 25401;

% load data
DATA = dlmread ('../../data/predict/summary/TP.combined.tsv', '\t', 1, 0);
threshold = DATA(:,1);
common_nbr = DATA(:,2) / N;
pref = DATA(:,3) / N;
jaccard = DATA(:,4) / N;
adamic = DATA(:,5) / N;
delta = DATA(:,6) / N;
random = DATA(:,7) / N;
nmf = DATA(:,8) / N;

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
ylabel('Precision','Fontsize', 14);
title('Link Prediction - Precision vs Pruning Threshold', 'Fontsize', 18);
h = legend('Adamic-Adar','Common-Neighbors','Delta','Jaccard','Matrix Factorization','Preferential-Attachment','Random');
legend (h, 'location', 'southeast');
set (h, 'fontsize', 8);

% print
print -dpng '../../report/TP.precision.png';
close all;