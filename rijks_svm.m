function R = rijks_svm(expOpts,data)
    % Train SVM classifiers for the Rijksmuseum challenge
    %
    % This file depends on the Liblinear TRAIN function
    %
    % copyright, 2014
    % Thomas Mensink, University of Amsterdam
    % thomas.mensink@uva.nl
    %
    v = 1.0;
    fprintf('%30s | %7.4f | %s\n',mfilename,v,datestr(now,31));
    
    % Define name for this experiment
    [~,dfName,~]    = fileparts(expOpts.data.file);    %File of data file
    eName           = sprintf('%s/%s_t%03d_%s%02d',dfName,expOpts.name,expOpts.data.minTstOcc,expOpts.svm.method,expOpts.svm.algo);
    
    fprintf('Experiment %s\n',eName);
    
    %% Train models (or load them)
    C               = expOpts.svm.C;
    R               = cell(1,numel(C));
    for c=1:numel(C),
        cname   = sprintf('%s_C%5.0e',eName,C(c));
        cfile   = sprintf('%s/%s.mat',expOpts.rdir,cname);
        cdir    = fileparts(cfile);
        if exist(cdir,'dir') ~= 7, mkdir(cdir); end
        
        fprintf('\t%4d | C %5.0e | %s\n',c,C(c),cfile);
        if exist(cfile,'file') ~= 2 && expOpts.svm.run == 1,
            fprintf('\t\t--> TRAIN |');
            
            %% Load the datafile files
            %if exist('data','var') ~= 1,data = rijks_load(expOpts);  end
            
            % Ensure that sparse data exist for liblinear
            if ~isfield(data,'XStrain') || isempty(data.XStrain),
                data.XStrain = sparse(double(data.Xtrain'));
            end
            t1              = tic;
            
            if strcmp(expOpts.svm.method,'1vR'),
                %% 1 vs Rest SVM using liblinear
                NrClass         = data.NrClass;
                det             = zeros(1,NrClass);
                W               = zeros(size(data.Xtrain,1)+1,NrClass);
                fprintf(' NrClass %5d | 1vR | liblinear | class %5d',NrClass,0);
                for li=1:NrClass
                    fprintf('\b\b\b\b\b%5d',li);
                    l           = li;
                    
                    if size(data.Ltrain,2) == 1,
                        Ltrain  = 2 * (data.Ltrain == l) - 1;
                        Lval    = 2 * (data.Lval   == l) - 1;
                    else
                        Ltrain  = 2 * (data.Ltrain(:,l) >= 1) - 1;
                        Lval    = 2 * (data.Lval(:,l)   >= 1) - 1;
                    end
                    
                    ml          = train(Ltrain,data.XStrain, sprintf('-s %d -c %f -B 1 -q',expOpts.svm.algo,C(c)));
                    if ml.Label(1) == -1, ml.w = -ml.w; end
                    
                    Sval        = rijks_svm_eval(ml.w',data.Xval);
                    det(li)     = mean(sign(Sval) == Lval');
                    W(:,li)     = ml.w';
                end
                fprintf(' | DONE! | %7.2fsec \n',toc(t1));
                top             = [mean(det) det];
                fprintf('\t\t Mean Acc %7.2f | Class acc ',top(1)*100);fprintf('%7.2f ',top(2:6)*100);fprintf('\n');
            elseif strcmp(expOpts.svm.method,'reg'),
                %% SVM Regression
                fprintf('| Reg | liblinear | ');
                model           = train(data.Ltrain,data.XStrain, sprintf('-s %d -c %f -B 1 -q',expOpts.svm.algo,C(c)));
                fprintf(' DONE! | %7.2fsec \n',toc(t1));
                Yp              = rijks_svm_eval(model.w',data.Xval);
                Ygt             = data.Lval';
                sqloss          = sqrt(mean( (Yp - Ygt).^2 ));
                absloss         = mean( abs(Yp - Ygt) );
                iloss           = mean( abs(Yp - Ygt) <= 50 );
                top             = [sqloss absloss iloss];
                det             = top;
                W               = model.w';
                fprintf('\t\t Sq %7.2f Abs %7.2f Int %7.2f\n',top);
            elseif strcmp(expOpts.svm.method,'rpt'),
                NrClass         = data.NrClass;
                det             = zeros(3,NrClass);
                W               = zeros(size(data.Xtrain,1)+1,NrClass);
                fprintf('| NrType %5d | Reg per Type | liblinear | class %5d',NrClass,0);
                for li=1:NrClass
                    fprintf('\b\b\b\b\b%5d',li);
                    l           = li;
                    
                    if size(data.Ltrain,2) == 1,
                        Ltrain  = 2 * (data.Ltrain == l) - 1;
                        Lval    = 2 * (data.Lval   == l) - 1;
                    else
                        Ltrain  = 2 * (data.Ltrain(:,l) >= 1) - 1;
                        Lval    = 2 * (data.Lval(:,l)   >= 1) - 1;
                    end
                    
                    tInx        = Ltrain == 1;
                    vInx        = Lval == 1;
                    
                    ml          = train(data.Ytrain(tInx),data.XStrain(tInx,:), sprintf('-s %d -c %f -B 1 -q',expOpts.svm.algo,C(c)));
                    
                    Yp          = rijks_svm_eval(ml.w',data.Xval(:,vInx));
                    Ygt         = data.Lval(vInx)';
                    sqloss      = sqrt(mean( (Yp - Ygt).^2 ));
                    absloss     = mean( abs(Yp - Ygt) );
                    iloss       = mean( abs(Yp - Ygt) <= 50 );
                    det(:,li)   = [sqloss absloss iloss];
                    W(:,li)     = ml.w';
                end
                fprintf(' DONE! | %7.2fsec \n',toc(t1));
                top             = mean(det,2);
                fprintf('\t\t Mean Sq %7.2f Abs %7.2f Int %7.2f\n',top);
            end
            res.top         = top;
            res.det         = det;
            res.W           = W;
            save(cfile,'res')                        
        elseif exist(cfile,'file') == 2,
            load(cfile);
        else
            res = [];
        end
        R{c} = res;
    end
end
