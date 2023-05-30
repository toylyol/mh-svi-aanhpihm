# Exploring Asian American & Native Hawaiian and Pacific Islander Populations in 'High-Vulnerability' Counties

This [infographic](https://www.minorityhealth.hhs.gov/aanhpihm/images/AANHPI%202023_infographic_final.png) was created while on detail (temporary reassignment) with DHHS Office of Minority Health.

The 2018 iteration of the Minority Health Social Vulnerability Index (SVI) was used to conduct the exploratory analysis. The Minority Health SVI is an extension of the CDC/ATSDR SVI. The SVI Exploration folder is a R Project that can be downloaded to reproduce the analysis. See the [R Markdown file](https://github.com/toylyol/mh-svi-aanhpihm/blob/main/SVI%20Exploration/MH%20SVI%20Exploration.Rmd) for all of the analysis code. The data are publicly available for download [online](https://www.minorityhealth.hhs.gov/minority-health-svi/).

Geographic visualizations were also produced using R thanks to the {tigris}, {sf}, and {ggplot2} packages. The custom color palettes for the maps were generated from the template colors provided by OMH using the [Colorgorical](http://vrl.cs.brown.edu/color) tool created by Gramazio, Laidlaw, and Schloss. Instructions from [Nicola Rennie's R-Ladies Cambridge talk](https://nrennie.rbind.io/talks/rladies-cambridge-ggplot2-colours/) were invaluable for easily using the custom color palettes with {ggplot2}.

![](AANHPI 2023_infographic_final.png)