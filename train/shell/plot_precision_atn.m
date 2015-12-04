clear; close all; clc;

% load data
DATA = dlmread ('../../data/predict/summary/PatN.combined.tsv', '\t', 1, 0);
threshold = DATA(:,1);
common_nbr = DATA(:,2) ./ threshold;
pref = DATA(:,3) ./ threshold;
jaccard = DATA(:,4) ./ threshold;
adamic = DATA(:,5) ./ threshold;
delta = DATA(:,6) ./ threshold;
random = DATA(:,7) ./ threshold;
nmf = DATA(:,8) ./ threshold;

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
xlabel('Top Position','Fontsize', 14);
ylabel('Precision @N','Fontsize', 14);
title('Link Prediction - Precision @N', 'Fontsize', 18);
h = legend('Adamic-Adar','Common-Neighbors','Delta','Jaccard','Matrix Factorization','Preferential-Attachment','Random');
legend (h, 'location', 'northeast');
set (h, 'fontsize', 8);

% print
print -dpng '../../report/PatN.precision.png';
close all;