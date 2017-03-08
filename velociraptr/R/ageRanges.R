#' Find the age range for each taxon in a dataframe
#'
#' Find the age range (first occurrence and last occurrence) for each taxon in a PBDB dataset. Can be run for any level of the taxonomic hierarchy (e.g., family, genus).
#'
#' @param Data A data frame downloaded from the paleobiology database API.
#' @param Taxonomy A characer string identifying the desired level of the taxonomic hierarchy.
#'
#' @details \code{rangeDiversity} converts the output of \code{ageRanges} into a vector of range-through richness in million year increments. Note that this function is hard-coded to the default field names from the paleobiology database.
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
	Data<-subset(Data,is.na(Data[,Taxonomy])!=TRUE) # Remove NA's
	Data[,Taxonomy]<-factor(Data[,Taxonomy]) # Drop hanging attributes
	PBDBEarly<-tapply(Data[,"max_ma"],Data[,Taxonomy],max) # Calculate max age
	PBDBLate<-tapply(Data[,"min_ma"],Data[,Taxonomy],min) # Calculate min age
	AgesPBDB<-cbind(PBDBEarly,PBDBLate) # Bind ages
	colnames(AgesPBDB)<-c("EarlyAge","LateAge")
	return(data.matrix(AgesPBDB))
	}
