#' Adaptive Beta Functions
#'
#' Functions for placing confidence intervals on time of orignation or extinction using the Adaptive Beta Method.
#'
#' @param Ages a numeric vector of fossil occurrence ages, expressed as millions of years ago.
#' @param Confidence the desired confidence level
#'
#' @aliases adaptiveExtinction,adaptiveOrigination,thetaNegative,thetaPositive,lambdaNegative,lambdaPositive
#'
#' @details Takes a numeric vector of fossil occurrence ages, expressed as millions of years ago, to estimate either the time of origination \code{adaptiveOrigination} or extinction \code{adaptiveExtinction}.
#'
#' This code was originally presented in Wang et al. (2015) "Adaptive credible intervals on stratigraphic ranges when recovery potential is unknown". \emph{Paleobiology} 42:240-256.
#'
#' This simplified version will only accept ages in millions of years. The full version can be found in the online supplement to the paper.
#'
#' Note that this function will not accept more than 161 age observations. This is a limitation of the original function.
#'
#' @return A matrix listing the oldest or youngest observed fossil occurrence, the best inferred age of extinction or origination, and the upper confidence limit.
#'
#' @author Andrew A. Zaffos
#'
#' @examples
#' # Generate an exmaple dataset of fossil ages
#' FakeAges<-runif(50,50,100)
#'
#' # Calculate the inferred age of extinction with 95% confidence.
#' adaptiveExtinction(FakeAges,Confidence=0.95)
#'
#' # Calculate the inferred age of origination with 50% confidence.
#' adaptiveOrigination(FakeAges,Confidence=0.5)
#'
#' @rdname adaptiveConfidence
#' @export
# Calculates the adaptive beta method origination values
adaptiveOrigination<-function(Ages,Confidence=0.95) {
  # Perform initial scaling
  Base <- min(Ages)
  Ages <- Ages - Base
  Ages <- sort(Ages, decreasing=FALSE)[-1]   #   reduce sample size by 1
  # Scale data so theta is approx. 100 (solely for numerical stability)
  MaxAge <- max(Ages)
  SampleSize <- length(Ages)
  PreScale<-(SampleSize+1)/SampleSize * MaxAge
  ScalingFactor <- 100/PreScale
  Ages <- Ages * ScalingFactor
  MaxAge <- MaxAge * ScalingFactor

  # Constrain lambda and theta
  # There are a number of hard-coded theta and lambda parameter values provided by Wang et al. (2015)
  # Because the original abm38() function of Wang et al. (2015) does not allow these to be changed as arguments
  # I leave them hard-coded for consistency.
  LambdaValues<-seq(-10,10,length.out=40)
  LambdaDensity<-vector("numeric",length=40)
  ThetaValues<-seq(MaxAge,500,length.out=1000)
  ThetaDensity<-vector("numeric",length=1000)

    # increment lambda values, integrating over theta values for each
    for(i in 1:length(LambdaValues))  {
      LambdaDensity[i] <- ifelse(LambdaValues[i]<=0,
        stats::integrate(lambdaNegative, MaxAge,500, Lambda=LambdaValues[i],Ages)$value,
        stats::integrate(lambdaPositive, MaxAge,500, Lambda=LambdaValues[i],Ages)$value
        )
      }
    # Normalize lambda pdf to unit area
    LambdaDensity <- LambdaDensity/sum(LambdaDensity)
    Lambda <- sum(LambdaValues*LambdaDensity)

    # increment theta values, integrating over lambda values for each
    for(i in 1:length(ThetaValues))  {
      ThetaDensity[i] <- (stats::integrate(thetaNegative, -Inf,0, Theta=ThetaValues[i], Ages)$value + stats::integrate(thetaPositive, 0,Inf, Theta=ThetaValues[i], Ages)$value)
      }
    # normalize theta pdf to unit area
    ThetaDensity <- ThetaDensity/sum(ThetaDensity)
     # calculate posterior quantities
    ConfidenceCutoff <- which.max(cumsum(ThetaDensity) >= Confidence) # upper quantile of posterior
    UpperCI <- ThetaValues[ConfidenceCutoff]
    ThetaCutoff <- which.max(cumsum(ThetaDensity) >= .5 ) # posterior median
    Theta <- ThetaValues[ThetaCutoff]

  # Un-scale data back to original scale
  Theta <- Theta/ScalingFactor
  MaxAge <- MaxAge/ScalingFactor
  UpperCI <- UpperCI/ScalingFactor
  ThetaValues <- ThetaValues/ScalingFactor
  Theta <- Base + Theta
  MaxAge <- Base + MaxAge
  UpperCI <- Base + UpperCI

  # Return the results as a matrix
  FinalMatrix <- t(data.matrix(c(MaxAge, Theta, UpperCI)))
  colnames(FinalMatrix) <- c("Observed Age","Expected Value","Confidence Limit")
  return(FinalMatrix)
  }

