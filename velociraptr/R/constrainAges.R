#' Constrain a dataset to only occurrences within a certain age-range
#'
#' Assign fossil occurrences to different intervals within a geologic timescale, then remove occurrences that are not temporally constrained to a single interval within that timescale.
#'
#' @param Data A data frame
#' @param Timescale A data frame
#'
#' @aliases constrainAges,multiplyAges
#'
#' @details Cull a paleobiology database data frame to only occurrences temporally constrained to be within a certain level of the geologic timescale (e.g., period, epoch). The geologic timescale should come from the Macrostrat database, but custom time-scales can be used if structured in the same way. See \code{downloadTime} for how to download a timescale.
#'
#' @author Andrew A. Zaffos
#'
#' @return A data frame
#'
#' @examples
#'
#'	# Download a test dataset of Cenozoic bivalves.
#'	DataPBDB<-downloadPBDB(Taxa="Bivalvia",StartInterval="Cenozoic",StopInterval="Cenozoic")
#'
#'  # Download the international epochs timescale from macrostrat.org
#'	Epochs<-downloadTime("international epochs")
#'
#'	# Find only occurrences that are temporally constrained to a single international epoch
#'	ConstrainedPBDB<-constrainAges(DataPBDB,Epochs)
#'
#'  # Create mutliple instances of a single occurrence for each epoch it occurs in
#'  MultipliedPBDB<-multiplyAges(DataPBDB,Epochs)
#'
#'	@rdname constrainAges
#'	@export
constrainAges<-function(Data,Timescale) {
	Data[,"early_interval"]<-as.character(Data[,"early_interval"])
	Data[,"late_interval"]<-as.character(Data[,"late_interval"])
	for (i in 1:nrow(Timescale)) {
		EarlyPos<-which(Data[,"max_ma"]>Timescale[i,"t_age"] & Data[,"max_ma"]<=Timescale[i,"b_age"])
		Data[EarlyPos,"early_interval"]<-as.character(Timescale[i,"name"])
		LatePos<-which(Data[,"min_ma"]>=Timescale[i,"t_age"] & Data[,"min_ma"]<Timescale[i,"b_age"])
		Data[LatePos,"late_interval"]<-as.character(Timescale[i,"name"])
		}
	Data<-Data[Data[,"early_interval"]==Data[,"late_interval"],] # Remove taxa that range through
	return(Data)
}
#'	@rdname constrainAges
#'	@export
# A variant of constrain ages that allows for multiple ages
# Assign fossil occurrences to multiple ages
multiplyAges<-function(Data,Timescale=Epochs) {
  Data[,"early_interval"]<-as.character(Data[,"early_interval"])
  Data[,"late_interval"]<-as.character(Data[,"late_interval"])
	for (i in 1:nrow(Timescale)) {
		EarlyPos<-which(Data[,"max_ma"]>Timescale[i,"t_age"] & Data[,"max_ma"]<=Timescale[i,"b_age"])
		Data[EarlyPos,"early_interval"]<-as.character(Timescale[i,"name"])
		LatePos<-which(Data[,"min_ma"]>=Timescale[i,"t_age"] & Data[,"min_ma"]<Timescale[i,"b_age"])
		Data[LatePos,"late_interval"]<-as.character(Timescale[i,"name"])
		}
	ConstrainedPBDB<-Data[Data[,"early_interval"]==Data[,"late_interval"],] # Find occurrences of single epoch
	UnconstrainedPBDB<-Data[Data[,"early_interval"]!=Data[,"late_interval"],] # Find occurrence not of a single epoch
	DuplicatePBDB<-UnconstrainedPBDB
	DuplicatePBDB[,"early_interval"]<-DuplicatePBDB[,"late_interval"]
	return(rbind(ConstrainedPBDB,UnconstrainedPBDB,DuplicatePBDB))
	}
