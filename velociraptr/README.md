# velociraptr
R Functions for downloading, cleaning, culling, or analyzing fossil data from the Paleobiology Database. Developed and maintained by [Andrew Zaffos](https://macrostrat.org) as part of the [Paleobiology Database](https://paleobiodb.org) and [Macrostrat Database](https://macrostrat.org) tech development initiatives at the University of Wisconsin - Madison.

The following is a list of functions included in the package and basic descriptions of what they do. See the internal help files for further information on usage - e.g., ````?downloadPBDB````.

# Contents
## Installation
For RStudio users, the best way to install this package directly from GitHub is by using the `devtools` package.

````R
devtools::install_github("paleobiodb/paleobiodb_utilities",subdir="velociraptr")
````

## Download Functions
+ [````downloadPBDB( )````](#downloadpbdb-)
+ [````downloadTime( )````](#downloadtime-)
+ [````downloadPaleogeography( )````](#downloadpaleogeography-)

## Cleaning and Culling Functions
+ [````constrainAges( )````](#constrainages-)
+ [````multiplyAges( )````](#multiplyages-)
+ [````ageRanges( )````](#ageranges-)
+ [````cleanTaxonomy( )````](#cleantaxonomy-)
+ [````cullMatrix( )````](#cullmatrix-)

## Reshaping Functions
+ [````presenceMatrix( )````](#presencematrix-)
+ [````abundanceMatrix( )````](#abundancematrix-)

## Diversity Functions
+ [````subsampleIndividuals( )````](#subsampleindividuals-)
+ [````subsampleEvenness( )````](#subsampleevenness-)
+ [````taxonAlpha( )````](#taxonalpha-)
+ [````meanAlpha( )````](#meanalpha-)
+ [````taxonBeta( )````](#taxonbeta-)
+ [````sampleBeta( )````](#samplebeta-)
+ [````totalBeta( )````](#totalbeta-)
+ [````multiplicativeBeta( )````](#multiplicativebeta-)
+ [````completeTurnovers( )````](#completeturnovers-)
+ [````notEndemic( )`````](#notendemic-)
+ [````totalGamma( )````](#totalgamma-)

## Confidence Interval Functions
+ [````uniformExtinction( )````](#uniformextinction-)
+ [````uniformOrigination( )````](#uniformorigination-)
+ [````adaptiveExtinction( )````](#adaptiveextinction-)
+ [````adaptiveOrigination( )````](#adaptiveorigination-)

### downloadPBDB( )
Downloads a data frame of Paleobiology Database fossil occurrences.

### downloadTime( )
Downloads a geologic timescale from the [Macrostrat.org](www.macrostrat.org) database.

### downloadPaleogeography( )
Download a paleogeographic map for an age expressed as millions of years ago from the [Macrostrat.org](www.macrostrat.org) database.

### constrainAges( )
Assign fossil occurrences to different intervals within a geologic timescale, then remove occurrences that are not temporally constrained to a single interval within that timescale.

### multiplyAges( )
Create mutliple instances of a single occurrence for each geologic interval it occurs in.

### ageRanges( )
Find the age range (first occurrence and last occurrence) for each taxon in a PBDB dataset. Can be run for any level of the taxonomic hierarchy (e.g., family, genus).

### cleanTaxonomy( )
Removes NAs and subgenera from a taxonomic column.

### cullMatrix( )
Functions for recursively culling community matrices of rare taxa and depauperate samples.

### presenceMatrix( )
Creates a community matrix of taxon presences and absences from a data frame with a column of "sites" and a column of "species".

### abundanceMatrix( )
Creates a community matrix of taxon abundances, with "sites" as rows and "species" as columns, from a data frame.

### subsampleIndividuals( )
Calculate the richness of a sample after subsampling to a set number of individuals.

### subsampleEvenness( )
Calculate the richness of a sample after subsampling based on the evenness of the abundance distribution.

### taxonAlpha( )
Calculates the contribution to alpha diversity of each taxon in a communiy matrix using the additive diversity partitioning paradigm.

### meanAlpha( )
Calculates the alpha diversity of a community matrix.

### taxonBeta( )
Calculates the contribution to beta diversity of each taxon in a community matrix using the additive diversity partitioning paradigm.

### taxonBeta( )
Calculates the contribution to beta diversity of each sample in a community matrix using the additive diversity partitioning paradigm.

### totalBeta( )
Calculates the beta diversity of a community matrix using the additive diversity partitioning paradigm.

### multiplicativeBeta( )
Calculates the beta diversity of a community matrix using the multiplicative paradigm.

### completeTurnovers( )
Calculates Whittaker's effective species turnover, the number of complete effective species turnovers among samples in the dataset. 

### notEndemic( )
Proportional effective species turnover, the proportion of species in the community matrix not limited to a single sample - i.e., the proportion of "non-endemic" taxa.

### totalGamma( )
Calculates the gamma diversity of a community matrix.

### uniformExtinction( )
Places a confidence interval on time of extinction using the Strauss and Sadler method.

### uniformOrigination( )
Places a confidence interval on time of origination using the Strauss and Sadler method.

### adaptiveExtinction( )
Places a confidence interval on time of extinction using the Adaptive Beta Method.

### adaptiveOrigination( )
Places a confidence interval on time of origination using the Adaptive Beta Method.
