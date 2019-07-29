#' Download fixed-latitude equal-area grid
#'
#' Download an equal-area grid of the world with fixed latitudinal spacing and variable longitudinal spacing.
#'
#' @param LatSpacing Number of degrees desired between latitudinal bands
#' @param CellArea Desired target area of the cells in km^2 as a character string
#'
#' @details Downloads an equal-area grid with fixed latitudinal spacing and variable longitudinal spacing. The distance between longitudinal borders of grids will adjust to the target area size within each band of latitude. The algorithm will adjust the area of the grids to ensure that the total surface of the globe is covered.
#'
#' @author Andrew A. Zaffos
#'
#' @return A simple features object
#'
#' @examples
#'
#' # Download an equal area grid with 10 degree latitudinal spacing and 1,000,000 km^2 grids
#' # EqualArea<-fixedLatitude(LatSpacing=10,CellArea="1000000")
#'
#' @rdname fixedLatitude
#' @export
# Download an equal-area grid map into R
# Fixed latitudinal width in degrees, Target cell size in km2
# Must pass as character string instead of numeric to avoid R converting to scientific notation
fixedLatitude<-function(LatSpacing=5,CellArea="500000") {
  URL<-paste0("https://macrostrat.org/api/grids/longitude?format=geojson_bare&latSpacing=",LatSpacing,"&cellArea=",CellArea)
  return(sf::st_read(URL))
  }
