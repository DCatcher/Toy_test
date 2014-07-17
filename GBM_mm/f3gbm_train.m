function gbm = f3gbm_train(gbm, train_x, train_y)
% F3GBMTRAIN
%
%
%
%

assert(size(train_x,1)==size(train_y,1));
assert(size(train_x,2)==gbm.n_x);
assert(size(train_y,2)==gbm.n_y);

n_batch = floor(size(train_x,1)/gbm.batchsize);
% delta for momentum
delta = zeros((gbm.n_x+gbm.n_y+gbm.n_h)*gbm.n_f+gbm.n_y+gbm.n_h,1);
d_pos = [0, gbm.n_x*gbm.n_f, (gbm.n_x+gbm.n_y)*gbm.n_f, (gbm.n_x+gbm.n_y+gbm.n_h)*gbm.n_f, ...
    (gbm.n_x+gbm.n_y+gbm.n_h)*gbm.n_f+gbm.n_y, (gbm.n_x+gbm.n_y+gbm.n_h)*gbm.n_f+gbm.n_y+gbm.n_h];

% training
for epoch = 1:gbm.n_epoch
    gbm.sqerror_now = [];
    if ~gbm.batchOrderFixed
        order = randperm(size(train_x,1));
    else
        order = 1:size(train_x,1);
    end
    
    for batch = 1:n_batch
        batch_x = train_x(order((batch-1)*gbm.batchsize+1:batch*gbm.batchsize),:);
        batch_y = train_y(order((batch-1)*gbm.batchsize+1:batch*gbm.batchsize),:);
        f3gbm_train_inner();
    end
    
    if rem(epoch, gbm.everySave) == 0 || epoch == gbm.n_epoch
        if gbm.saveFile
            fileName = [gbm.datestring '_' int2str(epoch) '.mat'];
            save(fileName,'gbm','epoch');
        end
    end
    
    %for display and reconstruction
    if (gbm.validate) && (mod(epoch, gbm.validation_interval)==0)
        recon_error     = f3gbm_reconstruction(gbm.validation_set_x, gbm.validation_set_y);
        fprintf('#epoch %d# validation error: %f\n', epoch, recon_error);
        
        gbm.validation_mean_sqerror(end+1)  = recon_error;
        
        if gbm.display
            set(0, 'CurrentFigure', gbm.validation_figure);
            plot(gbm.validation_mean_sqerror);
            pause(0.05);
        end
    end
    gbm.mean_sqerror(end+1) = mean(gbm.sqerror_now);
    
    if gbm.display
        set(0, 'CurrentFigure', gbm.display_figure);
        plot(gbm.mean_sqerror);
        pause(0.05);
    end
end

    function f3gbm_train_inner()
        delta = gbm.momentum*delta - gbm.stepsize*f3gbm_grad();
        
        % zero mask used here
        delta(gbm.zeromask) = 0;
        
        % stablize the things
        dwxf        = delta(d_pos(1)+1:d_pos(2));
        max_ndwxf   = gbm.deltaMax*norm(gbm.wxf);
        if norm(dwxf) > max_ndwxf
            dwxf    = dwxf/norm(dwxf) * (max_ndwxf);
        end
        
        dwyf        = delta(d_pos(2)+1:d_pos(3));
        max_ndwyf   = gbm.deltaMax*norm(gbm.wyf);
        if norm(dwyf) > max_ndwyf
            dwyf    = dwyf/norm(dwyf) * (max_ndwyf);
        end
        
        dwhf        = delta(d_pos(3)+1:d_pos(4));
        max_ndwhf   = gbm.deltaMax*norm(gbm.whf);
        if norm(dwhf) > max_ndwxf
            dwhf    = dwhf/norm(dwhf) * (max_ndwhf);
        end
        
        dwy         = delta(d_pos(4)+1:d_pos(5));
        max_ndwy    = gbm.deltaMax*norm(gbm.wy);
        if norm(dwy) > max_ndwy
            dwy    = dwy/norm(dwy) * (max_ndwy);
        end
        
        dwh         = delta(d_pos(5)+1:d_pos(6));
        max_ndwh    = gbm.deltaMax*norm(gbm.wh);
        if norm(dwh) > max_ndwh
            dwh    = dwh/norm(dwh) * (max_ndwh);
        end         
