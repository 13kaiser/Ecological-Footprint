# Socioeconomic Status Mostly Outweighs Psychological Factors in Predicting Individual Ecological Footprints

This repository contains the data and code used in the research project examining the relationship between socioeconomic status (SES), psychological factors, and individual ecological footprints in six G7 countries, as outlined in the article submitted to PNAS.

## Project Overview

The study explores the connections between socioeconomic status (SES), psychological factors, and individual ecological footprints using data from 5,069 participants across six G7 countries. The findings highlight that while psychological factors such as biospheric values are associated with smaller ecological footprints, SES has a much larger impact, with high SES individuals typically having larger footprints, particularly in relation to transportation activities. The study underscores the need for targeted strategies that address high-impact behaviors, particularly among affluent individuals, as psychological factors alone may not be enough to mitigate climate change.

## Files

- `Final_analysis.do`: Main Stata do-file used for all analyses in the paper, including data preparation, regression models, and the generation of all tables and figures except Figure 3.

- `contourplots.do`: Stata do-file used to generate the contour plots presented in Figure 3.

- `final.dta`: Main dataset containing all variables used in the analysis, including socioeconomic status (SES), psychological factors, and ecological footprints across six G7 countries.

- `total_econ_biov.dta`, `total_econ_clmtimp.dta`, `total_econ_pnorm.dta`, `total_econ_suffort.dta`: Intermediate datasets used for generating the contour plots in Figure 3.  
  These datasets can be fully reproduced from `final.dta` using the provided code.

## Usage

1. Clone the repository: git clone https://github.com/13kaiser/Ecological-footprint.git
  
2. Open the Stata do-files in Stata.

3. Set your working directory at the beginning of each do-file: cd "[YOUR_DIRECTORY]"

4. Run the main analysis:
- Execute `Final_analysis.do` to reproduce all main results (tables and figures except Figure 3).

5. Run the contour plots:
- Execute `contourplots.do` to reproduce Figure 3.

## Requirements

- Stata (version 16 or higher)

## Contact

For any questions or issues regarding this repository, please contact:  
m.kaiser@jbs.cam.ac.uk
