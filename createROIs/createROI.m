%% Read in binary thresholded image and createROI label matrix
% Create thresholded tif files in imagej and convert them to ROI
% label matrices 


[filenames pathname] = uigetfile('./*.tif','MultiSelect','on')
filenames = cellstr(filenames);

numfiles = length(filenames);

for i = 1:numfiles
    
    image{i} = imread(filenames{i},'tif');

end

for i = 1: numfiles
    roi_matrix{i} = bwlabel(image{i},8);
    
end

%{
for i = 1: numfiles
    temproi = roi_matrix{1};
    file_noext = filenames{i}(1:length(filenames{i})-4);
    roi_file = strcat(file_noext,'_roi',int2str(i));
    
    save(roi_file, 'temproi','-ascii')
end
%}

for i = 1: numfiles
    temproi = roi_matrix{i};
    file_noext = filenames{i}(1:length(filenames{i})-4);
    roi_file = strcat(file_noext,'_roi');
    fid_roi = fopen(strcat(roi_file,'.xls'), 'w+')
    for row = 1:size(temproi,1)
        for col = 1:size(temproi,2)
            fprintf(fid_roi,'\t%d', temproi(row,col));
        end
        fprintf(fid_roi,'\r\n');
        
    end
    
    fclose(fid_roi);
end
