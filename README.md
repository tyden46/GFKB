# GFKB
Scripts used to generate v4.0 of the Gut Feeling KnowledgeBase

## Content
#### This repository contains one R script:
BacteriaStats.R <br><br>

#### And 4 supplementary files:
GFKB2.csv - a csv file containing a list of organisms and associated metadata <br><br>
microbiome_data.csv - a csv file containing the relative abundance results of an epilepsy/ketogenic diet study (a subset of the data from Human_Keto_Microbiome_Revised.csv)<br><br>
prokaryotes.csv - a csv file containing a list of prokaryotes and associated metadata (including genome size)<br><br>
Human_Keto_Microbiome_Revised.csv - A full report of the results of the keto microbiome study<br><br><br>

## Process
Sheet 2 from Human_Keto_Microbiome_Revised.csv was saved as a separate file, microbiome_data.csv (already included in this repository)<br><br>
<br>
RStudio was used to run BacteriaStats.R<br><br>
Comments in BacteriaStats.R give more detail regarding the process but, in broad terms, the following were performed:<br>
1. Genome sizes (where available) were fetched for the organisms in GFKB <br><br>
2. A "Unique ID" was assigned to each organism. This ID is the organism's uniprot ID concatenated with its GenBank Accession number, separated by an underscore<br><br>
3. Median, mean, standard deviation, interquartile range, minimum, maximum, range, and quantiles were calculated for each of the four treatment groups in the epilepsy study (Control before diet, control after diet, patient before diet, patient after diet)<br><br>
4. The metrics described in step 3 were added to the GFKB table<br><br>
5. The table was separated into two csv files. The first, Organisms.csv, contains the list of organisms with all of the metadata not directly associated with the epilepsy study. The second, Epilepsy.csv, contains limited metadata about the organisms and the relative abundance metrics described in step 3 <br><br>
6. csv files were uploaded to Google Sheets. Column names were edited to include spaces. Sheet 2 was formatted to include a legend and columns were highlighted. Google Sheets document available upon request.

## Notes
Four of the organisms we have represented in our table are semi-reduntant (UP000001360_AP010889 is semi-reduntant to UP000001360_CP001095 and UP000000439_AE014295 is semi-redundant to UP000000439_LN824140) <br><br>
By semi-reduntant, it is meant that in each case a single uniprot ID matches to two GenBank Accession numbers <br><br>
As a consequence, the Epilepsy tab has two rows which contain NA values. These two rows correspond to GenBank numbers which appear in our Organisms sheet but, due to their redundancy with other organisms in that list, do not map to a GenBank accession number associated with our epilepsy data.
