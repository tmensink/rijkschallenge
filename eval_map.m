function [iap, ap, det] = eval_map(GT, Pred)
    % Computes the interpolated mAP 
    %
    % Input
    %   Gt      [N x Q]     Binary GT indicating relevance (1) or non-relevance (0)
    %   Pred    [N x Q]     Predictions for N documents for Q queries
    %
    % Output
    %   mAP     scalar      mean Average Precision (over all queries)
    %   ap 		scalar		non-interpolated MAP
    %   det    	struct 		with more detailed scores
    %
	% copyright, 2014
    % Thomas Mensink, University of Amsterdam
    % thomas.mensink@uva.nl    
    
    NrN = size(Pred,1);
    NrQ = size(Pred,2);
    assert(NrQ == size(GT,2));
    
    % compute interpolated average precision
    T   = 0:0.1:1;
    iAP = zeros(numel(T),NrQ);
    nAP = zeros(1,NrQ);
    
    for q=1:NrQ,
        % compute the ranking of the documents for this query
        [~,sinx]= sort(Pred(:,q),'descend');
        gt      = GT(sinx,q);
        gt      = gt == 1;
        
        % compute true positives
        tpossum = cumsum(gt);
        npos    = tpossum(end);
        
        % compute precision and recal
        rec     = tpossum / npos;
        prec    = tpossum ./ (1:NrN)';
        
        % compute interpolated AP
        for ti=1:numel(T);
            p=max(prec(rec>=T(ti)));
            if isempty(p),p=0; end
            iAP(ti,q) = p;
        end
        
        %compute AP
        nAP(q) = mean(prec(gt));
    end
    iap = mean( mean(iAP,1) );
    ap  = mean(nAP);
    
    det.T   = T;
    det.iAP = iAP;
    det.miAP= mean(iAP);
    det.nAP = nAP;    
    det.NrQ = NrQ;    
end
