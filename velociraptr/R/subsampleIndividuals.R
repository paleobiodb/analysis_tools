#' Iterative Rarefaction
#'
#' Calculate the richness of a sample after subsampling to a set number of individuals.
#'
#' @param Abundance A vector of taxon abundances
#' @param Quota A whole number stating the desired sample size
#' @param Trials Number of iterations
#'
#' @return A numeric value of estimated richness
#'
#' @author Andrew A. Zaffos
#'
#' @details
#'
#' @examples
#'
#'	# Download a test dataset of Miocene-Pleistocene bivalves
#'	DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Miocene",StopInterval="Pleistocene")
#'
#'  # Clean up the taxonomy by removing subgenus designation
#'  DataPBDB<-cleanTaxonomy(DataPBDB,"genus")
#'
#'	# Create a community matrix of genera by tectonic plate ids
#'	CommunityMatrix<-abundanceMatrix(DataPBDB,Rows="geoplate",Columns="genus")
#'
#'	# Cull out depauperate samples and rare taxa
#'	CommunityCull<-cullMatrix(CommunityMatrix,5,100)
#'
#'	# Calculate the standardized richness of each plate assuming a fixed sample size of 100 occurrences
#'	StandardizedRichness<-apply(CommunityCull,1,subsampleIndividuals,100)
#'
#'	@rdname subsampleIndividuals
#'	@export
# A function for resampling by a fixed number of individuals
subsampleIndividuals<-function(Abundance,Quota,Trials=100) {
	Richness<-vector("numeric",length=Trials)
	Abundance<-Abundance[Abundance>0]
	Pool<-rep(1:length(Abundance),times=Abundance)
	if (sum(Abundance) < Quota) {
		print("Fewer Individuals than Quota")
		return(length(unique(Pool)))
		}
	for (i in 1:Trials) {
		Subsample<-sample(Pool,Quota,replace=FALSE)
		Richness[i]<-length(unique(Subsample))
		}
	return(mean(Richness))
	}

# A variant of subsamplingIndividuals() that resamples with replacement
# for any samples that have diversities below the Quota.
# A function for resampling by a fixed number of individuals.
# This allows for diversity to be lower than the Quota.
# This is a non-standard procedure that is not recommended for general use.
resampleIndividuals<-function(Abundance,Quota,Trials=100) {
	Richness<-vector("numeric",length=Trials)
	Abundance<-Abundance[Abundance>0]
	Pool<-rep(1:length(Abundance),times=Abundance)
	if (sum(Abundance) < Quota) {
		for (i in 1:Trials) {
			Subsample<-sample(Pool,Quota,replace=TRUE)
			Richness[i]<-length(unique(Subsample))
			}
		return(mean(Richness))
		}
	for (i in 1:Trials) {
		Subsample<-sample(Pool,Quota,replace=FALSE)
		Richness[i]<-length(unique(Subsample))
		}
	return(mean(Richness))
	}
