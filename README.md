# Rijksmuseum Challenge 2014

This software package provides baseline scores for the 4 different computer vision challenges introduced in our ICMR paper: **The Rijksmuseum Challenge: Museum-Centered Visual Recognition**

In our paper, we have introduced 4 challenges:
  - Creator: predict the creator of a piece of art
  - Material: predict the materials used (pen, paper)
  - Type: predict the type of art (drawing, painting, sculpture)
  - Year: predict the year of creation (1960, 1684)
See the paper for more details and considerations about the used data.


##Baseline code and Evaluation

These provide Matlab codes are intended to showcase the baselines on the Rijksmuseum Challenge 2014 as published in the paper. 

Per challenge there is a file (ie `exp_rijks_creator.m` for the Creator Challenge), which
  - loads the data
  - loads/trains SVM models
  - cross-validate the SVM hyperparameter
  - evaluate the model using the challenge specific measure (MCA, mAP, Sq-Loss)

Make sure to clear all variables (mainly the data struct) before evaluating another challenge. (Because ground-truth is loaded differently for each challenge)

**Code Dependency**: The provided Matlab code, make use of the LIBLINEAR package ([web](https://www.csie.ntu.edu.tw/~cjlin/liblinear/),[github](https://github.com/cjlin1/liblinear)). 
Make sure to compile the Matlab interface as well, and to add the correct path (the code requires LIBLINEARs `train` function).

## Data
The data (Fisher Vector files, ground-truth, images, and xml files) is available from:

**todo add link**

## Paper

![t-SNE plot of RMC14](https://github.com/tmensink/rijkschallenge/blob/dev/img/dataviz.jpg)

When using this code, or this challenge, please cite the following paper ([pdf](https://ivi.fnwi.uva.nl/isis/publications/2014/MensinkICMIR2014/MensinkICMIR2014.pdf))

    @INPROCEEDINGS{mensink14icmr,
      author = {Thomas Mensink and Jan van Gemert},
      title = {The Rijksmuseum Challenge: Museum-Centered Visual Recognition},
      booktitle = {ACM International Conference on Multimedia Retrieval (ICMR)},
      year = {2014}
      }

## Copyright (2014-2017)
Thomas Mensink, University of Amsterdam
thomas.mensink@uva.nl
