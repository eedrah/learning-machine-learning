function A = kMeansImgQ(fileName, k, MaxIter)

ImgRGB = imread(fileName);
ImgRGBdoub = double(reshape(ImgRGB, [], 3));

[cluster, centroids] = kmeans(ImgRGBdoub, k, 'maxiter', MaxIter);

imgRGBquant = nan(size(ImgRGBdoub));
imgRGBquant(1:end,:) = centroids(cluster(1:end), :);

% For loop sometimes faster than vectorized
% for i = 1:length(cluster)
%     imgRGBquant(i, :) = centroids(cluster(i), :);
% end

imgRGBquant = reshape(imgRGBquant, size(ImgRGB));

%subplot(1, 2, 1)
imshow(ImgRGB)
%subplot(1, 2, 2)
figure
imshow(uint8(imgRGBquant))