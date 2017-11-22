# Rijksmuseum Challenge: -- Baseline and Evaluation

These matlab files are intended to showcase the baselines on the Rijksmuseum challenge

Per challenge there is a file (ie exp_rijks_creator for the Creator Challenge)
  - it loads the data
  - it loads/trains SVM models
  - it evaluate the SVM models (and select the best one on the validation set)

Make sure to clear all variables (mainly the data struct) before evaluating another challenge.(Because ground-truth is loaded differently for each challenge)

## Paper
When using this code, or this challenge, please cite the following paper

    @INPROCEEDINGS{mensink14icmr,
      author = {Thomas Mensink and Jan van Gemert},
      title = {The Rijksmuseum Challenge: Museum-Centered Visual Recognition},
      booktitle = {ACM International Conference on Multimedia Retrieval (ICMR)},
      year = {2014}
      }

## Copyright (2014-2017)
Thomas Mensink, University of Amsterdam
thomas.mensink@uva.nl
