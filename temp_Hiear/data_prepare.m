%% prepare the train_data, valid_data; do some initials, too
function pars = data_prepare(pars)

load(pars.data)

if pars.layer1_13_display
    pars.layer1_13_figure   = figure;
end

if pars.layer1_12_display
    pars.layer1_12_figure   = figure;
%         pars.layer1_12_figure   = pars.layer1_13_figure;
end

if pars.layer1_13_validation && pars.layer1_13_display
    pars.layer1_13_validation_figure    = figure;
%         pars.layer1_13_validation_set_x     = pars.valid_data_f1;
%         pars.layer1_13_validation_set_y     = pars.valid_data_f3;
end

if pars.layer1_12_validation && pars.layer1_12_display
    pars.layer1_12_validation_figure    = figure;
%         pars.layer1_12_validation_figure    = pars.layer1_13_validation_figure;
%         pars.layer1_12_validation_set_x     = pars.valid_data_f1;
%         pars.layer1_12_validation_set_y     = pars.valid_data_f2;
end
    

pars.length     = length(frame1_images);
pars.f1_size    = floor(sqrt(size(frame1_images, 2)));
pars.f23_size   = floor(sqrt(size(frame2_images, 2)));
pars.train_flag = [zeros(1, pars.valid_size * pars.length) ones(1, (1- pars.valid_size) * pars.length)];

pars.train_length   = sum(double(pars.train_flag));
pars.valid_length   = pars.length - pars.train_length;
pars.train_data_f1  = zeros(pars.train_length, (pars.f1_size)^2);
pars.train_data_f2  = zeros(pars.train_length, (pars.f23_size)^2);
pars.train_data_f3  = zeros(pars.train_length, (pars.f23_size)^2);
pars.valid_data_f1  = zeros(pars.valid_length, (pars.f1_size)^2);
pars.valid_data_f2  = zeros(pars.valid_length, (pars.f23_size)^2);
pars.valid_data_f3  = zeros(pars.valid_length, (pars.f23_size)^2);

tmp_train_len   = 0;
tmp_valid_len   = 0;
for i=1:pars.length
    if pars.train_flag(i)==1
        tmp_train_len   = tmp_train_len +1;
        
        pars.train_data_f1(tmp_train_len, :) = frame1_images(i, :);
        pars.train_data_f2(tmp_train_len, :) = frame2_images(i, :);
        pars.train_data_f3(tmp_train_len, :) = frame3_images(i, :);
    else
        tmp_valid_len   = tmp_valid_len +1;
        
        pars.valid_data_f1(tmp_valid_len, :) = frame1_images(i, :);
        pars.valid_data_f2(tmp_valid_len, :) = frame2_images(i, :);
        pars.valid_data_f3(tmp_valid_len, :) = frame3_images(i, :);
    end
end