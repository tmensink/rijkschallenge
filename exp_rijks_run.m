%% Rijksmuseum Challenge Run Experiment
% script to run a Rijksmuseum Challenge
%
% Part of RMC14 - initial release
% copyright, 2014-2017
% Thomas Mensink, University of Amsterdam
% thomas.mensink@uva.nl
clearvars -except data expOpts
n = 'RMC Run Experiment';
v = 1.1;
fprintf('%30s | %7.4f | %s\n',n,v,datestr(now,31));

if exist('data','var') ~= 1,
    data                = rijks_load(expOpts);
end
R                       = rijks_svm(expOpts,data);
res                     = rijks_eval(expOpts,data,R);
