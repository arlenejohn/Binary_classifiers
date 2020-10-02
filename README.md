# Binary_classifiers
Code for the paper "Binary Classifiers for Data Integrity Detection in Wearable IoT Edge Devices."

The iterating_final_parts script generates the 10-fold cross-validation sets, generate features using ksqi_calc_parts and ssqi_calc_parts functions, trains the k-NN, DT, SVM, NB, LDA, NN, bagging of DT, Gboosting of DT.  Also tests the performance of these models as well as the prediction performance of the fusion of few models (NB+LDA, NB+LDA+DT, k-NN, DT, SVM, NB, LD, NN) and generates the gross confusion matrix.

The training_list.mat files contain the list of files and the classes.

Installation of the WFDB toolbox is a  pre-requisite to execute the main program.
