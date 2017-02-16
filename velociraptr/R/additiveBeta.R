#' Additive Diversity Partitioning functions
#'
#' Functions for calculating alpha, beta, and gamma richness of a community matrix under the Additive Diversity partitioning paradigm of R. Lande.
#'
#' @param CommunityMatrix a matrix
#'
#' @aliases taxonAlpha,meanAlpha,taxonBeta,sampleBeta,totalGamma
#'
#' @details Takes a community matrix (see \code{presenceMatrix} or \code{abundanceMatrix}) and returns the either the alpha, beta, or gamma richness of a community matrix.
#'
#' These functions were originally presented in Holland, SM (2010) "Additive diversity partitioning in palaeobiology: revisiting Sepkoski’s question" \emph{Paleontology} 53:1237-1254.
#'
#'	\itemize{
##'  \item{\code{taxonAlpha(CommunityMatrix)}} {Calculates the contribution to alpha diversity of each taxon.}
##'  \item{\code{meanAlpha(CommunityMatrix)}} {Calculates the average alpha diversity of all samples.}
##'
##'  \item{\code{taxonBeta(CommunityMatrix)}} {Calculates the contribution to beta diversity of each taxon.}
##'	 \item{\code{sampleBeta(CommunityMatrix)}} {Calculates the contribution to beta diversity of each sample.}
##'  \item{\code{totalBeta(CommunityMatrix)}} {Calculates the total beta diversity.}
##'
##'	 \item{\code{totalGamma(CommunityMatrix)}} {Calculates the richness of all samples in the community matrix.}
##' }
#'
#' @return A vector of the alpha, beta, or gamma richness of a taxon, sample, or entire community matrix.
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'	# Download a test dataset of pleistocene bivalves.
#'	# DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Pleistocene",StopInterval="Pleistocene")
#'
#'	# Create a community matrix with tectonic plates as "samples"
#'	# CommunityMatrix<-abundanceMatrix(DataPBDB,"geoplate")
#'
#'	# Calculate the average richness of all samples in a community.
#'	# meanAlpha(CommunityMatrix)
#'
#'	# The beta diversity of all samples in a community.
#'	# totalBeta(CommunityMatrix)
#'
#'	# This is, by definition, equivalent to the gamma diversity - mean alpha diversity.
#'	# totalBeta(CommunityMatrix)==(totalGamma(CommunityMatrix)-meanAlpha(CommunityMatrix))
#'
#'	@rdname additiveBeta
#'	@export
# returns vector of each taxon’s contribution to alpha diversity
taxonAlpha <- function(CommunityMatrix) {
	Nj <- apply(CommunityMatrix, MARGIN=2, FUN=sum)
	Samples <- nrow(CommunityMatrix)
	Alphaj <- Nj/Samples
	names(Alphaj) <- colnames(CommunityMatrix)
	return(Alphaj)
	}

#'	@rdname additiveBeta
#'	@export
# returns mean alpha diversity of samples
meanAlpha <- function (CommunityMatrix) {
	return(sum(taxonAlpha(CommunityMatrix)))
	}

#'	@rdname additiveBeta
#'	@export
# returns vector of each taxon’s contribution to beta diversity
taxonBeta <- function(CommunityMatrix) {
	Nj <- apply(CommunityMatrix, MARGIN=2, FUN=sum)
	Samples <- nrow(CommunityMatrix)
	Betaj <- (Samples - Nj) / Samples
	names(Betaj) <- colnames(CommunityMatrix)
	return(Betaj)
	}

#'	@rdname additiveBeta
#'	@export
# returns vector of each sample’s contribution to beta diversity
sampleBeta <- function(CommunityMatrix) {
	Betaj <- taxonBeta(CommunityMatrix)
	Nj <- apply(CommunityMatrix, MARGIN=2, FUN=sum)
	NSamples <- nrow(CommunityMatrix)
	Betai <- vector(mode="numeric", length=NSamples)
	for (i in 1:NSamples) {
		Betai[i] <- sum(Betaj / Nj * CommunityMatrix[i, ])
		}
	names(Betai) <- rownames(CommunityMatrix)
	return(Betai)
	}

#'	@rdname additiveBeta
#'	@export
# returns beta diversity among samples
totalBeta <- function (CommunityMatrix) {
	return(sum(taxonBeta(CommunityMatrix)))
	}

#'	@rdname additiveBeta
#'	@export
# returns gamma diversity of all samples combined
totalGamma <- function(CommunityMatrix) {
	return(ncol(CommunityMatrix))
	}
