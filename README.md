# Rijksmuseum Challenge 2014
This software package provides baseline scores for the 4 different computer vision challenges introduced in our ICMR paper: **The Rijksmuseum Challenge: Museum-Centered Visual Recognition**

In our paper, we have introduced 4 challenges:
  - Creator: predict the creator of a piece of art
  - Material: predict the materials used (pen, paper)
  - Type: predict the type of art (drawing, painting, sculpture)
  - Year: predict the year of creation (1960, 1684)
See the paper for more details and considerations about the used data.

![t-SNE plot of RMC14](https://github.com/tmensink/rijkschallenge/blob/master/img/dataviz.jpg)


## Baseline code and Evaluation
These provide Matlab codes are intended to showcase the baselines on the Rijksmuseum Challenge 2014 as published in the paper.

Per challenge there is a file (ie `exp_rijks_creator.m` for the Creator Challenge), which
  - loads the data
  - loads/trains SVM models
  - cross-validate the SVM hyperparameter
  - evaluate the model using the challenge specific measure (MCA, mAP, Sq-Loss)

The expected results are included in each of the challenge scripts. For example for the Creator Challenge:

Setting | Set | Num Classes (%) | MCA Top 1| Top 2 | Top 3 | Top 4 | Top 5|
--------|
0 | VAL | 375 ( all )| 50.27 |  67.85  | 73.16 |  76.62 | 78.87
0 | TST | 375 ( all )| 51.02 |  68.42  | 73.98 |  77.60 | 79.97
1 | TST | 374 ( 59.1)| 65.53 |  73.33  | 77.26 |  79.78 | 81.33
2 | TST | 300 ( 55.5)| 67.63 |  75.38  | 78.84 |  81.14 | 82.63
3 | TST | 250 ( 52.5)| 69.45 |  77.04  | 80.68 |  82.92 | 84.31
4 | TST | 200 ( 48.7)| 71.17 |  79.15  | 82.77 |  84.88 | 86.22
5 | TST | 150 ( 43.6)| 72.58 |  80.90  | 84.57 |  86.76 | 88.21
6 | TST | 100 ( 36.8)| 75.73 |  83.42  | 87.32 |  89.14 | 90.45
7 | TST |  50 ( 26.4)| 78.18 |  86.45  | 90.00 |  91.95 | 93.22
8 | TST |  25 ( 18.7)| 81.81 |  89.59  | 92.79 |  94.69 | 96.01
These results correspond to the results of the intensity FV in Table 1 in [mensink14icmr].

## Code Dependency
The provided Matlab code, makes use of the LIBLINEAR package ([web](https://www.csie.ntu.edu.tw/~cjlin/liblinear/),[github](https://github.com/cjlin1/liblinear)).
For convenience the required `train` function is added to the `lib` directory (for Mac and Linux only). Ensure to add it to the Matlab path

## Data
The data (Fisher Vector files, ground-truth, images, and xml files) is available from: [figshare](https://figshare.com/articles/Rijksmuseum_Challenge_2014/5660617) ([doi](https://doi.org/10.21942/uva.5660617))

The Fisher Vectors are extracted with the  [FVKit](https://github.com/tmensink/fvkit).

## Paper
When using this code, or this challenge, please cite the following paper ([pdf](https://staff.fnwi.uva.nl/t.e.j.mensink/publications/mensink14icmr.pdf))

    @INPROCEEDINGS{mensink14icmr,
      author = {Thomas Mensink and Jan van Gemert},
      title = {The Rijksmuseum Challenge: Museum-Centered Visual Recognition},
      booktitle = {ACM International Conference on Multimedia Retrieval (ICMR)},
      year = {2014}
      }

## Version history
* V1.0, Nov 2017: Moved to Github (initial release)
* V1.1, Jan 2018: Updated readme and make compatible with  [FVKit](https://github.com/tmensink/fvkit) extraction.

### Copyright (2014-2018)
Thomas Mensink, University of Amsterdam, thomas.mensink@uva.nl

