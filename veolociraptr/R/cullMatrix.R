#' Cull rare taxa and depauperate samples
#'
#' Functions for recursively culling community matrices of rare taxa and depauperate samples.
#'
#' @param CommunityMatrix a matrix
#' @param Rarity a whole number
#' @param Richness a whole number
#' @param Silent logical
#'
#' @aliases cullMatrix,errorMatrix,culltaxa,cullSamples,occurrencesFlag,diversityFlag,softCull,softTaxa,softSamples
#'
#' @details Takes a community matrix (see \code{presenceMatrix} or \code{abundanceMatrix}) and removes all samples with fewer than a certain number of taxa and all taxa that occur below a certain threshold of samples. The function operates recursively, and will check to see if removing a rare taxon drops a sampe below the input minimum richness and vice-versa. This means that it is possible to eliminate all taxa and samples if the rarity and richness minimums are too high. If the \code{Silent} argument is set to \code{FALSE} the function will throw an error and print a warning if no taxa or samples are left after culling. If \code{Silent} is set to \code{TRUE} the function will simply return \code{NULL}. The latter case is useful if many matrices are being culled as a part of a loop, and you do not want to break the loop with an error.
#'
#' These functions originally appeared in the R script appendix of Holland, S.M. and A. Zaffos (2011) "Niche conservatism along an onshore-offshore gradient". \emph{Paleobiology} 37:270-286.
#'
#' @return A community matrix with depauperate samples and rare taxa removed.
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#' # Download a test dataset of pleistocene bivalves.
#' DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Pleistocene",StopInterval="Pleistocene")
#'
#' # Create a community matrix with tectonic plates as "samples".
#' CommunityMatrix<-abundanceMatrix(DataPBDB,"geoplate")
#'
#' # Remove taxa that occur in less than 5 samples and samples with fewer than 25 taxa.
#' cullMatrix(CommunityMatrix,Rarity=5,Richness=25,Silent=FALSE)
#'
#' @rdname cullMatrix
#' @export
# A macro for culling community matrices of depauperate samples and rare taxa
cullMatrix <- function(CommunityMatrix,Rarity=2,Richness=2,Silent=FALSE) {
	if (Silent==TRUE) {
		FinalMatrix<-softCull(CommunityMatrix,MinOccurrences=Rarity,MinRichness=Richness)
		}
	else {
		FinalMatrix<-errorMatrix(CommunityMatrix,MinOccurrences=Rarity,MinRichness=Richness)
		}
	return(FinalMatrix)
	}

# Steve Holland's Culling Functions
errorMatrix <- function(CommunityMatrix, MinOccurrences=2, MinRichness=2) {
	FinalMatrix <- CommunityMatrix
	while (diversityFlag(FinalMatrix, MinRichness) | occurrencesFlag(FinalMatrix, MinOccurrences)) {
		FinalMatrix <- cullTaxa(FinalMatrix, MinOccurrences)
		FinalMatrix <- cullSamples(FinalMatrix, MinRichness)
		}
	return(FinalMatrix)
	}

# Dependency of cullMatrix()
cullTaxa <- function(CommunityMatrix, MinOccurrences) {
	PA <- CommunityMatrix
 	PA[PA>0] <- 1
 	Occurrences <- apply(PA, MARGIN=2, FUN=sum)
 	AboveMinimum <- Occurrences >= MinOccurrences
 	FinalMatrix <- CommunityMatrix[ ,AboveMinimum]
 	if (length(FinalMatrix)==0) {print("no taxa left!")}
 	return(FinalMatrix)
	}

# Dependency of cullMatrix()
cullSamples <- function(CommunityMatrix, MinRichness) {
	PA <- CommunityMatrix
 	PA[PA>0] <- 1
 	Richness <- apply(PA, MARGIN=1, FUN=sum)
 	AboveMinimum <- Richness >= MinRichness
 	FinalMatrix <- CommunityMatrix[AboveMinimum, ]
 	if (length(FinalMatrix[,1])==0) {print("no samples left!")}
 	return(FinalMatrix)
	}

# Dependency of cullMatrix()
occurrencesFlag <- function(CommunityMatrix, MinOccurrences) {
  	PA <- CommunityMatrix
 	PA[PA>0] <- 1
 	Occurrences <- apply(PA, MARGIN=2, FUN=sum)
 	if (min(Occurrences) < MinOccurrences) {
 		Flag <- 1
 		}
 	else {
	 	Flag <- 0
 		}
 	return(Flag)
	}

# Dependency of cullMatrix()
diversityFlag <- function(CommunityMatrix, MinRichness) {
 	PA <- CommunityMatrix
 	PA[PA>0] <- 1
 	Richness <- apply(PA, MARGIN=1, FUN=sum)
 	if (min(Richness) < MinRichness) {
 		Flag <- 1
 		}
 	else {
 		Flag <- 0
 		}
 	return(Flag)
	}

# Alternative to cullMatrix( ) that does not thrown an error, but returns a single NA
softCull <- function(CommunityMatrix, MinOccurrences=2, MinRichness=2) {
	NewMatrix <- CommunityMatrix
	while (diversityFlag(NewMatrix, MinRichness) | occurrencesFlag(NewMatrix, MinOccurrences)) {
		NewMatrix <- softTaxa(NewMatrix, MinOccurrences)
		if (length(NewMatrix)==1) {
			return(NA)
			}
		NewMatrix <- softSamples(NewMatrix, MinRichness)
		if (length(NewMatrix)==1) {
			return(NA)
			}
		}
	return(NewMatrix)
	}

# Dependency of softCull()
softTaxa <- function(CommunityMatrix, MinOccurrences) {
	PA <- CommunityMatrix
 	PA[PA>0] <- 1
 	Occurrences <- apply(PA, MARGIN=2, FUN=sum)
 	AboveMinimum <- Occurrences >= MinOccurrences
 	FinalMatrix <- CommunityMatrix[ ,AboveMinimum]
 	if (length(FinalMatrix)==0) {
 		FinalMatrix<-NA;
 		return(NA)
 		}
 	return(FinalMatrix)
	}

# Dependency of softCull()
softSamples <- function(CommunityMatrix, MinRichness) {
	PA <- CommunityMatrix
 	PA[PA>0] <- 1
 	Richness <- apply(PA, MARGIN=1, FUN=sum)
 	AboveMinimum <- Richness >= MinRichness
 	FinalMatrix <- CommunityMatrix[AboveMinimum, ]
 	if (length(FinalMatrix[,1])==0) {
 		FinalMatrix<-NA;
 		return(NA)
 		}
 	return(FinalMatrix)
	}
