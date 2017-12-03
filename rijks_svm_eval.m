function S = rijks_svm_eval(W,X)
    % Evaluate linear SVM classifiers W on input features X
    %
    % Part of RMC14 - initial release
    % copyright, 2014-2017
    % Thomas Mensink, University of Amsterdam
    % thomas.mensink@uva.nl    
    
    Wdim = size(W,1);
    Xdim = size(X,1);
        
    S       = W(1:Xdim,:)' * X;
    if Wdim > Xdim,
        S   = bsxfun(@plus,S,W(end,:)');
    end    
end