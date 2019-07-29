# velociraptr 2.0
R Functions for downloading, cleaning, culling, or analyzing fossil data from the Paleobiology Database. Developed and maintained by [Andrew Zaffos](www.azstrata.org) as part of the [Paleobiology Database](https://paleobiodb.org) and [Macrostrat Database](https://macrostrat.org) tech development initiatives at the University of Wisconsin - Madison.

## Changes in 2.0
### Several of the dependency functions have changed. 

1. [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html) dependency has been dropped thanks to changes in how base handles
https
2. [rgdal](https://cran.r-project.org/web/packages/rgdal/index.html) has been replaced with [sf](https://github.com/r-spatial/sf)

### Several functions have been removed because they can be found in other packages.

1. `subsampleIndividuals()` Has been removed and can be replaced with `vegan::rarefy()`
2. `subsampleEvenness()` Has been removed and can be replaced with `SSDCS::sqs()`
3. `adaptiveBeta()` Has been removed. More thorough code can be found in the supplementary materials of the [original paper](https://www.cambridge.org/core/journals/paleobiology/article/adaptive-credible-intervals-on-stratigraphic-ranges-when-recovery-potential-is-unknown/4009B4FBBE8F6BA1AE67F5E8F1E52C6E)

### Miscellaneous changes

1. Beta diversity functions now enforce a presence-absence matrix if provided an abundance matrix.
2. Dropped several hard-coded data cleaning steps that removed NA's and hanging factors from various functions. This *may* introduce breaking changes to some scripts, but these sorts of cleaning decisions should be made expicitly by users rather than be implicit in these functions.
3. `downloadPBDB()` now supports spaces in interval names - e.g., `"Early Triassic"`
