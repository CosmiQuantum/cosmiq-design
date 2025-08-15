# AWS Palace on the Fermilab Grid

## Table of contents: 
[Overview of AWS Palace on the grid](#overview-of-aws-palace-on-the-grid)\
[Running AWS Palace on the grid](#running-aws-palace-on-the-grid)\
[Appendix A: Installation Process](#appendix-a-installation-process)

# Overview of AWS Palace on the grid

The general workflow of using the Fermilab grid is illustrated in the figure below. 

![Logo](Figures/palace-grid-flowchart.png)

We publish software, codes, retrieve data, and submit grid jobs using the computer cosmiqgpvm02. The Fermilab grid is only able to "see" software and code published to cvfms, in particular for the CosmiQ group, AWS Palace and its dependencies are all published under /cvmfs/Fermilab.opensciencegrid.org/cosmiq/palace-env/. The palace-env directory has the following organization:

<pre> ``` /cvmfs/fermilab.opensciencegrid.org/cosmiq/palace-env/ ├── lapack/ ├── openblas/ ├── openmpi/ └── palace/ ``` </pre>

Palace scripts and accompanying mesh files must also be published to cvfms in order to be used by the grid. To publish new palace scripts and mesh files, move the files 

 

# Running AWS Palace on the grid
# Appendix A: Installation Process 
