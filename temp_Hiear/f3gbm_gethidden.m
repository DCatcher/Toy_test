%% Get hidden units values
function hidden = f3gbm_gethidden(gbm, input_x, input_y)
X       = input_x;
Y       = input_y;

back_bs         = gbm.batchsize;
gbm.batchsize   = size(X, 1);
hidden = sigm((X*gbm.wxf).*(Y*gbm.wyf)*(gbm.whf') + ones(gbm.batchsize,1)*gbm.wh');
gbm.batchsize   = back_bs;