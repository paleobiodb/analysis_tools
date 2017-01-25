#' Clean taxonomic names
#'
#' Removes NAs and subgenera from the genus column.
#'
#' @param Data A data frame of taxonomic ocurrences downloaded from the paleobiology database API.
#' @param Taxonomy A characer string
#'
#' @details Will remove NA's and subgenera from the genus column of a PBDB dataset. It can also be used on other datasets of similar structure to convert species names to genus, or remove NAs.
#'
#' @return Will return a data frame identical to the original, but with the genus column cleaned.
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'
#'	# Download a test dataset of Cenozoic bivalves.
#'	DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Cenozoic",StopInterval="Cenozoic")
#'
#'	# Clean up the genus column.
#'	CleanedPBDB<-cleanTaxonomy(DataPBDB,"genus")
#'
#'	@rdname cleanTaxonomy
#'	@export
# Find the min and max age range of a taxonomic ranking - e.g., genus.
cleanTaxonomy<-function(Data,Taxonomy="genus") {
	Data<-subset(Data,Data[,Taxonomy]!="") # Remove NAs
	Data<-subset(Data,is.na(Data[,Taxonomy])!=TRUE) # Remove NAs
	SpaceSeparated<-sapply(as.character(Data[,Taxonomy]),strsplit," ")
	Data[,Taxonomy]<-sapply(SpaceSeparated,function(S) S[1])
	return(Data)
	}
