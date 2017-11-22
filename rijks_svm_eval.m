function S = rijks_svm_eval(W,X)
    % Evaluate linear SVM classifiers W on input features X
    
    Wdim = size(W,1);
    Xdim = size(X,1);
        
    S       = W(1:Xdim,:)' * X;
    if Wdim > Xdim,
        S   = bsxfun(@plus,S,W(end,:)');
    end    
end