#' Download Occurrences from the Paleobiology Database
#'
#' Downloads a data frame of Paleobiology Database fossil occurrences.
#'
#' @param Taxa a character vector
#' @param StartInterval a character vector
#' @param StopInterval a character vector
#'
#' @details Downloads a data frame of Paleobiology Database fossil occurrences matching certain taxonomic groups and age range. This is simply a convenience function for rapid data download, and only returns the most generically useful fields. Go directly to the Paleobiology Database to make more complex searches or access additional fields. This function makes use of the RCurl package.
#'
#' \itemize{
##' \item{ocurrence_no:} {The Paleobiology Database occurrence number.}
##' \item{collection_no:} {The Paleobiology Database collection number.}
##' \item{reference_no:} {The Paleobiology Database reference number.}
##' \item{Classifications:} {The stated Linnean classification of the occurence from phylum through genus. See \code{cleanTaxonomy} for how to simplify these fields.}
##' \item{accepted_name:} {The highest resolution taxonomic name assigned to the occurrence.}
##' \item{Geologic Intervals:} {The earliest possible age of the occurrence and latest possible age of the occurrence, expressed in terms of geologic intervals. See \code{constrainAge} for how to simplify these fields.}
##' \item{Numeric Ages:} {The earliest possible age of the occurrence and latest possible age of the occurrence, expressed as millions of years ago.}
##' \item{Geolocation:} {Both present-day and rotated paleocoordinates of the occurrence. The geoplate id used by the rotation model is also included. The key for geoplate ids can be found in the Paleobiology Database API documentation.}
#'  }
#'
#' @return a data frame
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'
#'	# Download a test dataset of Maastrichtian bivalves.
#'	DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Maastrichtian",StopInterval="Maastrichtian")
#'
#'  # Download a test dataset of Ordovician-Silurian trilobites and brachiopods.
#'  DataPBDB<-downloadPBDB(Taxa=c("Trilobita","Brachiopoda"),StartInterval="Ordovician",StopInterval="Silurian")
#'
#'	@rdname downloadPBDB
#'	@export
# A function for downloading data from the Paleobiology database
downloadPBDB<-function(Taxa,StartInterval="Pliocene",StopInterval="Pleistocene") {
	Taxa<-paste(Taxa,collapse=",")
	URL<-paste("https://paleobiodb.org/data1.2/occs/list.csv?base_name=",Taxa,"&interval=",StartInterval,",",StopInterval,"&show=coords,paleoloc,phylo&limit=all",sep="")
	GotURL<-RCurl::getURL(URL)
	File<-read.csv(text=GotURL,header=TRUE)
	# Subset to include the most generically useful columns
	File<-File[,c("occurrence_no","collection_no","reference_no","phylum","class","order","family","genus","accepted_name","early_interval","late_interval","max_ma","min_ma","lng","lat","paleolng","paleolat","geoplate")]
	return(File)
	}
