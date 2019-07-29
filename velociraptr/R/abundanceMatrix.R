#' Create a community matrix of taxon abundances
#'
#' Creates a community matrix of taxon abundances, with samples as rows and species as columns, from a data frame.
#'
#' @param Data A data.frame of taxonomic occurrences. Must have at least two columns. One column representing the samples, and one column representing the taxa.
#' @param Rows A characer string
#' @param Columns A character string
#'
#' @details Note that older versions of this function automatically checked for and removed hanging factors. However, this is something that should really be dictated by the user, and that step is no longer a part of the function. This is unlikely to introduce any breaking changes in older scripts, but we note it here for documentation purposes..
#'
#' @return A numeric matrix of taxon abundances. Samples as the rownames and species as the column names.
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'
#' # Download a test dataset of pleistocene bivalves.
#' # DataPBDB<-downloadPBDB(Taxa="Bivalvia", StartInterval="Pleistocene", StopInterval="Pleistocene")
#'
#' # Clean the genus column
#' # DataPBDB<-cleanTaxonomy(DataPBDB,"genus")
#'
#' # Create a community matrix of genera by tectonic plate id#
#' # CommunityMatrix<-abundanceMatrix(Data=DataPBDB, Rows="geoplate", Columns="genus")
#'
#' @rdname abundanceMatrix
#' @export
abundanceMatrix<-function(Data,Rows="geoplate",Columns="genus") {
	# This function previously removed hanging factors, but that is no longer included
	SamplesAbundances<-by(Data,Data[,Rows],function(x) table(x[,Columns]))
	FinalMatrix<-sapply(SamplesAbundances,data.matrix)
	rownames(FinalMatrix)<-sort(unique((Data[,Columns])))
	return(t(FinalMatrix))
	}
