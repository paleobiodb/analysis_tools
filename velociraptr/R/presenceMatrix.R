#' Create a matrix of presences and absences
#'
#' Creates a community matrix of taxon presences and absences from a data frame with a column of sites and a column of species.
#'
#' @param Data A dataframe or matrix
#' @param Rows A characer string
#' @param Columns A character string
#'
#' @return A presence-absence matrix
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'
#' # Download a test dataset of pleistocene bivalves.
#' # DataPBDB<-downloadPBDB(Taxa="Bivalvia","Pleistocene","Pleistocene")
#'
#' # Create a community matrix of genera by plates.
#' # CommunityMatrix<-presenceMatrix(DataPBDB,Rows="geoplate",Columns="genus")
#'
#' # Create a community matrix of families by geologic interval.
#' # CommunityMatrix<-presenceMatrix(DataPBDB,Rows="early_interval",Columns="family")
#'
#' @rdname presenceMatrix
#' @export
presenceMatrix<-function(Data,Rows="geoplate",Columns="genus") {
	FinalMatrix<-matrix(0,nrow=length(unique(Data[,Rows])),ncol=length(unique(Data[,Columns])))
	rownames(FinalMatrix)<-unique(Data[,Rows])
	colnames(FinalMatrix)<-unique(Data[,Columns])
	ColumnPositions<-match(Data[,Columns],colnames(FinalMatrix))
	RowPositions<-match(Data[,Rows],rownames(FinalMatrix))
	Positions<-cbind(RowPositions,ColumnPositions)
	FinalMatrix[Positions]<-1
	return(FinalMatrix)
	}
