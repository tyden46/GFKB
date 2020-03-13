#Load necessary libraries
library(stringr) 
library(matrixStats)
library(tidyverse)

#Set working directory to folder where input files are
setwd("~/Desktop")

#Read in input data
GFKB = read.csv("GFKB2.csv")
bacData = read.csv("microbiome_data.csv")
genomeSizeList=read.csv("prokaryotes.csv")

#Add k12 abundance to p12b and then remove
k12Row=bacData[which(bacData$Organism_Meta_Data=="str_K12_substr_DH10B_complete_genome"), ]
p12bRow=bacData[which(bacData$Organism_Meta_Data=="P12b_complete_genome"), ]
p12bRow[,4:56]=p12bRow[,4:56]+k12Row[,4:56]
bacData[which(bacData$Organism_Meta_Data=="P12b_complete_genome"), ]=p12bRow
bacData=bacData[-which(bacData$Organism_Meta_Data=="str_K12_substr_DH10B_complete_genome"), ]
#Fetch the genome sizes we need and add to GFKB
overlap=intersect(GFKB$Assembly.ID..UP.matched., genomeSizeList$Assembly)
index=match(overlap,as.character(genomeSizeList$Assembly))
myGenomes=genomeSizeList[index,]
myGenomes=as.data.frame(cbind(as.character(myGenomes$Assembly), myGenomes$Size.Mb.))
colnames(myGenomes)=c("Assembly.ID..UP.matched.", "Size(Mb)")
myGenomes$`Size(Mb)`=as.character(myGenomes$`Size(Mb)`)
myGenomes$`Size(Mb)`=signif(as.double(as.character(myGenomes$`Size(Mb)`)), digits=4)
colnames(myGenomes)=c("Assembly.ID..UP.matched.", "Size(Mb)")
GFKB=left_join(GFKB, myGenomes)

#Reorder columns so Genome Size is in an appropriate place
GFKB=GFKB[,c(1,2,3,4,5,6,17,7,8,9,10,11,12,13,14,15,16)]

#Use Regular expressions to fetch the genBankIDs from epilepsy study
bacData = bacData[,1:48]
list = as.character(bacData$Organism_List)
genBankIDs=str_extract(list, "(([A-Z]){2}([0-9]{6}))")
genBankIDs=as.character(genBankIDs)
sortedGenBankIds=sort(genBankIDs)
sortedTableGenBankIds=sort(as.character(GFKB$GenBank.Accession))
numData=bacData[,4:48]

#Create the Unique ID by concatenating UP ID and GenBank Accession, separated by an underscore
uniqueID=paste(GFKB$UP.ID, GFKB$GenBank.Accession, sep="_")
GFKB=cbind(uniqueID,GFKB)
#Calculate stats for "Control before diet patients"
controlBeforeNumData=numData[,1:11]
controlBeforeNumData_IDs=tibble(genBankIDs, controlBeforeNumData)
controlBeforeNumData_IDs=controlBeforeNumData_IDs[order(controlBeforeNumData_IDs$genBankIDs), ]
controlBeforeNumData_IDs=controlBeforeNumData_IDs[, 2]
dataMatrix=as.matrix(controlBeforeNumData_IDs)
medians=rowMedians(dataMatrix)
means=rowMeans(dataMatrix)
stdDevs=rowSds(dataMatrix)
iqrs=rowIQRs(dataMatrix)
mins=rowMins(dataMatrix)
maxs=rowMaxs(dataMatrix)
ranges=maxs-mins
quantiles=rowQuantiles(dataMatrix)
controlBefore=as.tibble(cbind( medians, means, stdDevs, iqrs, ranges, quantiles))
colnames(controlBefore)=c("CA_Medians","CA_Means","CA_stdDevs","CA_iqrs","CA_ranges","CA_0%",
                          "CA_25%","CA_50%","CA_75%","CA_100%")

#Calculate stats for "Control after diet patients"
controlAfterNumData=numData[,12:21]
controlAfterNumData_IDs=tibble(genBankIDs, controlAfterNumData)
controlAfterNumData_IDs=controlAfterNumData_IDs[order(controlAfterNumData_IDs$genBankIDs), ]
controlAfterNumData_IDs=controlAfterNumData_IDs[, 2]
dataMatrix=as.matrix(controlAfterNumData_IDs)
medians=rowMedians(dataMatrix)
means=rowMeans(dataMatrix)
stdDevs=rowSds(dataMatrix)
iqrs=rowIQRs(dataMatrix)
mins=rowMins(dataMatrix)
maxs=rowMaxs(dataMatrix)
ranges=maxs-mins
quantiles=rowQuantiles(dataMatrix)
controlAfter=as.tibble(cbind(medians, means, stdDevs, iqrs, ranges, quantiles))
colnames(controlAfter)=c("CB_Medians","CB_Means","CB_stdDevs","CB_iqrs","CB_ranges","CB_0%",
                         "CB_25%","CB_50%","CB_75%","CB_100%")

