# Predicting antimicrobial resistance with hypercubic inference

This repository contains the complete pipeline for my poster at the Norwegian Bioinformatics Days. To generate all the plots run `Rscript run_all.R` from the root repository directory. The plotting code depends on `ggplot2`, `ggupset`, `tidyverse`, `plyr` and `tmap`. Not all of these dependencies are required for each plot, each plotting function in the scripts load only the needed dependencies. If you only want to reproduce one of the plots, check the script for which dependencies are required.

To run the model you must also to clone the [hypertraps-ct](https://github.com/StochasticBiology/hypertraps-ct) repository, and have `Rcpp`, `ape` and `phangorn` installed. Hypertraps-ct should be in a neighbouring folder to this repository on you computer. Alternatively you can change the hypertraps.path parameter in run\_hypertraps.R. Uncomment `model.fit <- run.hypertraps()` in run\_all.R and remove the line loading the precalculated data. Running the model should take less than 20 minutes.

All data, apart from the newick-trees, is downloaded from [pathogen.watch](pathogen.watch) with the download\_pathogenwatch.R script. The newick-trees were exported by making collections in pathogen.watch and exported manually. To use the download script on Mac and Linux you need `wget` installed on your system. Windows requires `wininet`.

## World map

The world map was made using tmap and populated with data from pathogen.watch. A function to make the plot can be found in scripts/world\_map.R.

![World map of Klebsiella isolates](figures/worldmap_poster.svg "Global distribution of whole-genome sequenced isolates")

## Upset plot

The upset plot was made using ggupset. The code can be found in scripts/upset.R

![Upset plot of the different resistance gene profiles](figures/upset_poster.svg "Upset plot over *Klebsiella pneumoniae* resistance profiles")

## Hypercube illustration

I made this illustration using Pinta and LibreOffice Impress on Ubuntu.

![Hypercube with Klebsiella isolates and three features](figures/kp_hypercube_poster.png "Hypercube with three features")

## Predicted ordered acquisition

To generate this plot we need a fitted model from HyperTraPS. One instance of this has been saved in fitted-model.Rdata. Further models can be made using run\_hypertraps(country\_name, your\_seed). Check the trees directory for avaible countries. The fitted model is plotted using the scripts/bubbles.R script. 

![Bubble plot depicting the probable ordering of gene acquisition](figures/bubbles_germany_poster.svg "Bubble plot")

## Sources

Aga, Olav N. L., Morten Brun, Kazeem A. Dauda, Ramon Diaz-Uriarte, Konstantinos Giannakis, and Iain G. Johnston. 2024. ‘HyperTraPS-CT: Inference and Prediction for Accumulation Pathways with Flexible Data and Model Structures’. bioRxiv. https://doi.org/10.1101/2024.03.07.583841.

Bialek-Davenet, Suzanne, Alexis Criscuolo, Florent Ailloud, Virginie Passet, Louis Jones, Anne-Sophie Delannoy-Vieillard, Benoit Garin, et al. 2014. ‘Genomic Definition of Hypervirulent and Multidrug-Resistant Klebsiella Pneumoniae Clonal Groups’. Emerging Infectious Diseases 20 (11): 1812–20. https://doi.org/10.3201/eid2011.140206.

Wyres, Kelly L., Margaret M. C. Lam, and Kathryn E. Holt. 2020. ‘Population Genomics of Klebsiella Pneumoniae’. Nature Reviews. Microbiology 18 (6): 344–59. https://doi.org/10.1038/s41579-019-0315-1.


