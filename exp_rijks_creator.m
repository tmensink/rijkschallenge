%% Rijksmuseum Creator Challenge
% script to run and evaluate the baseline for the Rijksmuseum Challenge
%
% Part of RMC14 - initial release
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
expOpts.data.file       = [bdir, 'rijksFV16.mat'];
expOpts.data.gtfile     = [bdir, 'rijksgt.mat'];
expOpts.rdir            = rdir;   
clearvars bdir rdir

expOpts.data.gtfield    = 'C';                  % Get creator field from GT
expOpts.data.minTstOcc  = 10;

expOpts.svm.run         = 1;                    % Set to 1 to run, 0 to evaluate existing classifiers!
expOpts.svm.C           = logspace(-2,2,5);     % Set SVM options (hyper-parameter C)
expOpts.svm.method      = '1vR';                % Set SVM method
expOpts.svm.algo        = 1;                    % Option of LibLinear Train

expOpts.eval.func       = 'mca';                % Set evaluation measure (MCA)

exp_rijks_run                                   % Run experiment

%%% 
% This will run the experiment, the final few lines should be (similar to):
% Cross Validate using mca
%         C 1e-02 P    0.020 (mca)
%         C 1e-01 P    0.171 (mca)
%         C 1e+00 P    0.417 (mca)
%         C 1e+01 P    0.503 (mca)
%         C 1e+02 P    0.488 (mca)
% Evaluate using C 1e+01 |
% creator
%            0 | TRN | ii  375 ( all )| MCA:   97.81   99.99   99.99   99.99   99.99
%            0 | VAL | ii  375 ( all )| MCA:   50.27   67.85   73.16   76.62   78.87
%            0 | TST | ii  375 ( all )| MCA:   51.02   68.42   73.98   77.60   79.97
%            1 | TST | ii  374 ( 59.1)| MCA:   65.53   73.33   77.26   79.78   81.33
%            2 | TST | ii  300 ( 55.5)| MCA:   67.63   75.38   78.84   81.14   82.63
%            3 | TST | ii  250 ( 52.5)| MCA:   69.45   77.04   80.68   82.92   84.31
%            4 | TST | ii  200 ( 48.7)| MCA:   71.17   79.15   82.77   84.88   86.22
%            5 | TST | ii  150 ( 43.6)| MCA:   72.58   80.90   84.57   86.76   88.21
%            6 | TST | ii  100 ( 36.8)| MCA:   75.73   83.42   87.32   89.14   90.45
%            7 | TST | ii   50 ( 26.4)| MCA:   78.18   86.45   90.00   91.95   93.22
%            8 | TST | ii   25 ( 18.7)| MCA:   81.81   89.59   92.79   94.69   96.01