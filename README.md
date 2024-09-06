This repository contains scripts used for my PhD dissertation, "EXECUTIVE DYSFUNCTION AND DEPRESSION RISK IN ADOLESCENCE: 
FMRI ANALYSIS OF TRANSIENT NETWORK STATES DURING A WORKING MEMORY TASK".

Dissertation available here: https://scholar.colorado.edu/concern/graduate_thesis_or_dissertations/qr46r266s

Executive Function (EF) deficits have been linked to risk for depression, but the potential neural correlates of this association remain unclear. 
Altered functioning of brain regions associated with the frontoparietal network (FPN) could mediate risk.
This project examined how fMRI-based transient network states related to performance on a working memory task and future depressive symptom trajectories.
We identified an FPN-like state that mediated associations between worse baseline task performance and greater future depressive symptoms.

We applied co-activation pattern analysis (CAP) to identify a set of transient network states that emerged during a working memory updating task. 
CAP uses k-means to identify recurring patterns of whole-brain activity. The KMeans folder contains scripts for selecting the appropriate k solution, running the final k-means algorithm, generating brain images from the k-means output, and evaluating spatial similarity with other brain maps (e.g. the Yeo Network parcellation).

The Data_Cleaning folder contains scripts for smoothing the state sequences, computing additional metrics from the state sequences, and computing behavioral measures from the fMRI task output files.

Additionally, we used dynamic structural equation modeling (DSEM) to model depressive symptom trajectories for two years after baseline to capture severity, stability, and variance in depression scores over time for each person. These models were estimated using MPlus. These models are located in Analyses/Mplus_Analyses.

