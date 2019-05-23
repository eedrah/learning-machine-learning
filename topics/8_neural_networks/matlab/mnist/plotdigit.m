function A = plotdigit(x)

x = reshape(x, 28, 28);
image(x');
axis square; axis off;
colormap(gray(256));

end