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
    pars.layer1_numfactors         = 400;%400 for 13 10
    pars.layer1_batchsize          = 200;
    pars.layer1_batchOrderFixed    = true;
    pars.layer1_nummap             = 300;%300
    pars.layer1_numepoch           = 300;
    pars.layer1_save               = [pars.layer_pre 'toy_layer1_' pars.time_now];
    
    pars.layer1_using_existed_data      = false;
    pars.layer1_from_existed_data       = false;
    pars.layer1_existed_data            = [pars.layer_pre 'toy_layer1_2014717T1150.mat'];
    pars.layer1_weightPenaltyL2         = 0.001;
	pars.layer1_deltaMax 				= 0.04;
    
    pars.layer1_13_display              = false;
    pars.layer1_12_display              = false;
    
    pars.layer1_13_validation           = true;
    pars.layer1_12_validation           = true;
    
    pars.layer1_13_validation_set_x     = [];
    pars.layer1_13_validation_set_y     = [];
    pars.layer1_12_validation_set_x     = [];
    pars.layer1_12_validation_set_y     = [];    


    %layer1_save file should contain:
    %   layer1_13_pars:     pars for 13 transformations
    %   layer1_12_pars:     pars for 12 transformations
    
    %layer2 is for learning the transformations of transformations
    pars.layer2_numfactors         = 400;
    pars.layer2_batchsize          = 200;
    pars.layer2_batchOrderFixed    = true;
    pars.layer2_nummap             = 300;
    pars.layer2_numepoch           = 300;
    pars.layer2_save               = [pars.layer_pre 'toy_layer2_' pars.time_now];
    
    pars.layer2_input              = [];
    pars.layer2_output             = [];
    pars.layer2_validation_input   = [];
    pars.layer2_validation_output  = [];
    
    pars.layer2_using_existed_data      = false;
    pars.layer2_from_existed_data       = false;
    pars.layer2_existed_data            = [];
    pars.layer2_weightPenaltyL2         = 0.001;
	pars.layer2_deltaMax 				= 0.04;
    pars.layer2_display                 = false;
    pars.layer2_validation              = true;
    %layer2_save file should contain:
    %   layer2_pars:    pars for transformations of transformations
    
    pars.layer1_13_pars     = [];
    pars.layer1_12_pars     = [];
end
