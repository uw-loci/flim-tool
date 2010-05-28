%% Calculating metrics

%Parse the data into columns 
x = dat1.data(:,1);
y = dat1.data(:,2);

%Making 2-D pixelwise images


for i = 1:length(x)
        intensity{j}(x(i)+1, y(i)+1) = dat1.data(i,3)';
        A1{j}(x(i)+1, y(i)+1) = dat1.data(i,4)';
        Tau1{j}(x(i)+1, y(i)+1) = dat1.data(i,5)';
 
        
        if (~mono) % bixponential fit
            A2{j}(x(i)+1, y(i)+1) = dat1.data(i,6)';
            Tau2{j}(x(i)+1, y(i)+1) = dat1.data(i,7)';
            Chisq{j}(x(i)+1, y(i)+1) = dat1.data(i,8)';
        else % mono exponential fit
            Chisq{j}(x(i)+1, y(i)+1) = dat1.data(i,6)';
            A2{j} = zeros(size(A1{j},1),size(A1{j},2)); % fit a2 with zeros
            Tau2{j} = zeros(size(Tau1{j},1),size(Tau1{j},2)); % fit tau2 with zeros
        end
                
                
end

%clearvars char_remain dat1 format i x y mono name remain dat

%Calculates the mean and standard dev. of all the non-zero pixels in the
%image
[tau1row tau1col tau1vals{j}] = find(Tau1{j});
chivals{j} = zeros(size(tau1row,1),1);
intvals{j} = zeros(size(tau1row,1),1);

%For every place where Tau1 is nonzero, create an entry in the chivals vector
%Also create an entry in the intvals vector
for chx = 1:size(tau1row,1)
    chivals{j}(chx) = Chisq{j}(tau1row(chx),tau1col(chx));
    intvals{j}(chx) = intensity{j}(tau1row(chx),tau1col(chx));
end



[row col a1vals{j}] = find(A1{j});

% [row col intvals] = find(intensity);% Only look at intensities where tau1
% nonzero
%[x y chivals] = find(Chisq); % Instead of calculating all chi sq only look
%at chissq where tau1 nonzero

mean_Tau1 = mean(tau1vals{j});
mean_intensity= mean(intvals{j});
mean_A1 = mean(a1vals{j});
mean_Chisq = mean(chivals{j});
stdev_Tau1 = std(tau1vals{j});
stdev_A1 = std(a1vals{j});
stdev_intensity = std(intvals{j});
stdev_Chisq = std(chivals{j});

% Initialize the A2 and Tau2 variables to zero
mean_Tau2=0;mean_A2=0;stdev_Tau2=0;stdev_A2=0;
tau2vals{j}=zeros(1,length(chivals{j}));a2vals{j}=zeros(1,length(chivals{j}));

if (mono ~= 1) % If bi exponential, calculate a2 and tau2 matrices too
    [tau2row tau2col tau2vals{j}] = find(Tau2{j});
    [x y a2vals{j}] = find(A2{j});
    mean_Tau2 = mean(tau2vals{j});
    mean_A2 = mean(a2vals{j});
    stdev_Tau2 = std(tau2vals{j});
    stdev_A2 = std(a2vals{j});
end

% %% Detect any linear dependence of chi squared on a1 a2 t1 t2
% 
% %Create a qqplot of the each variable with respect to chi-squared
% 
% figure()
% subplot(321); normplot(tau1vals{j});title('Tau1 Normal Probability Plot');
% subplot(322); normplot(tau2vals{j});title('Tau2 Normal Probability Plot');
% subplot(323); normplot(a1vals{j});title('A1 Normal Probability Plot');
% subplot(324); normplot(a2vals{j});title('A2 Normal Probability Plot');
% subplot(325); normplot(chivals{j});title('Chi Normal Probability Plot'); % Probably wouldn't tell you much
% subplot(326); normplot(intvals{j});title('Intensity Normal Probability Plot');
% suptitle(filename);
% 
% %% Visualize the normality of each distribution by using normality plot
% 
% % Create a normality plot of each variable
% figure()
% subplot(321); qqplot(chivals{j},tau1vals{j});title('Tau1 Q-Q Plot vs Chi-Squared');
% subplot(322); qqplot(chivals{j},tau2vals{j});title('Tau2 Q-Q Plot vs Chi-Squared');
% subplot(323); qqplot(chivals{j},a1vals{j});title('A1 Q-Q Plot vs Chi-Squared');
% subplot(324); qqplot(chivals{j},a2vals{j});title('A2 Q-Q Plot vs Chi-Squared');
% subplot(325); qqplot(chivals{j},intvals{j});title('Intensity Q-Q Plot vs Chi-Squared'); % Probably wouldn't tell you much
% suptitle(filename);
% %%  Visualize of the correlation between the fit (Chisq) and each parameter
% 
% %Create dependence scatter plot of each variable
% figure()
% subplot(321); scatter(tau1vals{j},chivals{j});ylabel('chisq');xlabel('Tau1');title('Tau1 Dep. Scatter vs Chi-Squared');
% subplot(322); scatter(tau2vals{j},chivals{j});ylabel('chisq');xlabel('Tau2');title('Tau2 Dep. Scatter vs Chi-Squared');
% subplot(323); scatter(a1vals{j},chivals{j});ylabel('chisq');xlabel('A1');title('A1 Dep. Scatter vs Chi-Squared');
% subplot(324); scatter(a2vals{j},chivals{j});ylabel('chisq');xlabel('A2');title('A2 Dep. Scatter vs Chi-Squared');
% subplot(325); scatter(intvals{j},chivals{j});ylabel('chisq');xlabel('Intensity');title('Intensity Dep. Scatter vs Chi-Squared'); % Probably wouldn't tell you much
% suptitle(filename);
% 

%% FRET Analysis
% Calculate Fret Efficiency images, fractional intensity images, average
% lifetime images, lifetime weighted quantum yield images and FRET
% efficientcy images



%{
if (mono ~= 1) %if biexponential, can calculate the fractional intensity, fractional contribution, average lifetime, LT Weighted Quantum Yield, FRET Efficiency
    % FRET efficiency
    efficiency_im = 1 - Tau2{j}./Tau1{j};
    figure()
    % imshow(efficiency_im);
    colormap('hot');
    colorbar;
    title(strcat('eff_',filename),'Interpreter','none');
    
    % Average lifetime
%     avg_lifetime = 
%     for i = 1:
    
end
%}

% 
% %Show tau2 image for comparison
% imagesc(Tau2{j});
% 
% %HISTOGRAM DISPLAY IN SUBPLOTS
% figure()
% title(filename);
% subplot(321);hist(tau1vals{j}, 1000); title('tau1 distribution');
% subplot(322);hist(tau2vals{j},1000);title('tau2 distribution');
% subplot(323);hist(a1vals{j}, 1000); title('a1 distribution');
% subplot(324);hist(a2vals{j},1000);title('a2 distribution');
% subplot(325);hist(chivals{j},1000); title('Chi Squared distribution');
% subplot(326);hist(intvals{j},1000);title('Intensity distribution');
% suptitle(filename);
