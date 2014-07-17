function toy_data_generate()
tic

close all
rand('state', 0);
randn('state', 0);

file_name       = 'toy_data';
data_length     = 10000;
input_size      = 23;
output_size     = 20;
ori_start       = (input_size-output_size)/2;

frame1_images    = double((rand(data_length, input_size, input_size)<0.5));
frame2_images    = zeros(data_length, output_size, output_size);
frame3_images    = zeros(data_length, output_size, output_size);

f2_st   = zeros(data_length, 2);
f3_st   = zeros(data_length, 2);

for i=1:data_length
    max_ind     = input_size-output_size+1;
    f3_stx      = ceil(rand*(max_ind));
    f3_sty      = ceil(rand*(max_ind));
    f2_stx      = ceil((f3_stx + ori_start)/2);
    f2_sty      = ceil((f3_sty + ori_start)/2);
    f2_stx      = min(f2_stx, 31);
    f2_sty      = min(f2_sty, 31);
    
    frame2_images(i, :, :) = frame1_images(i, f2_stx:(f2_stx + output_size -1), f2_sty:(f2_sty + output_size -1));
    frame3_images(i, :, :) = frame1_images(i, f3_stx:(f3_stx + output_size -1), f3_sty:(f3_sty + output_size -1));
    
    f2_st(i, :)     = [f2_stx, f2_sty];
    f3_st(i, :)     = [f3_stx, f3_sty];
end

%reshape the data
frame1_images   = reshape(frame1_images, data_length, input_size*input_size);
frame2_images   = reshape(frame2_images, data_length, output_size*output_size);
frame3_images   = reshape(frame3_images, data_length, output_size*output_size);

save(file_name);
fprintf('file saved, file_name %s!\n', file_name);

toc
