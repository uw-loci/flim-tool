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
fid_ob = fopen('objects.xls', 'w+');
fprintf(fid_ob, 'Filename\tObject Num\tArea\tPerimeter\tAverage Value\tStd Dev\r\n');



%output string size: rows = number of filenames, cols = number output
%categories. 
outVals = zeros (size(filenames,2), 11)

for j = 1:size(filenames,2)
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
    run ./metrics.m

%--------------------------------------------------------------------------

    outVals(j,:) = [mean_Tau1 stdev_Tau1 mean_A1 stdev_A1 mean_intensity...
    stdev_intensity, mean_Chisq mean_Tau2 stdev_Tau2 mean_A2 stdev_A2]
end

% Print out the metrics for each file along with the header in a text file

fprintf(fid_out,'\tmeanTau1\tstdevTau1\tmeanA1\tstdevA1\tmeanIntens\tstdevIntens');
fprintf(fid_out,'\tmeanChiSq\tmeanTau2\tstdevTau2\tmeanA2\tstdevA2\r\n');
for k =1:size(filenames,2)
    fprintf(fid_out, char(filenames(1,k)));
     for kcol = 1:size(outVals,2)
         fprintf(fid_out,'\t%6.3f', outVals(k,kcol));
     end
     fprintf(fid_out,'\r\n');
end
fclose(fid_out);
fclose(fid_ob);

%new_data = reshape(data(:,3),256,256)
%}


