%Create a qqplot of the each variable with respect to chi-squared
figure()
subplot(321); normplot(tau1vals{j});title('Tau1 Normal Probability Plot');
subplot(322); normplot(tau2vals{j});title('Tau2 Normal Probability Plot');
subplot(323); normplot(a1vals{j});title('A1 Normal Probability Plot');
subplot(324); normplot(a2vals{j});title('A2 Normal Probability Plot');
subplot(325); normplot(chivals{j});title('Chi Normal Probability Plot'); % Probably wouldn't tell you much
subplot(326); normplot(intvals{j});title('Intensity Normal Probability Plot');
suptitle(filename);