#' @rdname adaptiveConfidence
#' @export
# Calculates the adaptive beta method origination values
adaptiveExtinction<-function(Ages,Confidence=0.95) {
  # Perform initial scaling
  Base <- max(Ages)
  Ages <- Base - Ages
  Ages <- sort(Ages, decreasing=FALSE)[-1]   #   reduce sample size by 1
  # Scale data so theta is approx. 100 (solely for numerical stability)
  MaxAge <- max(Ages)
  SampleSize <- length(Ages)
  PreScale<-(SampleSize+1)/SampleSize * MaxAge
  ScalingFactor <- 100/PreScale
  Ages <- Ages * ScalingFactor
  MaxAge <- MaxAge * ScalingFactor

  # Constrain lambda and theta
  # There are a number of hard-coded theta and lambda parameter values provided by Wang et al. (2015)
  # Because the original abm38() function of Wang et al. (2015) does not allow these to be changed as arguments
  # I leave them hard-coded for consistency.
  LambdaValues<-seq(-10,10,length.out=40)
  LambdaDensity<-vector("numeric",length=40)
  ThetaValues<-seq(MaxAge,500,length.out=1000)
  ThetaDensity<-vector("numeric",length=1000)

    # increment lambda values, integrating over theta values for each
    for(i in 1:length(LambdaValues))  {
      LambdaDensity[i] <- ifelse(LambdaValues[i]<=0,
        stats::integrate(lambdaNegative, MaxAge,500, Lambda=LambdaValues[i],Ages)$value,
        stats::integrate(lambdaPositive, MaxAge,500, Lambda=LambdaValues[i],Ages)$value
        )
      }
    # Normalize lambda pdf to unit area
    LambdaDensity <- LambdaDensity/sum(LambdaDensity)
    Lambda <- sum(LambdaValues*LambdaDensity)

    # increment theta values, integrating over lambda values for each
    for(i in 1:length(ThetaValues))  {
      ThetaDensity[i] <- (stats::integrate(thetaNegative, -Inf,0, Theta=ThetaValues[i], Ages)$value + stats::integrate(thetaPositive, 0,Inf, Theta=ThetaValues[i], Ages)$value)
      }
    # normalize theta pdf to unit area
    ThetaDensity <- ThetaDensity/sum(ThetaDensity)
     # calculate posterior quantities
    ConfidenceCutoff <- which.max(cumsum(ThetaDensity) >= Confidence) # upper quantile of posterior
    UpperCI <- ThetaValues[ConfidenceCutoff]
    ThetaCutoff <- which.max(cumsum(ThetaDensity) >= .5 ) # posterior median
    Theta <- ThetaValues[ThetaCutoff]

  # Un-scale data back to original scale
  Theta <- Theta/ScalingFactor
  MaxAge <- MaxAge/ScalingFactor
  UpperCI <- UpperCI/ScalingFactor
  ThetaValues <- ThetaValues/ScalingFactor
  Theta <- Base - Theta
  MaxAge <- Base - MaxAge
  UpperCI <- Base - UpperCI

  # Return the results as a matrix
  FinalMatrix <- t(data.matrix(c(MaxAge, Theta, UpperCI)))
  colnames(FinalMatrix) <- c("Observed Age","Expected Value","Confidence Limit")
  return(FinalMatrix)
  }

thetaNegative <- function(Lambda,Theta,Ages)  {
  FinalVector<-vector("numeric",length=length(Lambda))
  for(i in 1:length(Lambda)) {
    FinalVector[i]<-(sum(log((1-Lambda[i])/Theta * 1/(1-Ages/Theta)^Lambda[i])))
    }
  FinalVector<-FinalVector + stats::dnorm(Lambda,0,2,log=TRUE) + log(1/Theta) # Mean and sd are hard-coded by Wang et al. 2015
  return(exp(FinalVector))
  }

thetaPositive <- function(Lambda,Theta,Ages)  {
  FinalVector<-vector("numeric",length=length(Lambda))
  for(i in 1:length(Lambda)) {
    FinalVector[i] <- (sum(log((1+Lambda[i])/Theta*(Ages/Theta)^Lambda[i])))
    }
  FinalVector<-FinalVector + stats::dnorm(Lambda, 0,2, log=TRUE) + log(1/Theta) # Mean and sd are hard-coded by Wang et al. 2015
  return(exp(FinalVector))
  }

lambdaNegative <- function(Theta,Lambda,Ages)  {
  FinalVector<-vector("numeric",length=length(Theta))
  for(i in 1:length(Theta)) {
    FinalVector[i] <- (sum(log((1-Lambda)/Theta[i] * 1/(1-Ages/Theta[i])^Lambda)))
    }
  FinalVector <- FinalVector + stats::dnorm(Lambda, 0,2, log=TRUE) + log(1/Theta)
  return(exp(FinalVector))
  }

lambdaPositive <- function(Theta,Lambda,Ages)  {
  FinalVector<-vector("numeric",length=length(Theta))
  for(i in 1:length(Theta)) {
    FinalVector[i]<-(sum(log((1+Lambda)/Theta[i] * (Ages/Theta[i])^Lambda)))
    }
  FinalVector<-FinalVector + stats::dnorm(Lambda, 0,2, log=TRUE) + log(1/Theta)
  return(exp(FinalVector))
  }
