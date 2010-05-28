% Displays the dependence scatter of each parameter versus chi squared.  
%
figure()
subplot(321); scatter(tau1vals{j},chivals{j});ylabel('chisq');xlabel('Tau1');title('Tau1 Dep. Scatter vs Chi-Squared');
subplot(322); scatter(tau2vals{j},chivals{j});ylabel('chisq');xlabel('Tau2');title('Tau2 Dep. Scatter vs Chi-Squared');
subplot(323); scatter(a1vals{j},chivals{j});ylabel('chisq');xlabel('A1');title('A1 Dep. Scatter vs Chi-Squared');
subplot(324); scatter(a2vals{j},chivals{j});ylabel('chisq');xlabel('A2');title('A2 Dep. Scatter vs Chi-Squared');
subplot(325); scatter(intvals{j},chivals{j});ylabel('chisq');xlabel('Intensity');title('Intensity Dep. Scatter vs Chi-Squared'); % Probably wouldn't tell you much
suptitle(filename);               
