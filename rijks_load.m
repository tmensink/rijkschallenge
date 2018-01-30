function data = rijks_load(expOpts)
    % Load the data for a specific challenge (defined in expOpts)
    %
    % Part of RMC14 - initial release
    % copyright, 2014-2018
    % Thomas Mensink, University of Amsterdam
    % thomas.mensink@uva.nl
    
    v = 1.01;
    fprintf('%30s | %7.4f | %s\n',mfilename,v,datestr(now,31));
    
    %History
    % v 1.1: Either load data from mat file (Figshare) or from FVKit directory
    Fgt         = load(expOpts.data.gtfile);    
    if exist(expOpts.data.file,'dir') == 7,
        T = {'TRAIN','VAL','TEST'};
        for t =1:numel(T),
            q = load([expOpts.data.file '/feat_' T{t} '.mat']);            
            if t==1,    
                Fdata.X = zeros(size(q.X,1),numel(Fgt.gt.set),'single');
            end                                                            
            Fdata.X(:,Fgt.gt.set==t) = q.X;
        end
    else
        Fdata       = load(expOpts.data.file);
    end
    
    
    if strcmp(expOpts.data.gtfield,'C'),
        Fclass      = Fgt.gt.C;
        
        %Create Train and Val set
        cCnt        = [histc(Fclass(Fgt.gt.set == 1),1:max(Fclass)) ...
            histc(Fclass(Fgt.gt.set == 2),1:max(Fclass)) ...
            histc(Fclass(Fgt.gt.set == 3),1:max(Fclass))];
        
        cInx        = find( (all(cCnt > 0,2) & cCnt(:,3) >= expOpts.data.minTstOcc) );
        
        cInx(cInx == find(strcmp(Fgt.gt.Cnames,'anoniem'))) = [];
        cInx(cInx == find(strcmp(Fgt.gt.Cnames,'unknown'))) = [];
        
        [Fmsk,Fclc] =ismember(Fclass,cInx);
        Fclass(:,2) = Fclc;
        Fclass(~Fmsk,2) = numel(cInx)+1;
        
        data.Xtrain = Fdata.X(:,Fgt.gt.set==1);
        data.Xval   = Fdata.X(:,Fgt.gt.set==2);
        data.Xtest  = Fdata.X(:,Fgt.gt.set==3);
        
        
        data.Ltrain = Fclass(Fgt.gt.set==1,2);
        data.Lval   = Fclass(Fgt.gt.set==2,2);
        data.Ltest  = Fclass(Fgt.gt.set==3,2);
        data.NrClass= numel(unique(Fclass(:,2)));
        
        data.Class  = Fclass;
        data.Clabel = Fgt.gt.Cnames(cInx);
        data.Clabel{end+1} = 'rest';
        
    elseif strcmp(expOpts.data.gtfield,'T'),
        Ftype       = Fgt.gt.T;
        data.Ltrain = Ftype(Fgt.gt.set==1,:);
        data.Lval   = Ftype(Fgt.gt.set==2,:);
        data.Ltest  = Ftype(Fgt.gt.set==3,:);
        
        dS          = [sum(data.Ltrain>0,1);sum(data.Lval>0,1);sum(data.Ltest>0,1)];
        
        tInx        = ( all(dS > 0,1) &  (dS(3,:) >= expOpts.data.minTstOcc) );
        
        data.NrClass= sum(tInx);
        data.Ltrain = data.Ltrain(:,tInx);
        data.Lval   = data.Lval(:,tInx);
        data.Ltest  = data.Ltest(:,tInx);
        data.Tlabel = Fgt.gt.Tnames(tInx);
        
        data.Xtrain = Fdata.X(:,Fgt.gt.set==1);
        data.Xval   = Fdata.X(:,Fgt.gt.set==2);
        data.Xtest  = Fdata.X(:,Fgt.gt.set==3);
        
    elseif strcmp(expOpts.data.gtfield,'M'),
        Ftype       = Fgt.gt.M;
        data.Ltrain = Ftype(Fgt.gt.set==1,:);
        data.Lval   = Ftype(Fgt.gt.set==2,:);
        data.Ltest  = Ftype(Fgt.gt.set==3,:);
        
        dS          = [sum(data.Ltrain>0,1);sum(data.Lval>0,1);sum(data.Ltest>0,1)];
        
        mInx        = ( all(dS > 0,1) &  (dS(3,:) >= expOpts.data.minTstOcc) );
        
        data.NrClass= sum(mInx);
        data.Ltrain = data.Ltrain(:,mInx);
        data.Lval   = data.Lval(:,mInx);
        data.Ltest  = data.Ltest(:,mInx);
        data.Mlabel = Fgt.gt.Mnames(mInx);
        
        data.Xtrain = Fdata.X(:,Fgt.gt.set==1);
        data.Xval   = Fdata.X(:,Fgt.gt.set==2);
        data.Xtest  = Fdata.X(:,Fgt.gt.set==3);
    elseif strcmp(expOpts.data.gtfield,'Y'),
        d    = abs(Fgt.gt.Y(:,1) - Fgt.gt.Y(:,2));
        Fmsk = d<100;
        
        Fclass = mean(Fgt.gt.Y,2);
        data.Xtrain = Fdata.X(:,Fmsk & Fgt.gt.set==1);
        data.Xval   = Fdata.X(:,Fmsk & Fgt.gt.set==2);
        data.Xtest  = Fdata.X(:,Fmsk & Fgt.gt.set==3);
        
        data.Ltrain = Fclass(Fmsk & Fgt.gt.set==1);
        data.Lval   = Fclass(Fmsk & Fgt.gt.set==2);
        data.Ltest  = Fclass(Fmsk & Fgt.gt.set==3);
    elseif strcmp(expOpts.data.gtfield,'YT'),
        d    = abs(Fgt.gt.Y(:,1) - Fgt.gt.Y(:,2));
        Fmsk = d<100;
        
        Fclass = mean(Fgt.gt.Y,2);
        data.Xtrain = Fdata.X(:,Fmsk & Fgt.gt.set==1);
        data.Xval   = Fdata.X(:,Fmsk & Fgt.gt.set==2);
        data.Xtest  = Fdata.X(:,Fmsk & Fgt.gt.set==3);
        
        
        Ftype       = Fgt.gt.T;
        data.Ltrain = Ftype(Fmsk & Fgt.gt.set==1,:);
        data.Lval   = Ftype(Fmsk & Fgt.gt.set==2,:);
        data.Ltest  = Ftype(Fmsk & Fgt.gt.set==3,:);
        
        dS          = [sum(data.Ltrain>0,1);sum(data.Lval>0,1);sum(data.Ltest>0,1)];
        tInx        = ( all(dS > 0,1) &  (dS(3,:) >= expOpts.data.minTstOcc) );
        
        data.NrClass= sum(tInx);
        data.Ltrain = data.Ltrain(:,tInx);
        data.Lval   = data.Lval(:,tInx);
        data.Ltest  = data.Ltest(:,tInx);
        
        data.Tlabel = Fgt.gt.Tnames(tInx);
        
        data.Ytrain = Fclass(Fmsk & Fgt.gt.set==1);
        data.Yval   = Fclass(Fmsk & Fgt.gt.set==2);
        data.Ytest  = Fclass(Fmsk & Fgt.gt.set==3);
    else
        error('Not yet implemented');
    end
end
