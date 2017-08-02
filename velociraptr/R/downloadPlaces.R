#' Download Shapefile of Places
#'
#' Download a shapefile of a geolocation from the Macrostrat API's implementation of the Who's on First database by MapZen.
#'
#' @aliases trueWOF
#'
#' @param Place A character string; the name of a place
#' @param Type A character string; a type of place
#'
#' @details Download a shapefile of a geolocation from the \href{https://macrostrat.org}{Macrostrat} API. The Macrostrat database provides a GeoJSON of a particular location given the location's \code{name} and \code{type}. Type can be of the categories: \code{"continent"}, \code{"country"}, \code{"region"}, \code{"county"}, and \code{"locality"}.
#'
#' If multiple locations of the same type share the same name (e.g., Alexandria), the route will return a feature collection of all matching polygons.
#'
#' @return An rgdal compatible shapefile
#'
#' @author Andrew A. Zaffos
#'
#' @import rgdal
#'
#' @examples
#'
#' # Download a polygon of Dane County, Wisconsin, United States, North America
#' # DaneCounty<-downloadPlaces(Place="Dane",Type="county")
#'
#' # Download a polygon of Wisconsin, United States, North America
#' # Wisconsin<-downloadPlaces(Place="Wisconsin",Type="region")
#'
#' # Download a polygon of North America
#' # NorthAmerica<-downloadPlaces(Place="North America",Type="continent")
#'
#' @rdname downloadPlaces
#' @export
# Simple wrapper for the true function
downloadPlaces<-function(Place="Wisconsin",Type="region") {
  Type<-tolower(Type)
  Place<-gsub(" ","%20",Place)
  return(trueWOF(Place,Type))
  }

# We want to hide the /places route because we do not want people to attempt to download our entire dataset
trueWOF<-function(Place="Wisconsin",Type="region") {
  URL<-paste("https://macrostrat.org/api/places?format=geojson_bare&name=",Place,"&placetype=",Type,sep="")
  Map<-rgdal::readOGR(dsn=URL,"OGRGeoJSON",verbose=FALSE)
  return(Map)
  }
