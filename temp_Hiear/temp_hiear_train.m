%% Train the model of two layers
function pars=temp_hiear_train(pars)

if pars.layer1_from_existed_data || pars.layer1_using_existed_data
    load(pars.layer1_existed_data);
end

if ~pars.layer1_using_existed_data

    wxf_13      = []; wxf_12    = [];
    wyf_13      = []; wyf_12    = [];
    whf_13      = []; whf_12    = [];
    wy_13       = []; wy_12     = [];
    wh_13       = []; wh_12     = [];
    
    if pars.layer1_from_existed_data
        wxf_13  = layer1_13_pars.wxf; wxf_12    = layer1_12_pars.wxf;
        wyf_13  = layer1_13_pars.wyf; wyf_12    = layer1_12_pars.wyf;
        whf_13  = layer1_13_pars.whf; whf_12    = layer1_12_pars.whf;
        wy_13   = layer1_13_pars.wy;  wy_12     = layer1_12_pars.wy;
        wh_13   = layer1_13_pars.wh;  wh_12     = layer1_12_pars.wh;
    end

    if strcmp(pars.gbm_who,'ym')==1 %using yimeng's GBM
        layer1_13_pars     = factor_GBM_train(pars.train_data_f1, ...
                                    pars.train_data_f3, ...
                                    'numfactors', pars.layer1_numfactors, ...
                                    'batchsize', pars.layer1_batchsize, ...
                                    'batchOrderFixed', pars.layer1_batchOrderFixed,...
                                    'nummap', pars.layer1_nummap, ...
                                    'numepoch', pars.layer1_numepoch, ...
                                    'wxf', wxf_13, 'wyf', wyf_13, 'whf', whf_13, ...
                                    'wy', wy_13, 'wh', wh_13, ...
                                    'display', pars.layer1_13_display, ...
                                    'display_figure', pars.layer1_13_figure, ...
                                    'weightPenaltyL2', pars.layer1_weightPenaltyL2,...
                                    'saveFile',false, 'seed', 0);

        layer1_12_pars     = factor_GBM_train(pars.train_data_f1, ...
                                    pars.train_data_f2, ...
                                    'numfactors', pars.layer1_numfactors, ...
                                    'batchsize', pars.layer1_batchsize, ...
                                    'batchOrderFixed', pars.layer1_batchOrderFixed,...
                                    'nummap', pars.layer1_nummap, ...
                                    'numepoch', pars.layer1_numepoch, ...
                                    'wxf', wxf_12, 'wyf', wyf_12, 'whf', whf_12, ...
                                    'wy', wy_12, 'wh', wh_12, ... 
                                    'display', pars.layer1_12_display, ...
                                    'display_figure', pars.layer1_12_figure, ...      
                                    'weightPenaltyL2', pars.layer1_weightPenaltyL2,...                         
                                    'saveFile',false, 'seed', 0);                        
    elseif strcmp(pars.gbm_who,'mm')==1 %using mingmin's GBM, they are almost the same
        layer1_13_pars     = f3gbm_setup(pars.f1_size^2, ... %n_x
                                    pars.f23_size^2, ... %n_y
                                    pars.layer1_nummap, ... %n_h
                                    pars.layer1_numfactors, ... %n_f
                                    'batchsize', pars.layer1_batchsize, ...
                                    'batchOrderFixed', pars.layer1_batchOrderFixed,...
                                    'n_epoch', pars.layer1_numepoch, ...
                                    'wxf', wxf_13, 'wyf', wyf_13, 'whf', whf_13, ...
                                    'wy', wy_13, 'wh', wh_13, ...
                                    'display', pars.layer1_13_display, ...
                                    'display_figure', pars.layer1_13_figure, ...
                                    'validate', pars.layer1_13_validation, ...
                                    'validation_set_x', pars.valid_data_f1, ...
                                    'validation_set_y', pars.valid_data_f3, ...
                                    'validation_figure', pars.layer1_13_validation_figure, ...
                                    'weightPenaltyL2', pars.layer1_weightPenaltyL2,...
									'deltaMax', pars.layer1_deltaMax, ...
                                    'saveFile',false, 'seed', 0);
        layer1_13_pars     = f3gbm_train(layer1_13_pars,...
                                    pars.train_data_f1,...
                                    pars.train_data_f3);
        
        layer1_12_pars     = f3gbm_setup(pars.f1_size^2, ... %n_x
                                    pars.f23_size^2, ... %n_y
                                    pars.layer1_nummap, ... %n_h
                                    pars.layer1_numfactors, ... %n_f
                                    'batchsize', pars.layer1_batchsize, ...
                                    'batchOrderFixed', pars.layer1_batchOrderFixed,...
                                    'n_epoch', pars.layer1_numepoch, ...
                                    'wxf', wxf_12, 'wyf', wyf_12, 'whf', whf_12, ...
                                    'wy', wy_12, 'wh', wh_12, ... 
                                    'display', pars.layer1_12_display, ...
                                    'display_figure', pars.layer1_12_figure, ...
                                    'validate', pars.layer1_12_validation, ...
                                    'validation_set_x', pars.valid_data_f1, ...
                                    'validation_set_y', pars.valid_data_f2, ...
                                    'validation_figure', pars.layer1_12_validation_figure, ...
                                    'weightPenaltyL2', pars.layer1_weightPenaltyL2,...
									'deltaMax', pars.layer1_deltaMax, ...
                                    'saveFile',false, 'seed', 0);
        layer1_12_pars     = f3gbm_train(layer1_12_pars,...
                                    pars.train_data_f1,...
                                    pars.train_data_f2);                                
                                
        fprintf('layer1_13 validation error: %f, layer1_12: %f\n', layer1_13_pars.validation_mean_sqerror(end), layer1_12_pars.validation_mean_sqerror(end));
    end
    
    save(pars.layer1_save, 'layer1_13_pars', 'layer1_12_pars'); 
