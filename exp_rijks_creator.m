%% Rijksmuseum Creator Challenge
% script to run and evaluate the baseline for the Rijksmuseum Challenge
%
% copyright, 2014-2017
% Thomas Mensink, University of Amsterdam
% thomas.mensink@uva.nl
clc;
clearvars -except data
n = 'Rijksmuseum Challenge Creator Set options';
v = 1.1;
fprintf('%30s | %7.4f | %s\n',n,v,datestr(now,31));

expOpts                 = struct();
expOpts.name            = 'creator';

[bdir,rdir]             = exp_rijks_datadir();  % Get directory of results and data
expOpts.rdir            = rdir;                
expOpts.data.file       = [bdir, 'rijksFV16.mat'];
expOpts.data.gtfile     = [bdir, 'rijksgt.mat'];
clearvars bdir rdir

expOpts.data.gtfield    = 'C';                  % Get creator field from GT
expOpts.data.minTstOcc  = 10;

expOpts.svm.run         = 1;                    % Set to 1 to run, 0 to evaluate existing classifiers!
expOpts.svm.C           = logspace(-2,2,5);     % Set SVM options (hyper-parameter C)
expOpts.svm.method      = '1vR';                % Set SVM method
expOpts.svm.algo        = 1;                    % Option of LibLinear Train

expOpts.eval.func       = 'mca';                % Set evaluation measure (MCA)

exp_rijks_run                                   % Run experiment