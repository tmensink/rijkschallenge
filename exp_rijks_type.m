%% Rijksmuseum Type Challenge
% script to run and evaluate the baseline for the Rijksmuseum Challenge
%
% copyright, 2014-2017
% Thomas Mensink, University of Amsterdam
% thomas.mensink@uva.nl
clc;
clearvars -except data
n = 'Rijksmuseum Type Challenge';
v = 1.1;
fprintf('%30s | %7.4f | %s\n',n,v,datestr(now,31));

expOpts                 = struct();
expOpts.name            = 'type';

[bdir,rdir]             = exp_rijks_datadir();  % Get directory of results and data
expOpts.rdir            = rdir;                
expOpts.data.file       = [bdir, 'rijksFV16.mat'];
expOpts.data.gtfile     = [bdir, 'rijksgt.mat'];
clearvars bdir rdir

expOpts.data.gtfield    = 'T';                  % Get type field from GT
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
% type
%            0 | TRN | ii  103 ( all )| mAP:   64.15 imAP   86.37
%            0 | VAL | ii  103 ( all )| mAP:   55.76 imAP   85.77
%            0 | TST | ii  103 ( all )| mAP:   54.69 imAP   85.98
%            1 | TST | ii   75 ( 96.3)| mAP:   58.45 imAP   89.30
%            2 | TST | ii   50 ( 94.9)| mAP:   62.17 imAP   90.40
%            3 | TST | ii   25 ( 92.2)| mAP:   64.75 imAP   92.04