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

Y = [adamic common_nbr delta jaccard nmf pref random];

% plot
figure; hold on;
h = bar(threshold, Y, 'hist');
set (h(1), 'facecolor', 'r');
set (h(2), 'facecolor', 'b');
set (h(3), 'facecolor', 'c');
set (h(4), 'facecolor', 'm');
set (h(5), 'facecolor', 'k');
set (h(6), 'facecolor', 'y');
set (h(7), 'facecolor', 'g');

grid on;
xlabel('Top Position','Fontsize', 14);
ylabel('Precision @N','Fontsize', 14);
title('Link Prediction - Precision @N', 'Fontsize', 18);
h = legend('Adamic-Adar','Common-Neighbors','Delta','Jaccard','Matrix Factorization','Preferential-Attachment','Random');
legend (h, 'location', 'northeast');
set (h, 'fontsize', 8);

% print
print -dpng '../../report/PatN.precision.bar.png';

close all;