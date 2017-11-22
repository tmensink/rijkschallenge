function [topk] = eval_top(G,P,k)
    % predict performance at top 1 ... k
    % input
    %   G = N x 1
    %   P = N x Classes
    %   k = scalar (default = 5)
    %
    % Output
    %   topk    vector  1 x k top k performance averaged per image
    %
	% copyright, 2014
    % Thomas Mensink, University of Amsterdam
    % thomas.mensink@uva.nl    
       
    if nargin < 3 || isempty(k), k = 5;end
    NrC = size(P,2);
    N = histc(G,1:NrC);
    N(N==0) = 1;
    N = 1./N;
    
    [val,inx] = sort(P,2,'descend');
    C = cumsum( bsxfun(@eq,inx(:,1:k),G),2);
    M = bsxfun(@times,C,N(G));
    topk = sum(M,1)./NrC;
end
