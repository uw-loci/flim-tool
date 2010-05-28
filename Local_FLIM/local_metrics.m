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

%{
while (preview)
    switch (analyzesel)
        case '1p'
            for k =1:numfiles
                figure()
                imagesc(A1{k})
            end 
            preview = 1;
        case '2p'
            for k =1:numfiles
                figure()
                imagesc(A2{k})
            end 
            preview = 1;
        case '3p'
            for k =1:numfiles
                figure()
                imagesc(Tau1{k})
            end 
            preview = 1;
        case '4p'
            for k =1:numfiles
                figure()
                imagesc(Tau2{k})
            end     
            preview = 1;
        case '5p'
            for k =1:numfiles
                figure()
                imagesc(Chisq{k})
            end 
            preview =1;
        case '6p'
            for k =1:numfiles
                figure()
                imagesc(A2{k}./(A2{k} + A1{k}))
            end 
            preview = 1;
    end
    
    fprintf(1,'CHOOSE IMAGE TO ANALYZE\n')
    fprintf(1,'1 - Analyze A1 \n');
    fprintf(1,'2 - Analyze A2 \n');
    fprintf(1,'3 - Analyze Tau1\n');
    fprintf(1,'4 - Analyze Tau2\n');
    fprintf(1,'5 - Analyze Chisq\n');
    fprintf(1,'6 - Analyze Fractional contribution of A2 (short LT)\n');
    fprintf(1,'q  - Quit\n');
    analyzesel = input ('Please enter selection: ', 's');
    fprintf(1,'\n*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*\n');
    
    if ((strcmp(analyzesel, '1'))||(strcmp(analyzesel, '2'))||(strcmp(analyzesel, '3'))||...
        (strcmp(analyzesel, '4'))||(strcmp(analyzesel, '5'))||(strcmp(analyzesel, '6'))||...
        (strcmp(analyzesel, 'q')))
        preview = 0;
    end
    
end
%}

switch (analyzesel)
        case '1'
           lifetime_im = A1{j};
        case '2'
            lifetime_im = A2{j};
        case '3'
            lifetime_im = Tau1{j};
        case '4'
            lifetime_im = Tau2{j};
        case '5' 
            lifetime_im = Chisq{j};
        case '6'
            lifetime_im = A2{j}./(A2{j} + A1{j});
        case 'q'
            done =1;
end



if (~done) 
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

    run ./local_segmentation.m
end
