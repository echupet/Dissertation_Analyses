# Dissertation Analyses

Code and analytical workflows for my Ph.D. dissertation examining dynamic patterns of brain activity during cognitive performance and their relationships with behavior and longitudinal mental-health outcomes.

## Overview

This repository contains code for processing, analyzing, and visualizing high-dimensional fMRI and behavioral data. The primary analyses use co-activation pattern (CAP) analysis and k-means clustering to identify recurring whole-brain activity states and characterize how their dynamics vary across individuals.

The project also integrates these neuroimaging measures with behavioral and longitudinal survey data to examine relationships between brain-state dynamics, cognitive performance, and mental-health outcomes measured over approximately two years.

## Analytical Workflow

The repository includes code for:

- Cleaning and preprocessing behavioral and analysis-derived data
- Performing k-means clustering of high-dimensional fMRI data
- Evaluating alternative clustering solutions and selecting the number of brain states
- Assessing clustering reliability and matching states across solutions
- Generating and visualizing whole-brain co-activation patterns
- Converting fMRI data into sequences of recurring brain states
- Deriving temporal measures describing brain-state dynamics
- Testing relationships between brain-state dynamics and cognitive performance
- Preparing longitudinal behavioral and survey data
- Modeling longitudinal mental-health outcomes using Dynamic Structural Equation Modeling (DSEM)

## Technical Approach

The analyses combine high-dimensional time-series processing, unsupervised clustering, longitudinal modeling, and data visualization. Computationally intensive portions of the workflow were optimized to reduce memory requirements and parallelize processing where appropriate.

Primary tools include **R, MATLAB, and Mplus**.

## Publication

These analyses contributed to my dissertation research and associated peer-reviewed publications.

Peterson, E. C., et al. (2026). *Executive Dysfunction and Depression Risk in Adolescence: Functional-MRI Analysis of Transient Network States During a Working Memory Task.* Clinical Psychological Science.

## Notes

This repository contains analysis code rather than participant-level research data. File paths and some inputs reflect the original research computing environment and may require modification to run in another environment.
