%% Segmentation
% Identify, lablel, count blobs.  Calculate metric for each blob

% Only works for biexponential fits, no efficiency_im otherwise 
% right now blob counting, want to move to homogeneous region counting


%Try Tau1 instead of efficiency_im
lifetime_im = Tau2{j};

bwim = im2bw(lifetime_im,graythresh(lifetime_im)); % currently using otsu's method for thresholding
% Experiment with newer methods from literature (SCT, ALT)

openedim = bwareaopen(bwim,30);

filled = imfill(openedim,'holes');

[B,L] = bwboundaries(filled,'noholes');
figure()
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

stats = regionprops(L,'Area','Centroid','Perimeter');
threshold = 0.94;

% loop over the boundaries
for k = 1:length(B)
    % obtain (X,Y) boundary coordinates corresponding to label 'k'
    boundary = B{k};
    % compute a simple estimate of the object's perimeter
    delta_sq = diff(boundary).^2;
    perimeter = sum(sqrt(sum(delta_sq,2)));
    % obtain the area calculation corresponding to label 'k'
    area = stats(k).Area;
    % compute the roundness metric
    roundness = 4*pi*area/perimeter^2;
    % display the results - area metric
    metric_string = sprintf('%2.2f',area);
    % mark objects above the threshold with a black circle
    %if metric > threshold
        centroid = stats(k).Centroid;
        plot(centroid(1),centroid(2),'ko');
    %end
    
    metric_string2 = sprintf('%2.2f', area);
    %text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','y',...
    %'FontSize',14,'FontWeight','bold')

    text(round(centroid(1)),round(centroid(2)),metric_string,'Color','k',...
    'FontSize',14,'FontWeight','bold')

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
    avg_val = sum(sum(masked_lt))/nnz(mask);
    
    plot(bd(:,2),bd(:,1),'w', 'LineWidth', 2)
    
    avlt_string = sprintf('%2.2f',avg_val);

    centroid = stats(i).Centroid;
    plot(centroid(1),centroid(2),'ko');
    
    metric_string2 = sprintf('%2.2f', area);
    text(round(centroid(1)),round(centroid(2)),avlt_string,'Color','k',...
    'FontSize',14,'FontWeight','bold');
end
title('Average value in region');

%% Display the perimeters of each region

figure()
imagesc(lifetime_im);
hold on

for i = 1: numobjects
    bd = B{i};
    %nnz(X) is the number of nonzero matrix elements in X
    
    mask = (L==i); % Create mask for each object
    masked_lt = mask.*lifetime_im;
    perimeter = stats(i).Perimeter;
    
    plot(bd(:,2),bd(:,1),'w', 'LineWidth', 2)
    
    perim_string = sprintf('%2.2f',perimeter);

    centroid = stats(i).Centroid;
    plot(centroid(1),centroid(2),'ko');
    
    text(round(centroid(1)),round(centroid(2)),perim_string,'Color','k',...
    'FontSize',14,'FontWeight','bold');
end
title('Perimeter of each region')
