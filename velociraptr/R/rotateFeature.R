#' Rotate A Geographic Feature
#'
#' Rotate a geographic rgdal polygon to its paleocoordinates
#'
#' @param Polygon An rgdal polygon
#' @param Age A numeric value; A whole number in millions of years
#'
#' @details Rotate a rgdal spatial object to its paleogeographic coordinates under an EarthByte rotation model using a custom data service powered by the Macrostrat and GPlates development teams. This is the same rotation model returned by default through the Paleobiology Database. The data service is, in principle, capable of rotating individual points or multiple features. However, this wrapper function will only accept a single feature.
#'
#' The rotation model used is Wright, N, S. Zahirovic, RD Müller, and M Seton (2013) "Towards community-driven, open-access paleogeographic reconstructions: integrating open-access paleogeographic and paleobiology data with plate tectonics" \emph{Biogeosciences} 10:1529-1541.
#'
#' @return An rgdal spatial object
#'
#' @author Andrew A. Zaffos
#'
#' @import rgdal
#'
#' @examples
#'
#' # Download a polygon of Dane County, Wisconsin, United States, North America
#' # DaneCounty<-downloadWOF(Place="Dane",Type="county")
#'
#' # Download a polygon of Wisconsin, United States, North America
#' # Wisconsin<-downloadWOF(Place="Wisconsin",Type="region")
#'
#' # Rotate Dane county to its position during the Danian stage (65 million years ago)
#' # DaneDanian<-rotateFeature(Polygon=DaneCounty,Age=65)
#'
#' @rdname rotateFeature
#' @export
# This is a jenky function that mostly calls to bash, because I couldn't figure out how to do it with RCurl
rotateFeature<-function(Polygon,Age=0) {
  PolygonPath<-paste0(tempdir(),"/Polygon.geojson")
  rgdal::writeOGR(Polygon,PolygonPath, layer="Polygon", driver="GeoJSON")
  options("useFancyQuotes"=FALSE)
  FileName<-dQuote("shape=<Polygon.geojson")
  AgeInput<-sQuote(paste0("age=",Age))
  QueryA<-paste("cd",tempdir(),sep=" ")
  QueryB<-paste("curl -X POST -F",FileName,"-F",AgeInput,"-F format=geojson_bare -o Polygon.geojson -- https://macrostrat.org/reconstruct",sep=" ")
  FinalQuery<-paste(QueryA,QueryB,sep=" && ")
  system(FinalQuery)
  RotatedFeature<-readOGR(PolygonPath,"OGRGeoJSON")
  return(RotatedFeature)
  }
