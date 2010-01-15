function [IDX,sep] = otsu(I,n)

%OTSU Segmentation using Otsu's method.
%   IDX = OTSU(I,N) segments the array I into N classes by means of Otsu's
%   N-thresholding method. OTSU returns an array IDX containing the cluster
%   indices (from 1 to N) of each point.
%   http://www.biomecardio.com/matlab/otsu.html
%
%   IDX = OTSU(I) uses N=2 (default value).
%
%   [IDX,sep] = OTSU(I,N) also returns the value (sep) of the separability
%   criterion within the range [0 1]. Zero is obtained only with data
%   having less than N values, whereas one (optimal value) is obtained only
%   with N-valued arrays.
%
%   Notes:
%   -----
%   It should be noticed that the thresholds generally become less credible
%   as the number of classes (N) to be separated increases (see Otsu's
%   paper for more details).
%   
%   Example:
%   -------
%   load clown
%   subplot(221)
%   X = ind2gray(X,map);
%   imshow(X)
%   title('Original','FontWeight','bold')
%   for n = 2:4
%     IDX = otsu2(X,n);
%     subplot(2,2,n)
%     imagesc(IDX), axis image off
%     title(['n = ' int2str(n)],'FontWeight','bold')
%   end
%
%   Reference:
%   ---------
%   Otsu N, <a href="matlab:web('http://dx.doi.org/doi:10.1109/TSMC.1979.4310076')">A Threshold Selection Method from Gray-Level Histograms</a>,
%   IEEE Trans. Syst. Man Cybern. 9:62-66;1979
%   
%   See also GRAYTHRESH, IM2BW
%
%   -- Damien Garcia -- 2007/08, revised 2009/12
%   Visit my <a
%   href="matlab:web('http://www.biomecardio.com/matlab/otsu.html')">website</a> for more details about OTSU 

error(nargchk(1,2,nargin))

%% Checking n (number of classes)
if nargin==1
    n = 2;
elseif n==1;
    IDX = NaN(size(I));
    sep = 0;
    return
elseif n~=abs(round(n)) || n==0
    error('MATLAB:otsu:WrongNValue',...
        'n must be a strictly positive integer!')
elseif n>255
    n = 255;
    warning('MATLAB:otsu:TooHighN',...
        'n is too high. n value has been changed to 255.')    
end

%% Convert to 256 levels
if ~isa(I,'uint8')
    I = single(I);
    I = I-min(I(:));
    I = I/max(I(:));
    I = round(I*255);
end

%% Probability distribution
I = single(I);
unI = sort(unique(I));
nbins = min(length(unI),256);
if nbins==n
    IDX = ones(size(I));
    for i = 1:n, IDX(I==unI(i)) = i; end
    sep = 1;
    return
elseif nbins<n
    IDX = NaN(size(I));
    sep = 0;
    return
elseif nbins<256
    [histo,pixval] = hist(I(:),unI);
else
    [histo,pixval] = hist(I(:),256);
end
P = histo/sum(histo);
clear unI

%% Zeroth- and first-order cumulative moments
w = cumsum(P);
mu = cumsum((1:nbins).*P);

%% Maximal sigmaB^2 and Segmented image
if n==2
    sigma2B =...
        (mu(end)*w(2:end-1)-mu(2:end-1)).^2./w(2:end-1)./(1-w(2:end-1));
    [maxsig,k] = max(sigma2B);
        
    % segmented image
    IDX = ones(size(I));
    IDX(I>pixval(k+1)) = 2;
    
    % separability criterion
    sep = maxsig/sum(((1:nbins)-mu(end)).^2.*P);
    
elseif n==3
    w0 = w;
    w2 = fliplr(cumsum(fliplr(P)));
    [w0,w2] = ndgrid(w0,w2);
   
    mu0 = mu./w;
    mu2 = fliplr(cumsum(fliplr((1:nbins).*P))./cumsum(fliplr(P)));
    [mu0,mu2] = ndgrid(mu0,mu2);
    
    w1 = 1-w0-w2;
    w1(w1<=0) = NaN;

    sigma2B =...
        w0.*(mu0-mu(end)).^2 + w2.*(mu2-mu(end)).^2 +...
        (w0.*(mu0-mu(end)) + w2.*(mu2-mu(end))).^2./w1;
    sigma2B(isnan(sigma2B)) = 0; % zeroing if k1 >= k2
    
    [maxsig,k] = max(sigma2B(:));
    [k1,k2] = ind2sub([nbins nbins],k);
    
    % segmented image
    IDX = ones(size(I),'uint8')*3;
    IDX(I<=pixval(k1)) = 1;
    IDX(I>pixval(k1) & I<=pixval(k2)) = 2;

    % separability criterion
    sep = maxsig/sum(((1:nbins)-mu(end)).^2.*P);

else
    k0 = linspace(0,1,n+1); k0 = k0(2:n);
    [k,y] = fminsearch(@sig_func,k0,optimset('TolX',1));
    k = round(k*(nbins-1)+1);

    % segmented image
    IDX = ones(size(I))*n;
    IDX(I<=pixval(k(1))) = 1;
    for i = 1:n-2
        IDX(I>pixval(k(i)) & I<=pixval(k(i+1))) = i+1;
    end

    % separability criterion
    sep = 1-y;
    
end

IDX(~isfinite(I)) = 0;


    %% Function to be minimized if n>=4
    function y = sig_func(k)

    muT = sum((1:nbins).*P);
    sigma2T = sum(((1:nbins)-muT).^2.*P);

    k = round(k*(nbins-1)+1);
    k = sort(k);
    if any(k<1 | k>nbins), y = 1; return, end

    k = [0 k nbins];
    sigma2B = 0;
    for j = 1:n
        wj = sum(P(k(j)+1:k(j+1)));
        if wj==0, y = 1; return, end
        muj = sum((k(j)+1:k(j+1)).*P(k(j)+1:k(j+1)))/wj;
        sigma2B = sigma2B + wj*(muj-muT)^2;
    end
    y = 1-sigma2B/sigma2T; % within the range [0 1]

    end

end

