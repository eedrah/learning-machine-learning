function A = expmaxImgQ(fileName, K)

ImgRGB = imread(fileName);
ImgRGBdoub = double(reshape(ImgRGB, [], 3));

%[clust, mean] = kmeans(ImgRGBdoub, k, 'maxiter', MaxIter);
[GMMClusts, GMMMeans, GMMCovs, GMMCoeffs, LogLike] = expmax(ImgRGBdoub, K, 'scale', false);

[~, HardClust] = max(GMMClusts, [], 2);

imgRGBquant = nan(size(ImgRGBdoub));
for i = 1:length(HardClust)
    imgRGBquant(i, :) = GMMMeans(HardClust(i), :);
end
imgRGBquant = reshape(imgRGBquant, size(ImgRGB));

%subplot(1, 2, 1)
imshow(ImgRGB)
%subplot(1, 2, 2)
figure
imshow(uint8(imgRGBquant))