%         if norm(delta) > gbm.deltaMax
%             delta = delta/ninc * gbm.deltaMax;
%         end
        
        assert(all(~isnan(delta)));
        
        %add separately
        gbm.wxf(:) = gbm.wxf(:) + dwxf;
        gbm.wyf(:) = gbm.wyf(:) + dwyf;
        gbm.whf(:) = gbm.whf(:) + dwhf;
        gbm.wy(:)  = gbm.wy(:)  + dwy;
        gbm.wh(:)  = gbm.wh(:)  + dwh;
        
    end

    function recon_error = f3gbm_reconstruction(input_x, input_y)
        X       = input_x;
        Y       = input_y;
        
        back_bs         = gbm.batchsize;
        gbm.batchsize   = size(X, 1);
        H = sigm((X*gbm.wxf).*(Y*gbm.wyf)*(gbm.whf') + ones(gbm.batchsize,1)*gbm.wh');
        
        for iCD = 1:gbm.cditerations
            H = double(H > rand(size(H)));
            if ~gbm.meanfield_output
                if isequal(gbm.visType, 'binary')
                    Y = double(sigm((X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy') > rand(size(Y)));
                else
                    assert(isequal(gbm.visType, 'gaussian'));
                    Y = (X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy' + randn(size(Y));
                end
            else
                if isequal(gbm.visType, 'binary')
                    Y = sigm((X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy');
                else
                    assert(isequal(gbm.visType, 'gaussian'));
                    Y = (X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy';
                end
            end
            H = sigm((X*gbm.wxf).*(Y*gbm.wyf)*(gbm.whf') + ones(gbm.batchsize,1)*gbm.wh');
        end  
        
        recon_error     = sum((Y(:)-input_y(:)).^2)/gbm.batchsize;
        gbm.batchsize   = back_bs;
    end

    function grad = f3gbm_grad()
        X = batch_x;
        Y = batch_y;
        H = sigm((X*gbm.wxf).*(Y*gbm.wyf)*(gbm.whf') + ones(gbm.batchsize,1)*gbm.wh');
        
        g_wxf = -X'*((Y*gbm.wyf).*(H*gbm.whf))/gbm.batchsize;
        g_wyf = -Y'*((X*gbm.wxf).*(H*gbm.whf))/gbm.batchsize;
        g_whf = -H'*((X*gbm.wxf).*(Y*gbm.wyf))/gbm.batchsize;
        g_wy  = -mean(Y,1)';
        g_wh  = -mean(H,1)';
        
        for iCD = 1:gbm.cditerations
            H = double(H > rand(size(H)));
            if ~gbm.meanfield_output
                if isequal(gbm.visType, 'binary')
                    Y = double(sigm((X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy') > rand(size(Y)));
                else
                    assert(isequal(gbm.visType, 'gaussian'));
                    Y = (X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy' + randn(size(Y));
                end
            else
                if isequal(gbm.visType, 'binary')
                    Y = sigm((X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy');
                else
                    assert(isequal(gbm.visType, 'gaussian'));
                    Y = (X*gbm.wxf).*(H*gbm.whf)*(gbm.wyf') + ones(gbm.batchsize,1)*gbm.wy';
                end
            end
            H = sigm((X*gbm.wxf).*(Y*gbm.wyf)*(gbm.whf') + ones(gbm.batchsize,1)*gbm.wh');
        end
        
        
        weightcostgrad_x = gbm.weightPenaltyL2 * gbm.wxf(:);
        weightcostgrad_y = gbm.weightPenaltyL2 * gbm.wyf(:);
        weightcostgrad_h = gbm.weightPenaltyL2 * gbm.whf(:);
        
        g_wxf = g_wxf + X'*((Y*gbm.wyf).*(H*gbm.whf))/gbm.batchsize + reshape(weightcostgrad_x, size(g_wxf));
        g_wyf = g_wyf + Y'*((X*gbm.wxf).*(H*gbm.whf))/gbm.batchsize + reshape(weightcostgrad_y, size(g_wyf));
        g_whf = g_whf + H'*((X*gbm.wxf).*(Y*gbm.wyf))/gbm.batchsize + reshape(weightcostgrad_h, size(g_whf));
        g_wy  = g_wy  + mean(Y,1)';
        g_wh  = g_wh  + mean(H,1)';
        
        if gbm.verbose % print reconstruction error and the norm of weights
            gbm.sqerror_now(end+1) = sum((Y(:)-batch_y(:)).^2)/gbm.batchsize;
            fprintf('#epoch %d# sum square error: %f , norm of w: %f\n', epoch, gbm.sqerror_now(end),...
                norm([gbm.wxf(:); gbm.wyf(:); gbm.whf(:); gbm.wh(:); gbm.wy(:)]));
        end
        
        grad = [g_wxf(:);g_wyf(:);g_whf(:);g_wy(:);g_wh(:)];
    end

end

