%% Rijksmuseum Challenge Run Experiment
% script to run a Rijksmuseum Challenge
%
% Part of RMC14 - initial release
% copyright, 2014-2018
% Thomas Mensink, University of Amsterdam
% thomas.mensink@uva.nl
clearvars -except data expOpts
n = 'RMC Run Experiment';
v = 1.2;
fprintf('%30s | %7.4f | %s\n',n,v,datestr(now,31));

%History
% v 1.2: Also reloads data when experiment changes (creator requires different data than material)

if exist('data','var') ~= 1 || strcmp(data.expName,expOpts.name),
    data                = rijks_load(expOpts);
    data.expName        = expOpts.name;
end
R                       = rijks_svm(expOpts,data);
res                     = rijks_eval(expOpts,data,R);
