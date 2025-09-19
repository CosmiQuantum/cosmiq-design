# AWS Palace on the Quest HPC at Northwestern University

## Table of contents: 
- [Overview of AWS Palace on Quest](#overview-of-aws-palace-on-quest)
    - [Setup](#setup)
    - [Submitting Jobs and Other Useful Tools](#submitting-jobs-and-other-useful-tools)
    - [Palace Slurm Job Submission Script](#palace-slurm-job-submission-script)
    - [HPC Rules of Thumb](#hpc-tips-and-tricks)

- [Appendix A: Installation Process](#appendix-a-installation-process)
- [Appendix B: Benchmarking](#appendix-b-benchmarking)
    - [Quality Checks](#quality-checks)
    - [AWS Palace Computational Performance Experiments](#aws-palace-computational-performance-experiments)

# Overview of AWS Palace on Quest 

My (Firas) Quest allocation is named *p32999*. The allocation type is "Research Allocation I" which gives us 1024 GB of storage under our project directory (```/projects/p32999/```) and 100,000 compute hours (soft limit). 

Currently, the project directory has the following setup:

```
/projects/p32999/
├── palace/
├── palace_gpu/
├── palace_sims/
├── palace-setup.sh 
└── palace_jobscript.sh
```

There are a couple points I'd like to make: 
1) ```palace_jobscript.sh``` is meant to act a template, so please do not directly use it (I should probably rename it soon to indicate that). Instead copy it and rename it to something like ```palace_jobscript_<your_name>.sh``` from there you can edit your copy to your specifications.
2) I request all simulations (which encompasses a Palace config file (json) and a corresponding mesh file) be stored under their own folders inside ```palace_sims/```. In each simulation folder, please make a ```readme.txt``` where you describe the details of the simulation. For instance, as of writing this I have ran two simulations so far, so the contents of ```palace_sims/``` are:
```
/projects/p32999/
├── cylinder-example/
    ├── cavity_pec.json
    ├── cylinder_tet.msh
    └── readme.txt
└──SQuADDS-Tutorial-7/
    ├── qubit-cavity-eig-test.json
    ├── cylinder_tet.msh
    └── readme.txt
```
3) Notice there are two AWS Palace installations under ```/projects/p32999/```, there is ```palace``` and ```palace_gpu```. As the names imply, the first one is without GPU resources enabled while the latter does have GPU resources (cuda) enabled. I have yet to test ```palace_gpu``` but generally since GPU usage eats a lot of compute, ```palace_gpu``` should be saved for only very complex geometries. I have yet to create (or test) a jobscript for use with ```palace_gpu``` but will do so soon.

To get access to this allocation and run AWS Palace on Quest you need to fill out [this](https://app.smartsheet.com/b/form/797775d810274db5889b5199c4260328). You need a Northwestern NetID in order to go this route. I believe there is a way to get around this for non-NU folk but I need to look into that still.

## Setup

Assuming you now have access to the allocation, *p32999*, we can now go over how to get onto Quest. First either be connected eduroam on campus or use a VPN to connect to [Northwestern's network](https://services.northwestern.edu/TDClient/30/Portal/KB/ArticleDet?ID=1818).

To tunnel into Quest run:

```$ ssh <your_netid>@quest.northwestern.edu```

Then head over to the project directory and run ```palace-setup.sh``` which automatically loads all the modules we need into our environment to run AWS Palace.

```
$ cd /projects/p32999
$ source palace-setup.sh
```

We're now ready to get our EM simulation on (:

## Submitting Jobs and Other Useful Tools

Quest, as many standard HPCs, uses [Slurm](https://slurm.schedmd.com/overview.html). So this part of the guide is generic to most HPCs! For a detailed guide on using Quest, see the [Quest User Guide](https://services.northwestern.edu/TDClient/30/Portal/KB/ArticleDet?ID=505). I will go over most of the tools you need here. 

To submit a job: 

```$ sbatch palace_jobscript.sh``` 

I will go over the palace_jobscript in [Palace Slurm Job Submission Script](#palace-slurm-job-submission-script).

After submitting a job, you will get a job id. To check the status of your job run:

```$ squeue -j <jobid>``` or (which I prefer) for a more detailed look at your job run ```$ checkjob <jobid>```.

It's a good idea to save the output of the checkjob command for our internal knowledge. To do so, run:

```checkjob <jobid> > <jobid>.txt```

After a job is done (whether it completed or failed), you will see a slurm text file appear, slurm-<jobid>.out, that will contain the command line output from your simulation. If your AWS Palace job failed to run, it will be good to look at that file to look at the errors. 

## Palace Slurm Job Submission Script
## HPC Tips and Tricks

It is very important to utilize HPC resources responsibly and resonably, both from a "fairshare" user standpoint as well as the fact that we are technically limited in computer hours. In this section, I will go over some tips, tricks, and rules of thumb for HPC computing. (to be continued).

# Appendix A: Installation Process 

Loaded in the following modules: 
* cmake/3.26.3-gcc-10.4.0
* gcc/10.4.0-gcc-4.8.5
* cuda/12.2.2-gcc-10.4.0
* mpi/openmpi-4.1.7-gcc-10.4.0
* openblas/0.3.23-gcc-10.4.0
* python/3.9.16-gcc-10.4.0

Before starting the build process I also had to run: ```$export FC=mpif90``` because CMake wasn't finding the Fotran compiler on its own.

As noted above there are two Palace installations under ```/projects/p32999```. One with GPU resources enabled, ```palace_gpu``` and one without ```palace```. 

For the ```palace``` build, I ran the following CMake command:

```cmake ../palace_source -DCMAKE_INSTALL_PREFIX=../palace_install -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx -DPALACE_WITH_OPENMP=ON -DBLA_VENDOR=OpenBLAS```

For the ```palace_gpu``` build, I ran the following command:

```cmake ../palace_source -DCMAKE_INSTALL_PREFIX=../palace_install -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx -DPALACE_WITH_OPENMP=ON -DPALACE_WITH_CUDA=OFF -DBLA_VENDOR=OpenBLAS```


Notice both installation have multithreading enabled. 

# Appendix B: Benchmarking
## Quality Checks
## AWS Palace Computational Performance Experiments
