function [topk] = eval_top(G,P,k)
    % Evaluate top 1 ... k prediction
    % input
    %   G = N x 1
    %   P = N x Classes
    %   k = scalar (default = 5)
    %
    % Output
    %   topk    vector  1 x k top k performance averaged per image
    %
    % Top-1 performance is similar to per image accuracy
    % Top-5 performance has been extensively used by the ILSVRC challenge
    %
	% Part of RMC14 - initial release
	% copyright, 2014-2018
	% Thomas Mensink, University of Amsterdam
	% thomas.mensink@uva.nl
       
    if nargin < 3 || isempty(k), k = 5;end
    
    [~,inx] = sort(P,2,'descend');
    C = cumsum( bsxfun(@eq,inx(:,1:k),G),2);
    topk = mean(C,1);
end
