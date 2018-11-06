#' Download geologic timescale
#'
#' Downloads a geologic timescale from the Macrostrat.org database.
#'
#' @param Timescale character string; a recognized timescale in the Macrostrat.org database
#'
#' @details Downloads a recognized timescale from the Macrostrat.org database. This includes the name, minimum age, maximum age, midpoint age, and official International Commission on Stratigraphy color hexcode if applicable of each interval in the timescale.  Go to https://macrostrat.org/api/defs/timescales?all for a list of recognized timescales.
#'
#' @return A data frame
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#'
#' # Download the ICS recognized periods timescale
#' Timescale<-downloadTime(Timescale="international periods")
#'
#' @rdname downloadTime
#' @export
# Download timescales from Macrostrat
downloadTime<-function(Timescale="interational epochs") {
	Timescale<-gsub(" ","%20",Timescale)
	URL<-paste0("https://macrostrat.org/api/v2/defs/intervals?format=csv&timescale=",Timescale)
	Intervals<-utils::read.csv(URL,header=TRUE)
	Midpoint<-apply(Intervals[,c("t_age","b_age")],1,stats::median)
	Intervals<-cbind(Intervals,Midpoint)
	rownames(Intervals)<-Intervals[,"name"]
	return(Intervals)
	}
