function pars = pars_initial(method)

pars    = struct();

if strcmp(method, 'hiear')==1
%% Parameters for hiear (two layers) method
    pars.method     = 'hiear';
    pars.data       = 'toy_data'; 
    pars.valid_size = 0.1;
    tmp_clock       = clock;
    pars.time_now   = [int2str(tmp_clock(1)) int2str(tmp_clock(2)) int2str(tmp_clock(3)) 'T' int2str(tmp_clock(4)) int2str(tmp_clock(5))];
    pars.result_pre = 'result/';
    pars.log_pre    = 'logs/';
    pars.layer_pre  = 'layer_data/';
    pars.save       = [pars.result_pre 'toy_result_' pars.time_now];
    pars.log_save   = [pars.log_pre 'toy_log_' pars.time_now];
    pars.gbm_who    = 'mm';
    %the input data should contain at least three arrays:
    %   frame1_images:   [data_length, input_size*input_size]
    %   frame2_images:   [data_length, output_size*output_size]
    %   frame3_images:   [data_length, output_size*output_size]
    
    %layer1 is for learning the transformations of two images
    pars.layer1_numfactors         = 400;
    pars.layer1_batchsize          = 200;
    pars.layer1_batchOrderFixed    = true;
    pars.layer1_nummap             = 300;
    pars.layer1_numepoch           = 300;
    pars.layer1_save               = [pars.layer_pre 'toy_layer1_' pars.time_now];
    
    pars.layer1_using_existed_data      = false;
    pars.layer1_from_existed_data       = false;
    pars.layer1_existed_data            = [pars.layer_pre 'toy_layer1_2014715T1558.mat'];
    
    pars.layer1_13_display              = true;
    pars.layer1_12_display              = true;
    
    if pars.layer1_13_display
        pars.layer1_13_figure   = figure;
    end
    
    if pars.layer1_12_display
%         pars.layer1_12_figure   = figure;
        pars.layer1_12_figure   = pars.layer1_13_figure;
    end
    
    pars.layer1_13_validation           = true;
    pars.layer1_12_validation           = true;
    
    pars.layer1_13_validation_set_x     = [];
    pars.layer1_13_validation_set_y     = [];
    pars.layer1_12_validation_set_x     = [];
    pars.layer1_12_validation_set_y     = [];    
    
    if pars.layer1_13_validation
        pars.layer1_13_validation_figure    = figure;
%         pars.layer1_13_validation_set_x     = pars.valid_data_f1;
%         pars.layer1_13_validation_set_y     = pars.valid_data_f3;
    end
    
    if pars.layer1_12_validation
%         pars.layer1_12_validation_figure    = figure;
        pars.layer1_12_validation_figure    = pars.layer1_13_validation_figure;
%         pars.layer1_12_validation_set_x     = pars.valid_data_f1;
%         pars.layer1_12_validation_set_y     = pars.valid_data_f2;
    end
    
    %layer1_save file should contain:
    %   layer1_13_pars:     pars for 13 transformations
    %   layer1_12_pars:     pars for 12 transformations
    
    %layer2 is for learning the transformations of transformations
    pars.layer2_numfactors         = 200;
    pars.layer2_batchsize          = 100;
    pars.layer2_batchOrderFixed    = true;
    pars.layer2_nummap             = 100;
    pars.layer2_save               = [pars.layer_pre 'toy_layer2_' pars.time_now];
    %layer2_save file should contain:
    %   layer2_pars:    pars for transformations of transformations
end