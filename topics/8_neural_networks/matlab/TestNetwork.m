j = 10000;
V = Xtest(j,:) + rand()*0;
%V = Xtest(j,:);

A1(:,:,1) = W1(:,:,1)*[1; V'];
Z1(:,:,1) = [1; activate(A1(:,:,1))];

% Layer 2
A2(:,:,1) = W2(:,:,1)*Z1(:,:,1);
Z2(:,:,1) = [1; activate(A2(:,:,1))];

% Layer 3 (output)
A3(:,:,1) = W3(:,:,1)*Z2(:,:,1);
YhatTest(j, :) = activate(A3(:,:,1))';
%disp(YhatTest(j,:))

% Z1(:,:,1), Z2(:,:,1),

[(1:10)' YhatTest(j,:)']

%% Plot number of interest

i = 9991; Xplot = testData(i,2:end)'; Xplot = reshape(Xplot, 28, 28); image(Xplot'); axis square; axis off; colormap(gray); [classTest(i) YhatClass(i)]