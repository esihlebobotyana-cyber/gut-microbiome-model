# Mathematical Modelling of Infant Gut Microbiome Development

## Project Overview

This project investigates the development of the infant gut microbial community between 1 and 3 years of age, focusing on differences associated with continued breastfeeding beyond 12 months compared with cessation of breastfeeding at 12 months.

A mathematical model is implemented in MATLAB to explore how different breastfeeding scenarios may influence microbial population dynamics over time.

## Research Question

How do microbial community trajectories differ from 1 to 3 years between children who continue breastfeeding beyond 12 months and those who cease breastfeeding at 12 months?

## Objectives

- Develop a mathematical model to represent gut microbial population dynamics.
- Simulate microbial community trajectories under two breastfeeding scenarios.
- Compare the model outputs between the two scenarios.
- Interpret the results in the context of infant gut microbiome development.
- Discuss the assumptions and limitations of the mathematical model.

## Model Description

The model describes changes in microbial populations over time using a system of differential equations.

The model incorporates the biological mechanisms and parameters specified in the MATLAB implementation. These include microbial growth, interactions between microbial populations, breastfeeding-related effects, and immune clearance.
The two feeding scenarios are defined as:

1. **Continued breastfeeding:** breastfeeding continues beyond 12 months.
2. **Breastfeeding cessation:** breastfeeding stops at 12 months.

The feeding scenarios are represented mathematically using the model's feeding-related input or parameter definitions.

## Requirements

- MATLAB or access to MATLAB Online.
- The MATLAB source files included in this repository.

## How to Run the Model

1. Download or clone this repository.
2. Open MATLAB or MATLAB Online.
3. Upload or open the downloaded source files.
4. Set the MATLAB Current Folder to the directory containing the files.
5. Run the main MATLAB script.
6. Inspect the generated plots and numerical results.

**Main script:** `run_gut_microbiota_model2.m`

## Results

The model generates three primary output figures:
Figure 1: Population Density Trajectories
Figure 2: Relative Abundance
Figure 3: Milk fraction of diet, immune factor and guild totals

The resulting plots can be used to compare population trajectories and investigate how the model responds to different feeding conditions and parameter choices.

Results should be interpreted in light of the model assumptions and should not be treated as direct clinical predictions without appropriate empirical validation.

## Limitations

The model is a simplified mathematical representation of a complex biological system. Its predictions depend on the assumptions, parameter values, and mechanisms included in the equations.

The model does not necessarily capture every biological factor influencing infant gut microbiome development. These limitations should be considered when interpreting the simulation results.

## Project Structure

- `run_gut_microbiota_model2.m` — main simulation script.
- `README.md` — project description and instructions.


## Authors

- Gugulethu Zwane and Esihle Bobotyana

## References

## Model Parameters

The model parameters, including their numerical values, are defined in the main MATLAB script. These parameters govern the microbial population dynamics and the effects represented in the model.

The parameter values used in the simulations are specified in the code and should be interpreted in accordance with the model assumptions described in the Methods and Materials section.

## Acknowledgements

This project was completed as part of a Biomathematics project at Stellenbosch University.


