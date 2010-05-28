%% Importing data from TRIM2
% Requirements: After creating the images in TRIM2, be sure to choose "Save
% All Raw Data".  
%
% V1: taus and a1s from nonzero pixels.  intens and chi from non zero tau1
% pixels.  histograms only done for last file.
% V2: histograms displayed per file in subplots.  mono exponential show up
% as 1 count in tau2 and a2 histograms.
% V3: dBreak up metric calculations into separate m script file
% V4: Start segmentation algorithms and GUI - Rename to flimtool
% V5: Keep all the images and vals vectors in a cell for GUI

clear
close all;
[filenames pathname] = uigetfile('./*.txt','MultiSelect','on')
filenames = cellstr(filenames);
oldpath = pwd;
fid_out = fopen('output.xls', 'w+');

numfiles = size(filenames,2);

fid_ob = fopen('objects.xls', 'w+');
fprintf(fid_ob, 'Filename\tObject Num\tArea\tPerimeter\tAverage Value\tStd Dev\tCentX\tCentY\r\n');

im_chosen = 0;
done = 0;
preview = 0;
while (~im_chosen)
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
    
    if (analyzesel == 'q')
        done = 1;
        im_chosen = 1;
    end
    
    if ((strcmp(analyzesel, '1'))||(strcmp(analyzesel, '2'))||(strcmp(analyzesel, '3'))||...
        (strcmp(analyzesel, '4'))||(strcmp(analyzesel, '5'))||(strcmp(analyzesel, '6')))
        im_chosen = 1;
%       else
%         
%         if((strcmp(analyzesel, '1p'))||(strcmp(analyzesel, '2p'))||(strcmp(analyzesel, '2p'))||...
%         (strcmp(analyzesel, '3p'))||(strcmp(analyzesel, '4p'))||(strcmp(analyzesel, '5p'))||...
%         (strcmp(analyzesel, '5p')))
%         im_chosen = 1;
%         preview = 1;
%         end
    end
    
    
end

if( ~done)
    for j = 1:numfiles
        %----------------------------------------------------------------------
        % Within j for loop are the metrics for each image
        %Import the data with header of 23 lines
        %filename = 'test_a_biexp.txt';
        cd(pathname);
        filename = filenames(1,j);
        dat = importdata(char(filename),'\t', 2);

        format = dat(2);
        [name remain] = strtok(format,':');

        char_remain = char(remain);
        mono = 1;


        if(char_remain(3) == 'B') % Bi exponential
                dat1 = importdata(char(filename),'\t',31);
                mono = 0;
        else
            if(char_remain(3) == 'M') % Mono exponential
                dat1 = importdata(char(filename),'\t',23); 
            end
        end

        cd(oldpath);


        run ./local_metrics.m

    %--------------------------------------------------------------------------
    end
end

%% Let user decide what information should be displayed
    
    % Need to choose image to segment
    % small display of all images
   
    
    %Then have the user choose:
    %
    %   1 - Dependence scatter plot of parameters versus  Chi^2
    %   2 - Normal probability plot of parameters
    %   3 - Quantile-Quantile plot of parameters versus Chi^2
    %   4 - Histograms of Tau, A, and ChiSq and Intensity distributions
    %   5 - Tau1 images
    %   6 - Tau2 images
    %   7 - A1 images
    %   8 - A2 images
    %   10 - Fractional contribution of A2 (short LT)
    %   11 - FRET efficiency images
    %   12 - Average lifetime images
    %   q  - Quit

    % ->If images, ask what colormap
    % ->Ask if should export
    % -> Ask for a filename if exporting
    % -> Ask if he should


while (~done)
    fprintf(1,'1 - Dependence scatter plot of parameters versus  Chi^2\n');
    fprintf(1,'2 - Normal probability plot of parameters\n');
    fprintf(1,'3 - Quantile-Quantile plot of parameters versus Chi^2\n');
    fprintf(1,'4 - Histograms of Tau, A, and ChiSq and Intensity distributions\n');
    fprintf(1,'5 - Tau1 images\n');
    fprintf(1,'6 - Tau2 images\n');
    fprintf(1,'7 - A1 images\n');
    fprintf(1,'8 - A2 images\n');
    fprintf(1,'9 - Chi squared images\n');
    fprintf(1,'10 -  Fractional contribution of A2 (short LT)\n');
    fprintf(1,'11 - FRET efficiency images\n');
    fprintf(1,'12 - Average lifetime images\n');
    fprintf(1,'q  - Quit\n');
    dispsel =input ('Please enter selection: ', 's');
    fprintf(1,'*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*\n');

    %No fall through in matlab switch statement (no breaks necessary)
    switch dispsel
        case '1'
            for j = 1:numfiles
                % display the scatter of the parameters versus Chisq
                run ./disp_scatter
            end
        case '2'
            % display the normal probablity plot of parameters
            for j = 1:numfiles
                run ./disp_normprob
            end
        case '3'
            % display quantile-quantile plot of parameter distributions
            for j = 1:numfiles
                run ./disp_qqplot
            end
        case '4'
            %
            for j = 1:numfiles
                run ./disp_hist
            end
        case '5'
            for j = 1:numfiles
                run ./disp_tau1
            end
            
        case '6'
            for j = 1:numfiles
                run ./disp_tau2
            end
        case '7'
            for j = 1:numfiles
                run ./disp_a1
            end
        case '8'
            for j = 1:numfiles
                run ./disp_a2
            end   
        case '9'
            for j = 1:numfiles
                run ./disp_chi
            end
        case '10'
            for j = 1:numfiles
                run ./disp_frac_a2
            end
        case '11'
            for j = 1:numfiles
                run ./disp_fret_efficiency
            end
        case '12'
            for j = 1:numfiles
                run ./disp_avg_lifetime
            end
        case 'q'
            done = 1;
        otherwise
    end
    
    
end



fclose(fid_ob);