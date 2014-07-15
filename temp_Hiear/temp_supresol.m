function temp_supresol(method)

close all
rand('state', 0);
randn('state', 0);

pars    = pars_initial(method);

if strcmp(method, 'hiear')==1
%% for hiear method
    diary(pars.log_save);
    diary on;
    
    pars    = data_prepare(pars);
    pars    = temp_hiear_train(pars);
    pars    = temp_hiear_predict(pars);
    pars    = temp_hiear_validate(pars);
    
    save(pars.save, 'pars');
    
    diary off;
else
    fprintf('Wrong Argument\n');
end