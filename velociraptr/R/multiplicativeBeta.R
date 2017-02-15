#' Multiplicative Diversity Partitioning
#'
#' Calculates beta diversity under various Multiplicative Diversity Partitioning paradigms.
#'
#' @param CommunityMatrix a matrix
#'
#' @aliases multiplicativeBeta,completeTurnovers,notEndemic
#'
#' @details Takes a community matrix (see \code{presenceMatrix} or \code{abundanceMatrix}) and returns one of three types of multiplicative beta diversity discussed in Tuomisto, H (2010) "A diversity of beta diversities: straightening up a concept gone awry. Part 1. Defining beta diversity as a function of alpha and gamma diversity". \emph{Ecography} 33:2-22.
#'	\itemize{
##'  \item{\code{multiplicativeBeta(CommunityMatrix):}} {Calculates the original beta diversity ratio - Gamma/Alpha. It quantifies how many times as rich gamma is than alpha.}
##'  \item{\code{completeTurnovers(CommunityMatrix):}} {The number of complete effective species turnovers observed among compositonal units in the dataset - (Gamma-Alpha)/Alpha.}
##'  \item{\code{notEndemic(CommunityMatrix):}} {The proportion of taxa in the dataset not limited to a single sample - (Gamma-Alpha)/Gamma}
##' }
#'
#' @return A numeric vector
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'	# Download a test dataset of pleistocene bivalves from the Paleobiology Database.
#'	# DataPBDB<-downloadPBDB(Taxa="Bivalvia","Pleistocene","Pleistocene")
#'
#'	# Create a community matrix with tectonic plates as "samples".
#'	# CommunityMatrix<-abundanceMatrix(DataPBDB,"geoplate")
#'
#'	# "True local diversity ratio"
#'	# multiplicativeBeta(CommunityMatrix)
#'
#'	# Whittaker's effective species turnover
#'	# completeTurnovers(CommunityMatrix)
#'
#'	# Proportional effective species turnover
#'	# notEndemic(CommunityMatrix)
#'
#'	@rdname multiplicativeBeta
#'	@export
# returns vector of each taxon’s contribution to alpha diversity
# "True local diversity ratio" of Tuomisto 2010
# This quantifies how many times as rich effective species gamma is than alpha
multiplicativeBeta<-function(CommunityMatrix) {
	Alpha<-meanAlpha(CommunityMatrix)
	Gamma<-totalGamma(CommunityMatrix)
	Beta<-Gamma/Alpha
	return(Beta)
	}

#'	@rdname multiplicativeBeta
#'	@export
# Whittaker's effective species turnover, the number of complete effective species
# turnovers among compositional units in the dataset
completeTurnovers<-function(CommunityMatrix) {
	Alpha<-meanAlpha(CommunityMatrix)
	Gamma<-totalGamma(CommunityMatrix)
	Beta<-(Gamma-Alpha)/Alpha
	return(Beta)
	}

#'	@rdname multiplicativeBeta
#'	@export
# Proportional effective species turnover, the proporition of species in the region
# not limited to a single sample - i.e., the proportion of non-endemic taxa.
notEndemic<-function(CommunityMatrix) {
	Alpha<-meanAlpha(CommunityMatrix)
	Gamma<-totalGamma(CommunityMatrix)
	Beta<-(Gamma-Alpha)/Gamma
	return(Beta)
	}
