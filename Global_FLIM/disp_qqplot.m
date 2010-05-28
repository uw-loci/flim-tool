%% Visualize the normality of each distribution by using normality plot

% Create a normality plot of each variable
figure()
subplot(321); qqplot(chivals{j},tau1vals{j});title('Tau1 Q-Q Plot vs Chi-Squared');
subplot(322); qqplot(chivals{j},tau2vals{j});title('Tau2 Q-Q Plot vs Chi-Squared');
subplot(323); qqplot(chivals{j},a1vals{j});title('A1 Q-Q Plot vs Chi-Squared');
subplot(324); qqplot(chivals{j},a2vals{j});title('A2 Q-Q Plot vs Chi-Squared');
subplot(325); qqplot(chivals{j},intvals{j});title('Intensity Q-Q Plot vs Chi-Squared'); % Probably wouldn't tell you much
suptitle(filename);