#Calculate stats for "Patient before keto diet"
patientBeforeNumData=numData[,22:33]
patientBeforeNumData_IDs=tibble(genBankIDs, patientBeforeNumData)
patientBeforeNumData_IDs=patientBeforeNumData_IDs[order(patientBeforeNumData_IDs$genBankIDs), ]
patientBeforeNumData_IDs=patientBeforeNumData_IDs[, 2]
dataMatrix=as.matrix(patientBeforeNumData_IDs)
medians=rowMedians(dataMatrix)
means=rowMeans(dataMatrix)
stdDevs=rowSds(dataMatrix)
iqrs=rowIQRs(dataMatrix)
mins=rowMins(dataMatrix)
maxs=rowMaxs(dataMatrix)
ranges=maxs-mins
quantiles=rowQuantiles(dataMatrix)
patientBefore=as.tibble(cbind(medians, means, stdDevs, iqrs, ranges, quantiles))
colnames(patientBefore)=c("PA_Medians","PA_Means","PA_stdDevs","PA_iqrs","PA_ranges","PA_0%",
                          "PA_25%","PA_50%","PA_75%","PA_100%")

#Calculate stats for "Patient after keto diet"
patientAfterNumData=numData[,34:45]
patientAfterNumData_IDs=tibble(genBankIDs, patientAfterNumData)
patientAfterNumData_IDs=patientAfterNumData_IDs[order(patientAfterNumData_IDs$genBankIDs), ]
patientAfterNumData_IDs=patientAfterNumData_IDs[, 2]
dataMatrix=as.matrix(patientAfterNumData_IDs)
medians=rowMedians(dataMatrix)
means=rowMeans(dataMatrix)
stdDevs=rowSds(dataMatrix)
iqrs=rowIQRs(dataMatrix)
mins=rowMins(dataMatrix)
maxs=rowMaxs(dataMatrix)
ranges=maxs-mins
quantiles=rowQuantiles(dataMatrix)
patientAfter=as.tibble(cbind(medians, means, stdDevs, iqrs, ranges, quantiles))
colnames(patientAfter)=c("PB_Medians","PB_Means","PB_stdDevs","PB_iqrs","PB_ranges","PB_0%",
                         "PB_25%","PB_50%","PB_75%","PB_100%")

#Bind all columns together, assign column names
final=cbind(sortedGenBankIds, controlBefore, controlAfter, patientBefore, patientAfter)
colnames(final)=c("GenBank.Accession", "Median_Control_Before_Diet", "Mean_Control_Before_Diet",
                  "Standard_Deviation_Control_Before_Diet","Interquartile_Range_Control_Before_Diet",
                  "Range_Control_Before_Diet", "0%_Control_Before_Diet",
                  "25%_Control_Before_Diet", "50%_Control_Before_Diet",
                  "75%_Control_Before_Diet", "100%_Control_Before_Diet",
                  "Median_Control_After_Diet", "Mean_Control_After_Diet",
                  "Standard_Deviation_Control_After_Diet","Interquartile_Range_Control_After_Diet",
                  "Range_Control_After_Diet", "0%_Control_After_Diet",
                  "25%_Control_After_Diet", "50%_Control_After_Diet",
                  "75%_Control_After_Diet", "100%_Control_After_Diet",
                  "Median_Patient_Before_Diet", "Mean_Patient_Before_Diet",
                  "Standard_Deviation_Patient_Before_Diet","Interquartile_Range_Patient_Before_Diet",
                  "Range_Patient_Before_Diet", "0%_Patient_Before_Diet",
                  "25%_Patient_Before_Diet", "50%_Patient_Before_Diet",
                  "75%_Patient_Before_Diet", "100%_Patient_Before_Diet",
                  "Median_Patient_After_Diet", "Mean_Patient_After_Diet",
                  "Standard_Deviation_Patient_After_Diet","Interquartile_Range_Patient_After_Diet",
                  "Range_Patient_After_Diet", "0%_Patient_After_Diet",
                  "25%_Patient_After_Diet", "50%_Patient_After_Diet",
                  "75%_Patient_After_Diet", "100%_Patient_After_Diet")

#Join patient data with GFKB
final$GenBank.Accession=as.character(final$GenBank.Accession)
GFKB=GFKB[order(GFKB$GenBank.Accession), ]
finalJoined=left_join(GFKB, final)

#Write combined table to a csv file
tableWithData=write.csv(finalJoined, file="tableWithData.csv")

#Write sheets to separate csv files
sheet1=write.csv(finalJoined[,c(1:18)], file="Organisms.csv", row.names = FALSE)
sheet2=write.csv(finalJoined[,c(1,6,15,19:58)], file="Epilepsy.csv", row.names = FALSE)