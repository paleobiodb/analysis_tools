#' Find the age range for each taxon in a dataframe
#'
#' Find the age range (first occurrence and last occurrence) for each taxon in a PBDB dataset. Can be run for any level of the taxonomic hierarchy (e.g., family, genus).
#'
#' @param Data A data frame downloaded from the paleobiology database API.
#' @param Taxonomy A characer string identifying the desired level of the taxonomic hierarchy.
#'
#' @details Returns a data frame of that states gives the time of origination and extinction for each taxon as numeric values. Note that older versions of this function automatically dropped hanging factors and NA's, but that cleaning step should ideally be dictated by the user up-front. So that functionality has been dropped. This may introduce breaking chanes in legacy scripts, but is easily fixed by standard data cleaning steps.
#'
#' @return A numeric matrix of first and last ages for each taxon, with tax as rownames.
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'
#' # Download a test dataset of Cenozoic bivalves.
#' # DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Cenozoic",StopInterval="Cenozoic")
#'
#' # Find the first occurrence and last occurrence for all Cenozoic bivalves in DataPBDB
#' # AgeRanges<-ageRanges(DataPBDB,"genus")
#'
#' @rdname ageRanges
#' @export
# Find the min and max age range of a taxonomic ranking - e.g., genus.
ageRanges<-function(Data,Taxonomy="genus") {
	PBDBEarly<-tapply(Data[,"max_ma"],Data[,Taxonomy],max) # Calculate max age
	PBDBLate<-tapply(Data[,"min_ma"],Data[,Taxonomy],min) # Calculate min age
	AgesPBDB<-cbind(PBDBEarly,PBDBLate) # Bind ages
	colnames(AgesPBDB)<-c("EarlyAge","LateAge")
	return(data.matrix(AgesPBDB))
	}
