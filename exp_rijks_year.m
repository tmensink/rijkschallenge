%% Rijksmuseum Year Challenge
% script to run and evaluate the baseline for the Rijksmuseum Challenge
%
% copyright, 2014-2017
% Thomas Mensink, University of Amsterdam
% thomas.mensink@uva.nl
clc;
clearvars -except data
n = 'Rijksmuseum Year Challenge';
v = 1.1;
fprintf('%30s | %7.4f | %s\n',n,v,datestr(now,31));

expOpts                 = struct();
expOpts.name            = 'year';

[bdir,rdir]             = exp_rijks_datadir();  % Get directory of results and data
expOpts.rdir            = rdir;                
expOpts.data.file       = [bdir, 'rijksFV16.mat'];
expOpts.data.gtfile     = [bdir, 'rijksgt.mat'];
clearvars bdir rdir

expOpts.data.gtfield    = 'Y';                  % Get the year field from GT
expOpts.data.minTstOcc  = 10;

expOpts.svm.run         = 1;                    % Set to 1 to run, 0 to evaluate existing classifiers!
expOpts.svm.C           = logspace(-2,2,5);     % Set SVM options (hyper-parameter C)
expOpts.svm.method      = 'reg';                % Set SVM method (regression)
expOpts.svm.algo        = 11;                   % Option of LibLinear Train, see documentation '-s'

expOpts.eval.func       = 'sqloss';             % Set evaluation measure (SQ Loss)

exp_rijks_run                                   % Run experiment