end

pars.layer1_13_pars     = layer1_13_pars;
pars.layer1_12_pars     = layer1_12_pars;

if pars.layer2_from_existed_data || pars.layer2_using_existed_data
    load(pars.layer2_existed_data);
end

if ~pars.layer2_using_existed_data
    wxf         = [];
    wyf         = [];
    whf         = [];
    wy          = [];
    wh          = [];
    
    
    if pars.layer2_from_existed_data
        wxf     = layer2_pars.wxf;
        wyf     = layer2_pars.wyf;
        whf     = layer2_pars.whf;
        wy      = layer2_pars.wy;
        wh      = layer2_pars.wh;
    end
    
   
    if strcmp(pars.gbm_who,'mm')==1    
        pars.layer2_input           = f3gbm_gethidden(pars.layer1_13_pars,...
                                    pars.train_data_f1,...
                                    pars.train_data_f3);
        pars.layer2_output          = f3gbm_gethidden(pars.layer1_12_pars,...
                                    pars.train_data_f1,...
                                    pars.train_data_f2);
                                
        pars.layer2_validation_input   = f3gbm_gethidden(pars.layer1_13_pars,...
                                    pars.valid_data_f1,...
                                    pars.valid_data_f3);
        pars.layer2_validation_output  = f3gbm_gethidden(pars.layer1_12_pars,...
                                    pars.valid_data_f1,...
                                    pars.valid_data_f2);
                                
        if pars.layer2_display
            pars.layer2_figure   = figure;
        end                               
        
        if pars.layer2_validation && pars.layer2_display
            pars.layer2_validation_figure    = figure;
        end
        
        layer2_pars     = f3gbm_setup(size(pars.layer2_input, 2), ... %n_x
                                    size(pars.layer2_output, 2), ... %n_y
                                    pars.layer2_nummap, ... %n_h
                                    pars.layer2_numfactors, ... %n_f
                                    'batchsize', pars.layer2_batchsize, ...
                                    'batchOrderFixed', pars.layer2_batchOrderFixed,...
                                    'n_epoch', pars.layer2_numepoch, ...
                                    'wxf', wxf, 'wyf', wyf, 'whf', whf, ...
                                    'wy', wy, 'wh', wh, ... 
                                    'display', pars.layer2_display, ...
                                    'display_figure', pars.layer2_figure, ...
                                    'validate', pars.layer2_validation, ...
                                    'validation_set_x', pars.layer2_validation_input, ...
                                    'validation_set_y', pars.layer2_validation_output, ...
                                    'validation_figure', pars.layer2_validation_figure, ...
                                    'weightPenaltyL2', pars.layer2_weightPenaltyL2,...
									'deltaMax', pars.layer2_deltaMax, ...
                                    'visType', 'gaussian', ...
                                    'saveFile',false, 'seed', 0);
        layer2_pars     = f3gbm_train(layer2_pars,...
                                    pars.layer2_input,...
                                    pars.layer2_output);
    else
        fprintf('I have not written it yet!\n');
        return;
    end
    
    save(pars.layer2_save, 'layer2_pars'); 
end

pars.layer2_pars        = layer2_pars;