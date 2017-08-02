# velociraptr
R Functions for downloading, cleaning, culling, or analyzing fossil data from the Paleobiology Database. Developed and maintained by [Andrew Zaffos](https://macrostrat.org) as part of the [Paleobiology Database](https://paleobiodb.org) and [Macrostrat Database](https://macrostrat.org) tech development initiatives at the University of Wisconsin - Madison.

The following is a list of functions included in the package and basic descriptions of what they do. See the internal help files for further information on usage - e.g., ````?downloadPBDB````.

# Contents
## Download Functions
+ [`downloadPBDB( )`](#downloadpbdb-)
+ [`downloadTime( )`](#downloadtime-)
+ [`downloadPaleogeography( )`](#downloadpaleogeography-)
+ [`downloadPlaces( )`](#downloadplaces-)

## Cleaning and Culling Functions
+ [`constrainAges( )`](#constrainages-)
+ [`multiplyAges( )`](#multiplyages-)
+ [`ageRanges( )`](#ageranges-)
+ [`cleanTaxonomy( )`](#cleantaxonomy-)
+ [`cullMatrix( )`](#cullmatrix-)

## Reshaping Functions
+ [`presenceMatrix( )`](#presencematrix-)
+ [`abundanceMatrix( )`](#abundancematrix-)

## Diversity Functions
+ [`subsampleIndividuals( )`](#subsampleindividuals-)
+ [`subsampleEvenness( )`](#subsampleevenness-)
+ [`taxonAlpha( )`](#taxonalpha-)
+ [`meanAlpha( )`](#meanalpha-)
+ [`taxonBeta( )`](#taxonbeta-)
+ [`sampleBeta( )`](#samplebeta-)
+ [`totalBeta( )`](#totalbeta-)
+ [`multiplicativeBeta( )`](#multiplicativebeta-)
+ [`completeTurnovers( )`](#completeturnovers-)
+ [`notEndemic( )`](#notendemic-)
+ [`totalGamma( )`](#totalgamma-)

## Confidence Interval Functions
+ [`uniformExtinction( )`](#uniformextinction-)
+ [`uniformOrigination( )`](#uniformorigination-)
+ [`adaptiveExtinction( )`](#adaptiveextinction-)
+ [`adaptiveOrigination( )`](#adaptiveorigination-)

## Change Log
+ [V1.1-Notes](#v1.1-notes)

### downloadPBDB( )
Downloads a data frame of Paleobiology Database fossil occurrences matching certain taxonomic groups and age range. This is simply a convenience function for rapid data download, and only returns the most generically useful fields. Go directly to the [Paleobiology Database](www.paleobiodb.org) to make more complex searches or access additional fields.

````R
# Download a test dataset of Ypresian bivalves.
# DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Ypresian",StopInterval="Ypresian")

# Download a test dataset of Ordovician-Silurian trilobites and brachiopods.
# DataPBDB<-downloadPBDB(c("Trilobita","Brachiopoda"),"Ordovician","Silurian")
````

### downloadTime( )
Downloads a recognized timescale from the [Macrostrat.org](www.macrostrat.org) database. This includes the name, minimum age, maximum age, midpoint age, and official International Commission on Stratigraphy color hexcode, if applicable, of each interval in the timescale. 

The list of recognized international timescales is as follow:
+ international
+ international ages
+ international epochs
+ international periods
+ international eras
+ international eons

You can see a complete list of offered timescales (including some regional and biostratigrpahic timescales) on the [Macrostrat website](https://macrostrat.org/api/defs/timescales?all).

````R
# Download the ICS recognized periods timescale
Timescale<-downloadTime(Timescale="international periods")
````

### downloadPaleogeography( )
Downloads a map of paleocontinents for a specific age from Macrostrat.org as an R spatial object (`sp`). The given age must be expressed as a whole number.

````R
# Download a test dataset of Maastrichtian bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Maastrichtian",StopInterval="Maastrichtian")

# Download a paleogeographic map.
KTBoundary<-downloadPaleogeography(Age=66)

Plot the paleogeographic map (uses rgdal) and the PBDB points.
plot(KTBoundary,col="grey")
points(x=DataPBDB[,"paleolng"],y=DataPBDB[,"paleolat"],pch=16,cex=2)
````

### downloadPlaces( )
Download a shapefile of a geolocation from the Macrostrat API. The [Macrostrat database](www.macrostrat.org) provides a GeoJSON of a particular location given the location's name and type. Type can be of the categories: "continent", "country", "region", "county", and "locality".

If multiple locations of the same type share the same name (e.g., Alexandria), the route will return a feature collection of all matching polygons.

````R
# Download a polygon of Dane County, Wisconsin, United States, North America
DaneCounty<-downloadPlaces(Place="Dane",Type="county")

# Download a polygon of Wisconsin, United States, North America
Wisconsin<-downloadPlaces(Place="Wisconsin",Type="region")

# Download a polygon of North America
NorthAmerica<-downloadPlaces(Place="North America",Type="continent")
````

### constrainAges( )
Cull a paleobiology database data frame to only occurrences temporally constrained to be within a certain level of the geologic timescale (e.g., period, epoch). The geologic timescale should come from the Macrostrat database, but custom time-scales can be used if structured in the same way. See [`downloadTime`](#downloadtime-) for how to download a timescale.

````R
# Download a test dataset of Cenozoic bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Cenozoic",StopInterval="Cenozoic")

# Download the international epochs timescale from macrostrat.org
Epochs<-downloadTime("international epochs")

# Find only occurrences that are temporally constrained to a single international epoch
ConstrainedPBDB<-constrainAges(DataPBDB,Timescale=Epochs)
````

### multiplyAges( )
Create mutliple instances of a single occurrence for each geologic interval it occurs in. The geologic timescale should come from the Macrostrat database, but custom time-scales can be used if structured in the same way. See [`downloadTime`](#downloadtime-) for how to download a timescale.

````R
# Download a test dataset of Cenozoic bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Cenozoic",StopInterval="Cenozoic")

# Download the international epochs timescale from macrostrat.org
Epochs<-downloadTime("international epochs")

# Create mutliple instances of a single occurrence for each epoch it occurs in
MultipliedPBDB<-multiplyAges(DataPBDB,Timescale=Epochs)
````

### ageRanges( )
Find the age range (first occurrence and last occurrence) for each taxon in a PBDB dataset. Can be run for any level of the taxonomic hierarchy (e.g., family, genus).

````R
# Download a test dataset of Cenozoic bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Cenozoic",StopInterval="Cenozoic")

# Find the first occurrence and last occurrence for all Cenozoic bivalves in DataPBDB
AgeRanges<-ageRanges(DataPBDB,"genus")
````

### cleanTaxonomy( )
Will remove NA's and subgenera from the genus column of a PBDB dataset. It can also be used on other datasets of similar structure to convert species names to genus, or remove NAs.

````R
# Download a test dataset of Cenozoic bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Cenozoic",StopInterval="Cenozoic")

# Clean up the genus column.
CleanedPBDB<-cleanTaxonomy(DataPBDB,"genus")
````

### cullMatrix( )
Takes a community matrix (see [`presenceMatrix`](#abundancematrix-) or [`abundanceMatrix`](#presencematrix-)) and removes all samples with fewer than a certain number of taxa and all taxa that occur below a certain threshold of samples. The function operates recursively, and will check to see if removing a rare taxon drops a sampe below the input minimum richness and vice-versa. This means that it is possible to eliminate all taxa and samples if the rarity and richness minimums are too high. If the `Silent` argument is set to `FALSE` the function will throw an error and print a warning if no taxa or samples are left after culling. If `Silent` is set to `TRUE` the function will simply return `NULL`. The latter case is useful if many matrices are being culled as a part of a loop, and you do not want to break the loop with an error.

### presenceMatrix( )
Creates a community matrix of taxon presences and absences from a data frame with a column of "sites" and a column of "species".

````R
# Download a test dataset of pleistocene bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia","Pleistocene","Pleistocene")

# Create a community matrix of genera by plates.
CommunityMatrix<-presenceMatrix(DataPBDB,Rows="geoplate",Columns="genus")

# Create a community matrix of families by geologic interval.
CommunityMatrix<-presenceMatrix(DataPBDB,Rows="early_interval",Columns="family")
````

### abundanceMatrix( )
Creates a community matrix of taxon abundances, with "sites" as rows and "species" as columns, from a data frame.

````R
# Download a test dataset of pleistocene bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia", StartInterval="Pleistocene", StopInterval="Pleistocene")

# Clean the genus column
DataPBDB<-cleanTaxonomy(DataPBDB,"genus")

# Create a community matrix of genera by tectonic plate id#
CommunityMatrix<-abundanceMatrix(Data=DataPBDB, Rows="geoplate", Columns="genus")
````

### subsampleIndividuals( )
Calculate the richness of a sample after subsampling to a set number of individuals (often called "classical rarefaction"). This is an empirical approach to subsampling a vector of taxonomic abundances to a set number of abundances. It uses a bootstrapping approach rather than the more common analytical solution provided in other packages.

````R
# Download a test dataset of Miocene-Pleistocene bivalves
DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Miocene",StopInterval="Pleistocene")

# Clean up the taxonomy by removing subgenus designation
DataPBDB<-cleanTaxonomy(DataPBDB,"genus")

# Create a community matrix of genera by tectonic plate ids
CommunityMatrix<-abundanceMatrix(DataPBDB,Rows="geoplate",Columns="genus")

# Cull out depauperate samples and rare taxa
CommunityCull<-cullMatrix(CommunityMatrix,5,100)

# Calculate the standardized richness of each plate assuming a fixed sample size of 100 occurrences
StandardizedRichness<-apply(CommunityCull,1,subsampleIndividuals,100)
````

### subsampleEvenness( )
Calculate the richness of a sample after subsampling based on the evenness of the abundance distribution (often called "shareholder quorum subsampling").

````R
# Download a test dataset of Miocene-Pleistocene bivalves.
DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Miocene",StopInterval="Pleistocene")

# Clean up the taxonomy by removing subgenus designation
DataPBDB<-cleanTaxonomy(DataPBDB,"genus")

# Create a community matrix of genera by tectonic plate ids.
CommunityMatrix<-abundanceMatrix(DataPBDB,Rows="geoplate",Columns="genus")

# Cull out depauperate samples and rare taxa
CommunityCull<-cullMatrix(CommunityMatrix,5,100)

# Calculate the standardized richness of each plate at a quota of 0.5.
StandardizedRichness<-apply(CommunityCull,1,subsampleEvenness,0.5)
````

### taxonAlpha( )
Calculates the contribution to alpha diversity of each taxon in a communiy matrix using the additive diversity partitioning paradigm.

### meanAlpha( )
Calculates the alpha diversity of a community matrix.

### taxonBeta( )
Calculates the contribution to beta diversity of each taxon in a community matrix using the additive diversity partitioning paradigm.

### sampleBeta( )
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
Takes a numeric vector of fossil occurrence ages, expressed as millions of years ago, to estimate the time of extinction using Marshall's (1990) adaptation of the function by Strauss and Sadler.

````R
# Generate an exmaple dataset of fossil ages
FakeAges<-runif(50,50,100)

# Calculate the inferred age of extinction with 95% confidence.
uniformExtinction(FakeAges,Confidence=0.95)
````

### uniformOrigination( )
Takes a numeric vector of fossil occurrence ages, expressed as millions of years ago, to estimate the time of origination using Marshall's (1990) adaptation of the function by Strauss and Sadler.

````R
# Generate an exmaple dataset of fossil ages
FakeAges<-runif(50,50,100)

# Calculate the inferred age of extinction with 95% confidence.
uniformOrigination(FakeAges,Confidence=0.95)
````

### adaptiveExtinction( )
Takes a numeric vector of fossil occurrence ages, expressed as millions of years ago, to estimate either the time of extinction.

````R
# Generate an exmaple dataset of fossil ages
FakeAges<-runif(50,50,100)

# Calculate the inferred age of extinction with 95% confidence.
adaptiveExtinction(FakeAges,Confidence=0.95)
````

### adaptiveOrigination( )
Takes a numeric vector of fossil occurrence ages, expressed as millions of years ago, to estimate either the time of origination.

````R
# Generate an exmaple dataset of fossil ages
FakeAges<-runif(50,50,100)

# Calculate the inferred age of origination with 50% confidence.
adaptiveOrigination(FakeAges,Confidence=0.5)
````