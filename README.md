# Rijksmuseum Challenge: -- Baseline and Evaluation

These matlab files are intended to showcase the baselines on the Rijksmuseum challenge

Per challenge there is a file (ie exp_rijks_creator for the Creator Challenge)
  - it loads the data
  - it loads/trains SVM models
  - it evaluate the SVM models (and select the best one on the validation set)

Make sure to clear all variables (mainly the data struct) before evaluating another challenge. (Because ground-truth is loaded differently for each challenge)

**Dependency**: The provided Matlab code, make use of the LIBLINEAR package ( [web](https://www.csie.ntu.edu.tw/~cjlin/liblinear/),
[github](https://github.com/cjlin1/liblinear)). Make sure to compile the Matlab interface, and that LIBLINEARs `train` function is in the Matlab path

## Paper

![t-SNE plot of RMC14](https://github.com/tmensink/rijkschallenge/blob/dev/img/dataviz.jpg)

When using this code, or this challenge, please cite the following paper ([pdf](https://ivi.fnwi.uva.nl/isis/publications/2014/MensinkICMIR2014/MensinkICMIR2014.pdf))

    @INPROCEEDINGS{mensink14icmr,
      author = {Thomas Mensink and Jan van Gemert},
      title = {The Rijksmuseum Challenge: Museum-Centered Visual Recognition},
      booktitle = {ACM International Conference on Multimedia Retrieval (ICMR)},
      year = {2014}
      }

## Data
The data (Fisher Vector files, ground-truth, images, and xml files) is available from:

**todo add link**

## Copyright (2014-2017)
Thomas Mensink, University of Amsterdam
thomas.mensink@uva.nl
