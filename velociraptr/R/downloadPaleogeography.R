#' Downloads paleogeographic maps
#'
#' Download a paleogeographic map for an age expressed in millions of years ago.
#'
#' @param Age A whole number up to 550
#'
#' @details Downloads a map of paleocontinents for a specific age from Macrostrat.org as a shapefile. The given age must be expressed as a whole number. Note that the function makes use of the rgdal and RCurl packages.
#'
#' @author Andrew A. Zaffos
#'
#' @return An rgdal compatible shapefile
#'
#' @examples
#'
#'	# Download a test dataset of Maastrichtian bivalves.
#'	# DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Maastrichtian",StopInterval="Maastrichtian")
#'
#'	# Download a paleogeographic map.
#'	# KTBoundary<-downloadPaleogeography(Age=66)
#'
#'	# Plot the paleogeographic map (uses rgdal) and the PBDB points.
#'	# plot(KTBoundary,col="grey")
#'	# points(x=DataPBDB[,"paleolng"],y=DataPBDB[,"paleolat"],pch=16,cex=2)
#'
#'	@rdname downloadPaleogeography
#'	@export
# download maps of paleocontinents from Macrostrat
downloadPaleogeography<-function(Age=0) {
	URL<-paste("https://macrostrat.org/api/paleogeography?format=geojson_bare&age=",Age,sep="")
	GotURL<-RCurl::getURL(URL)
	Map<-rgdal::readOGR(GotURL,"OGRGeoJSON",verbose=FALSE)
	return(Map)
	}
