#' Uniform Confidence Intervals
#'
#' Estimate a confidence interval on time of extinction or origination when assuming a uniform probability of collection.
#'
#' @param Ages a numeric vector of fossil occurrence ages, expressed as millions of years ago.
#' @param Confidence the desired confidence level
#'
#' @aliases uniformExtinction,uniformOrigination
#'
#' @details Takes a numeric vector of fossil occurrence ages, expressed as millions of years ago, to estimate either the time of origination \code{uniformOrigination} or extinction \code{uniformExtinction}.
#' This code uses Marshall's adaptation of the function by Strauss and Sadler.
#'
#' Marshall, C.R. (1990) "Confidence intervals on stratigraphic ranges" \emph{Paleobiology} 16:1-10.
#'
#' @return A matrix listing the earliest and latest estimate for extinction or origination.
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#' # Generate an exmaple dataset of fossil ages
#' FakeAges<-runif(50,50,100)
#'
#' # Calculate the inferred age of extinction with 95% confidence.
#' uniformExtinction(FakeAges,Confidence=0.95)
#'
#' # Calculate the inferred age of origination with 50% confidence.
#' uniformOrigination(FakeAges,Confidence=0.5)
#'
#' @rdname uniformConfidence
#' @export
# From Marshall's (1990) adaptation of Strauss and Sadler.
# Brackets the extinction date
uniformExtinction <- function(Ages, Confidence=0.95)  {
    # Find the number of unique "Horizons"
    NumOccurrences<-length(unique(Ages))-1
    Alpha<-((1-Confidence)^(-1/NumOccurrences))-1
    Lower<-min(Ages)
    Upper<-min(Ages)-(Alpha*10)
    return(stats::setNames(c(Lower,Upper),c("Earliest","Latest")))
    }

#' @rdname uniformConfidence
#' @export
uniformOrigination <- function(Ages, Confidence=0.95)  {
  # Find the number of unique "Horizons"
  NumOccurrences<-length(unique(Ages))-1
  Alpha<-((1-Confidence)^(-1/NumOccurrences))-1
  Latest<-max(Ages)
  Earliest<-max(Ages)+(Alpha*10)
  return(stats::setNames(c(Earliest,Latest),c("Earliest","Latest")))
  }
