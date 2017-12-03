function res = rijks_eval(expOpts,data,R)
    % Evaluate SVM classifiers for the Rijksmuseum challenge
    %
    % Input
    %   expOpts   struct  detailing the experiment
    %   data      struct  containing the val/test/train
    %   R         cell    containing the SVM models
    %
    % Ouput
    %   ret  vector  returns just validation performance
    %
    % Part of RMC14 - initial release
    % copyright, 2014-2017
    % Thomas Mensink, University of Amsterdam
    % thomas.mensink@uva.nl
    v = 1.0;
    fprintf('%30s | %7.4f | %s\n',mfilename,v,datestr(now,31));
    
    
    %% Evaluate models
    C               = expOpts.svm.C;
    P               = inf(size(C));
    fprintf('Cross Validate using %s\n',expOpts.eval.func);
    for c=1:numel(C),
        if isempty(R{c}), fprintf('Results are not complete!!\n');continue, end
        
        % SVM Prediction on validation set
        Pval        =   rijks_svm_eval(R{c}.W,data.Xval);
        if strcmp(expOpts.eval.func,'top'),
            P(c)   = eval_top(data.Lval,Pval',1);
        elseif strcmp(expOpts.eval.func,'mca'),
            P(c)   = eval_mca(data.Lval,Pval',1);
        elseif strcmp(expOpts.eval.func,'map'),
            P(c)   = eval_map(data.Lval>=0,Pval');
        elseif strcmp(expOpts.eval.func,'sqloss'),
            P(c)   =-sqrt( mean(  (Pval - data.Lval').^2 ) );
        end
        
        fprintf('\tC %5.0e P %8.3f (%s)\n',C(c),P(c),expOpts.eval.func);
    end
    
    %% Predict on best model
    [~,i] = max(P);
    Cbest = C(i);
    Cinx  = i;
    fprintf('Evaluate using C %5.0e |\n',Cbest);
    res   = P;
    
    W       = R{Cinx}.W;
    Ptrain  = rijks_svm_eval(W,data.Xtrain)';
    Pval    = rijks_svm_eval(W,data.Xval)';
    Ptest   = rijks_svm_eval(W,data.Xtest)';
    
    if strcmp(expOpts.name,'creator'),
        %% Evaluate for creator challenge
        fprintf('%s\n',expOpts.name);
        
        Ttrain  = eval_mca(data.Ltrain,Ptrain,5);
        Tval    = eval_mca(data.Lval  ,Pval  ,5);
        Ttest   = eval_mca(data.Ltest ,Ptest ,5);
        
        fprintf('\t %3d | %s | ii %4d ( all )| MCA: ',0,'TRN',data.NrClass);fprintf('%7.2f ',Ttrain*100);fprintf('\n');
        fprintf('\t %3d | %s | ii %4d ( all )| MCA: ',0,'VAL',data.NrClass);fprintf('%7.2f ',Tval*100);fprintf('\n');
        fprintf('\t %3d | %s | ii %4d ( all )| MCA: ',0,'TST',data.NrClass);fprintf('%7.2f ',Ttest*100);fprintf('\n');
        
        CCount = hist(data.Ltest,1:data.NrClass);
        [~, sinx] = sort(CCount(1:374),'descend');
        ii  = [374, 300 250 200 150 100 50 25];
        for i=1:numel(ii),
            iinx        = sinx(1:ii(i));
            [imsk,ilab] = ismember(data.Ltest,iinx);
            Tinx        = eval_mca(ilab(imsk),Ptest(imsk,iinx),5);
            fprintf('\t %3d | %s | ii %4d (%5.1f)| MCA: ',i,'TST',ii(i),mean(imsk)*100);fprintf('%7.2f ',Tinx*100);fprintf('\n');
        end
        
    elseif strcmp(expOpts.name,'type') || strcmp(expOpts.name,'material'),
        %% Evaluate for type and material challenges
        fprintf('%s\n',expOpts.name);
        
        % Train
        Gt              = data.Ltrain >= 1;
        map             = eval_map(Gt, Ptrain);
        imap            = eval_map(Gt',Ptrain');
        fprintf('\t %3d | %s | ii %4d ( all )| mAP: %7.2f imAP %7.2f\n',0,'TRN',data.NrClass,[map imap]*100);
        
        % Val
        Gt              = data.Lval >= 1;
        map             = eval_map(Gt, Pval);
        imap            = eval_map(Gt',Pval');
        fprintf('\t %3d | %s | ii %4d ( all )| mAP: %7.2f imAP %7.2f\n',0,'VAL',data.NrClass,[map imap]*100);
        
        % Test
        Gt              = data.Ltest >= 1;
        map             = eval_map(Gt, Ptest);
        imap            = eval_map(Gt',Ptest');
        fprintf('\t %3d | %s | ii %4d ( all )| mAP: %7.2f imAP %7.2f\n',0,'TST',data.NrClass,[map imap]*100);
        
        S               = sum(Gt);
        [~,sinx]        = sort(S,'descend');
        ii              = [75 50 25];
        for i =1:numel(ii),
            iinx        = sinx(1:ii(i));
            imsk        = any(Gt(:,iinx),2); 
            map         = eval_map(Gt(imsk,iinx), Ptest(imsk,iinx));
            imap        = eval_map(Gt(imsk,iinx)',Ptest(imsk,iinx)');
            fprintf('\t %3d | %s | ii %4d (%5.1f)| mAP: %7.2f imAP %7.2f\n',i,'TST',ii(i),mean(sum(Gt(:,iinx),2)>0)*100,[map imap]*100);
        end
    elseif strcmp(expOpts.name,'year'),
        %% Evaluate for year prediction challenge
        fprintf('%s\n',expOpts.name);
        
        % Train
        Yp      = Ptrain;
        Ygt     = data.Ltrain;
        sqloss  = sqrt(mean( (Yp - Ygt).^2 ));
        absloss = mean( abs(Yp - Ygt) );
        iloss   = mean( abs(Yp - Ygt) <= 50 );
        fprintf('\t %3d | %s | ii %4d ( all )| sqLoss %7.2f absLoss %7.2f iCor (50 yrs) %7.2f\n',0,'TRN',1,sqloss,absloss,iloss*100);
        
        % Val
        Yp      = Pval;
        Ygt     = data.Lval;
        sqloss  = sqrt(mean( (Yp - Ygt).^2 ));
        absloss = mean( abs(Yp - Ygt) );
        iloss   = mean( abs(Yp - Ygt) <= 50 );
        fprintf('\t %3d | %s | ii %4d ( all )| sqLoss %7.2f absLoss %7.2f iCor (50 yrs) %7.2f\n',0,'VAL',1,sqloss,absloss,iloss*100);
        
        % Test
        Yp      = Ptest;
        Ygt     = data.Ltest;
        sqloss  = sqrt(mean( (Yp - Ygt).^2 ));
        absloss = mean( abs(Yp - Ygt) );
        iloss   = mean( abs(Yp - Ygt) <= 50 );
        fprintf('\t %3d | %s | ii %4d ( all )| sqLoss %7.2f absLoss %7.2f iCor (50 yrs) %7.2f\n',0,'TST',1,sqloss,absloss,iloss*100);
        
        Yp      = mean(data.Ltrain);
        Ygt     = data.Ltest;
        sqloss  = sqrt(mean( (Yp - Ygt).^2 ));
        absloss = mean( abs(Yp - Ygt) );
        iloss   = mean( abs(Yp - Ygt) <= 50 );
        fprintf('\t %3d | %s | ii %4d (mean )| sqLoss %7.2f absLoss %7.2f iCor (50 yrs) %7.2f\n',0,'TST',1,sqloss,absloss,iloss*100);
    end
end
