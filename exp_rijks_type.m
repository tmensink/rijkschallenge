%% Rijksmuseum Type Challenge
% script to run and evaluate the baseline for the Rijksmuseum Challenge
%
% copyright, 2014
% Thomas Mensink, University of Amsterdam
% thomas.mensink@uva.nl
clc;
clearvars -except data
n = 'Rijksmuseum Type Challenge';
v = 1;
fprintf('%30s | %7.4f | %s\n',n,v,datestr(now,31));


expOpts                 = struct();
expOpts.name            = 'type';
expOpts.rdir            = './';                 %Base directory for results
expOpts.data.file       = './rijksFV16.mat';
expOpts.data.gtfile     = './rijksgt.mat';
expOpts.data.gtfield    = 'T';
expOpts.data.minTstOcc  = 10;

expOpts.svm.C           = logspace(-2,2,5);
expOpts.svm.method      = '1vR';
expOpts.svm.algo        = 1;

expOpts.eval.func       = 'map';

if exist('data','var') ~= 1,
    data                = rijks_load(expOpts);
end
R                       = rijks_svm(expOpts,data);
res                     = rijks_eval(expOpts,data,R);
