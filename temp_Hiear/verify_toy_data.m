%verify_toy_data.m
%this is for verifying the toy data
load('toy_data');

figure
imagesc(reshape(frame1_images(1, :), input_size, input_size), [0,1]);
colormap gray;
figure
imagesc(reshape(frame2_images(1, :), output_size, output_size), [0,1]);
colormap gray;
figure
imagesc(reshape(frame3_images(1, :), output_size, output_size), [0,1]);
colormap gray;
disp(f2_st(1,:));
disp(f3_st(1,:));