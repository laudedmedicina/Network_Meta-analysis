---
  title: "NMA (Balduzzi et al., 2023)"
author: "Muhammad M. Elsharkawy"
date: "2025-04-20"
output: pdf_document
---
  
  ```{r eval=FALSE, message=FALSE, warning=FALSE, paged.print=FALSE}
# Load the necessary libraries
library(netmeta)
library(readxl)

# Load the dataset
data <- read_excel("E:/Your path.xlsx", 
                   sheet = "Your sheet")

# View the dataset to understand its structure
# View dataset
print(data)

# Prepare pairwise comparisons
pw <- pairwise(treat = treatment,
               event = events,
               n = sample_size,
               studlab = study,
               data = data,
               sm = "OR")  # Odds Ratio

print(pw)
head(pw, 20)  # View the first 20 rows

# Identify sub-networks in the network
subnetworks <- netconnection(nma)

# Print the results to see the sub-networks
print(subnetworks)

#Perform the network meta-analysis
nma <- netmeta(TE, seTE, treat1, treat2, studlab, data = pw,
               sm = "OR", random = TRUE, reference.group = "IFN", small.values = "undesirable") #If the small values is positive= put desirable


# Network meta-analysis results
summary(nma)

# Plot network
png("netgraph.png", width = 3000, height = 2000, res = 300)  # High-res PNG
netgraph(nma, plastic=FALSE, points=TRUE, col="#599198", thickness="number.of.studies",
         lwd=2.7, cex.points = 4, offset=0.05, scale= 1.1, col.points = "#999999", seq="optimal")

dev.off()

# To generate forest plot to specific treatment
# be aware of reference that you want compare other intervention with


# Ordered forest plot p-score
png("forestplot.png", width = 3000, height = 2000, res = 300)  # High-res PNG
forest(nma, ref= "Your reference",  sortvar =-SUCRA,layout="BMJ",
       rightcols = c("effect", "ci", "pval","SUCRA"), pooled="common")

dev.off()

#Ranking of treatments
netrank(nma)

#Net rank and rankograms
set.seed(1909)
(ran1 <- rankogram(nma))

png("rankgram.png", width = 4500, height = 3000, res = 300)  # High-res PNG
plot(ran1, legend = TRUE)
dev.off()

netrank(ran1)

#A league table with random effects estimates (and without confidence limits to have a more concise printout in this article) sorted by decreasing P-scores is given by
league=netleague(nma, seq = netrank(nma), ci = TRUE, digits=2)
write.table(league$random, file = "league.csv",
            row.names = FALSE, col.names = FALSE, sep = ",")

#Evaluation of heterogeneity and inconsistency
decomp.design(nma)

#Inconsistency between direct and indirect evidence within each network estimate can be evaluated using the SIDE method
netsplit(nma)

#Heatmap
netheat(nma)
```

