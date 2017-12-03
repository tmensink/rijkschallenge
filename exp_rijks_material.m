%% Rijksmuseum Material Challenge
% script to run and evaluate the baseline for the Rijksmuseum Challenge
%
% Part of RMC14 - initial release
% copyright, 2014-2017
% Thomas Mensink, University of Amsterdam
% thomas.mensink@uva.nl
clc;
clearvars -except data
n = 'Rijksmuseum Material Challenge';
v = 1.1;
fprintf('%30s | %7.2f | %s\n',n,v,datestr(now,31));

expOpts                 = struct();
expOpts.name            = 'material';

[bdir,rdir]             = exp_rijks_datadir();  % Get directory of results and data
expOpts.rdir            = rdir;                
expOpts.data.file       = [bdir, 'rijksFV16.mat'];
expOpts.data.gtfile     = [bdir, 'rijksgt.mat'];
clearvars bdir rdir

expOpts.data.gtfield    = 'M';                  % Get material field from GT
expOpts.data.minTstOcc  = 10;

expOpts.svm.run         = 1;                    % Set to 1 to run, 0 to evaluate existing classifiers!
expOpts.svm.C           = logspace(-2,2,5);     % Set SVM options (hyper-parameter C)
expOpts.svm.method      = '1vR';                % Set SVM method
expOpts.svm.algo        = 1;                    % Option of LibLinear Train

expOpts.eval.func       = 'map';                % Set evaluation measure (MAP)

exp_rijks_run                                   % Run experiment


%%% 
% This will run the experiment, the final few lines should be (similar to):
% Cross Validate using map
%         C 1e-02 P    1.000 (map)
%         C 1e-01 P    1.000 (map)
%         C 1e+00 P    1.000 (map)
%         C 1e+01 P    1.000 (map)
%         C 1e+02 P    1.000 (map)
% Evaluate using C 1e-02 |
% material   
%            0 | TRN | ii   81 ( all )| mAP:   49.24 imAP   92.06
%            0 | VAL | ii   81 ( all )| mAP:   38.28 imAP   91.66
%            0 | TST | ii   81 ( all )| mAP:   38.30 imAP   92.06
%            1 | TST | ii   75 ( 98.5)| mAP:   40.04 imAP   93.47
%            2 | TST | ii   50 ( 98.0)| mAP:   42.18 imAP   94.00
%            3 | TST | ii   25 ( 96.1)| mAP:   51.36 imAP   95.74