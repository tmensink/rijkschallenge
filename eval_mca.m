function [mca] = eval_mca(G,P,k)
    % Compute Mean Class Accuracy (using top-k predictions)
    %
    % input
    %   G = N x 1
    %   P = N x Classes
    %   k = scalar (default = 5)
    %
    % Output
    %   topk    vector  1 x k top k performance averaged per image
    %
	% Part of RMC14 - initial release
	% copyright, 2014-2017
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
    mca = sum(M,1)./NrC;
end
