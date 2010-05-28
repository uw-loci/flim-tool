%% Segmentation
% Identify, lablel, count blobs.  Calculate metric for each blob

% right now blob counting, want to move to homogeneous region counting

%% Manual Segmentation

seg_chosen = 0;

while (~seg_chosen) 
    fprintf(1, 'CHOOSE SEGMENTATION METHOD\n');
    fprintf(1, ' 1 - Otsu Thresholding \n');
    fprintf(1, ' 2 - Manual\n');
    segmeth = input('Please enter selection: ', 's');

    switch (segmeth)   
        case '1'
            seg_chosen = 1;
            bwim = im2bw(lifetime_im,graythresh(lifetime_im)); % currently using otsu's method for thresholding
            % Experiment with newer methods from literature (SCT, ALT)

            %Morphologically opening and filling of image
            openedim = bwareaopen(bwim,30);
            seg_im = imfill(openedim,'holes');
            
            
        case '2'
            figure()
            imagesc (lifetime_im);
            strnumManObjects = input ('Please enter number of ROIs: ', 's');
            numManObjects = str2num(strnumManObjects);
            seg_chosen = 1;
            hold on
            
            % For every ROI, logical OR previous mask w. new ROI image
            man_mask = zeros(size(lifetime_im, 1),size(lifetime_im,2)); 
            for k = 1:numManObjects
                man_mask = (roipoly() | man_mask);
                imagesc(abs(1-man_mask).*lifetime_im);
            end
            hold off
            seg_im = man_mask;

    end
end



%% Compute the boundaries of the segmented image and calculate localized stats

[B,L] = bwboundaries(seg_im,'noholes');
figure()
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

stats = regionprops(L,'Area','Centroid','Perimeter');
threshold = 0.94;

area = zeros(length(B),1);
perimeter = zeros(length(B),1);
avlt  = zeros(length(B),1);
stdlt = zeros(length(B),1);

%% Display the area size in pixels for the determined objects

% loop over the boundaries
for k = 1:length(B)
    % obtain (X,Y) boundary coordinates corresponding to label 'k'
    boundary = B{k};
    % compute a simple estimate of the object's perimeter
    delta_sq = diff(boundary).^2;
    perimeter = sum(sqrt(sum(delta_sq,2)));
    % obtain the area calculation corresponding to label 'k'
    area(k,1) = stats(k).Area;
    % compute the roundness metric
    roundness = 4*pi*area/perimeter^2;
    % display the results - area metric
    metric_string = sprintf('%2.2f',area(k,1));
    % mark objects above the threshold with a black circle
    %if metric > threshold
        centroid = stats(k).Centroid;
        plot(centroid(1),centroid(2),'ko');
    %end
    
    metric_string2 = sprintf('%2.2f', area(k,1));
    %text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
    %'FontSize',14,'FontWeight','bold')

    text(round(centroid(1)),round(centroid(2)),metric_string,'Color','k',...
    'FontSize',14,'FontWeight','bold')

     text (round(centroid(1)) - 5, round(centroid(2))- 5, int2str(k),'Color','y',...
    'FontSize',14,'FontWeight','bold');

end
title('Area of region (pixels)');

%% Display the localized lifetimes for the determined objects
% Algorithm: 
% 1)loop over set of object boundaries
% 2)For each boundary, fill to create filled image
% 3) Use filled image as a mask for lifetime image (Tau1,2 or avg lifetime)

% lifetime_im is the image you want to overlay results onto

numobjects = length(B);
mask = zeros(size(lifetime_im,1),size(lifetime_im,2));

figure()
imagesc(lifetime_im);
hold on
for i = 1: numobjects
    bd = B{i};
    %nnz(X) is the number of nonzero matrix elements in X
    
    mask = (L==i); % Create mask for each object
    masked_lt = mask.*lifetime_im;
    
    %number of nonzero elements in masked image( used in avg and std)
    nz = nnz(masked_lt)
    
    %Calculate the average value of object accounting for nonzero elements
    avlt(i,1) = sum(sum(masked_lt))/nz;
    
    %Calculate the std. dev. of object only accounting for nonzero elements
    stdlt(i,1) = ((sum(sum((masked_lt.^2)))./nnz(masked_lt) - avlt(i,1)^2))^(1/nz);
    %plot(bd(:,2),bd(:,1),'w', 'LineWidth', 2)
    
    avlt_string = sprintf('%2.2f',avlt(i,1));

    centroid = stats(i).Centroid;
    %plot(centroid(1),centroid(2),'ko');
    
    text(round(centroid(1)),round(centroid(2)),avlt_string,'Color','k',...
    'FontSize',14,'FontWeight','bold');

    %testing the profiling using the radon transform and improfile
    major_axis = imline;
    theta = getAngle(major_axis.getPosition);
    
    [colsum{i} nonzeros{i} norm_prof{i,j}] = myradon(masked_lt, mask, -1*theta);
    object_im{i} = masked_lt;
    
end
title('Average value in region');

figure()
for k =1:i
subplot(i,1,k)
plot(norm_prof{k})
end
%% Display the perimeters of each region

figure()
imagesc(lifetime_im);
hold on

for i = 1: numobjects
    bd = B{i};
    %nnz(X) is the number of nonzero matrix elements in X
    
    mask = (L==i); % Create mask for each object
    masked_lt = mask.*lifetime_im;
    perimeter(i,1) = stats(i).Perimeter;
    
    plot(bd(:,2),bd(:,1),'w', 'LineWidth', 2)
    
    perim_string = sprintf('%2.2f',perimeter(i,1));

    centroid = stats(i).Centroid;
    plot(centroid(1),centroid(2),'ko');
    centx(i) = centroid(1);
    centy(i) = centroid(2);
    
    text(round(centroid(1)),round(centroid(2)),perim_string,'Color','k',...
    'FontSize',14,'FontWeight','bold');

     text (round(centroid(1)) - 5, round(centroid(2))- 5, int2str(i),'Color','y',...
    'FontSize',14,'FontWeight','bold');

    % text (round(centroid(1), round(centroid(i), 
end
title('Perimeter of each region')
%% Track the centroid for each object
centx = centx';
centy = centy';




%% Write statistics to objects file

object_stats = [area perimeter avlt stdlt];

%print filename
fprintf(fid_ob,'%s\r\n',char(filename));

%print object number and stat

for i = 1: numobjects
    ob_numstr = strcat('object ', int2str(i))
    fprintf(fid_ob,'\t%s\t%6.3f\t%6.3f\t%6.3f\t%6.3f\t%6.3f\t%6.3f\r\n',ob_numstr, area(i), perimeter(i), avlt(i),stdlt(i),...
        centx(i),centy(i));
    
    
end