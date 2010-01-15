%% Calculating metrics

%Parse the data into columns 
x = dat1.data(:,1);
y = dat1.data(:,2);

%Making 2-D pixelwise images


for i = 1:length(x)
        intensity{j}(x(i)+1, y(i)+1) = dat1.data(i,3)';
        A1{j}(x(i)+1, y(i)+1) = dat1.data(i,4)';
        Tau1{j}(x(i)+1, y(i)+1) = dat1.data(i,5)';
        Chisq{j}(x(i)+1, y(i)+1) = dat1.data(i,6)';
        
        if (~mono)
            A2{j}(x(i)+1, y(i)+1) = dat1.data(i,6)';
            Tau2{j}(x(i)+1, y(i)+1) = dat1.data(i,7)';
        end
end

%If monoexponential, then fill the A2 and Tau2 images with zeros.
if (mono)
    A2{j} = zeros(size(A1{j},1),size(A1{j},2));
    Tau2{j} = zeros(size(Tau1{j},1),size(Tau1{j},2));
end



%clearvars char_remain dat1 format i x y mono name remain dat

%Calculates the mean and standard dev. of all the non-zero pixels in the
%image
[tau1row tau1col tau1vals] = find(Tau1{j});
chivals = zeros(size(tau1row,1),1);
intvals = zeros(size(tau1row,1),1);

%For every place where Tau1 is nonzero, create an entry in the chivals vector
%Also create an entry iin the intvals vector
for chx = 1:size(tau1row,1)
    chivals(chx) = Chisq{j}(tau1row(chx),tau1col(chx));
    intvals(chx) = intensity{j}(tau1row(chx),tau1col(chx));
end



[row col a1vals] = find(A1{j});

% [row col intvals] = find(intensity);% Only look at intensities where tau1
% nonzero
%[x y chivals] = find(Chisq); % Instead of calculating all chi sq only look
%at chissq where tau1 nonzero

mean_Tau1 = mean(tau1vals);
mean_intensity= mean(intvals);
mean_A1 = mean(a1vals);
mean_Chisq = mean(chivals);
stdev_Tau1 = std(tau1vals);
stdev_A1 = std(a1vals);
stdev_intensity = std(intvals);
stdev_Chisq = std(chivals);

% Initialize the A2 and Tau2 variables to zero
mean_Tau2=0;mean_A2=0;stdev_Tau2=0;stdev_A2=0;tau2vals=0;a2vals=0;

if (mono ~= 1) % If bi exponential, calculate a2 and tau2 matrices too
    [tau2row tau2col tau2vals] = find(Tau2{j});
    [x y a2vals] = find(A2{j});
    mean_Tau2 = mean(tau2vals);
    mean_A2 = mean(a2vals);
    stdev_Tau2 = std(tau2vals);
    stdev_A2 = std(a2vals);
end

%% Detect any linear dependence of chi squared on a1 a2 t1 t2

%Create a qqplot of the each variable with respect to chi-squared

figure()
subplot(321); normplot(tau1vals);title('Tau1 Normal Probability Plot');
subplot(322); normplot(tau2vals);title('Tau2 Normal Probability Plot');
subplot(323); normplot(a1vals);title('A1 Normal Probability Plot');
subplot(324); normplot(a2vals);title('A2 Normal Probability Plot');
subplot(325); normplot(chivals);title('Chi Normal Probability Plot'); % Probably wouldn't tell you much
subplot(326); normplot(intvals);title('Intensity Normal Probability Plot');
suptitle(filename);



%% Visualize the normality of each distribution by using normality plot

% Create a normality plot of each variable
figure()
subplot(321); qqplot(chivals,tau1vals);title('Tau1 Q-Q Plot vs Chi-Squared');
subplot(322); qqplot(chivals,tau2vals);title('Tau2 Q-Q Plot vs Chi-Squared');
subplot(323); qqplot(chivals,a1vals);title('A1 Q-Q Plot vs Chi-Squared');
subplot(324); qqplot(chivals,a2vals);title('A2 Q-Q Plot vs Chi-Squared');
subplot(325); qqplot(chivals,intvals);title('Intensity Q-Q Plot vs Chi-Squared'); % Probably wouldn't tell you much
suptitle(filename);

%% FRET Analysis
% Calculate Fret Efficiency images, fractional intensity images, average
% lifetime images, lifetime weighted quantum yield images and FRET
% efficientcy images

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

%Show tau2 image for comparison
imagesc(Tau2{j});

%HISTOGRAM DISPLAY IN SUBPLOTS
figure()
title(filename);
subplot(321);hist(tau1vals, 1000); title('tau1 distribution');
subplot(322);hist(tau2vals,1000);title('tau2 distribution');
subplot(323);hist(a1vals, 1000); title('a1 distribution');
subplot(324);hist(a2vals,1000);title('a2 distribution');
subplot(325);hist(chivals,1000); title('Chi Squared distribution');
subplot(326);hist(intvals,1000);title('Intensity distribution');
suptitle(filename);

%% Segmentation and Blob labeling

run ./segmentation.m
