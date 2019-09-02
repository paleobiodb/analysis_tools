PBDB Analysis Tools
=========

A directory of scripts that utilize the Paleobiology Database

#### Contents
[Getting started](#intro)  
[Submitting a script](#submissions)  
[List of scripts](#scripts)  


<a name="intro"></a>
## Getting started
If you are unfamiliar with using Git for version control, these are some good resources to get you started:

- [Pro Git](http://git-scm.com/book) by Scott Chacon
- [Think Like (a) Git](http://think-like-a-git.net/)
- [Git cheatsheet](http://cheat.errtheblog.com/s/git)
- [LearnGitBranching](http://pcottle.github.io/learnGitBranching/) - An interactive way to learn Git

<a name="submissions"></a>
## Submitting a script
Simply submit a pull request to this repo following the instructions below:

1. Click "Fork" in upper right corner of this page
2. You should now be at http://github.com/your_user_name/utilities. In the bottom right, copy the ````clone URL```` URL, and on your local machine open Terminal and type this, substituting your username for the placeholder:  ````git clone https://github.com/your_user_name/paleobiodb_utilities.git````
3. You now have a copy of this repository on your local machine. You can now open this file (````README.md````) and add your script. When you are done, save your changes.
4. Making sure you are in the correct directory, add, commit, and push your changes:

	````
	git add -u
	git commit -m "Added my script to the list"
	git push
	````
5. Go to https://github.com/your_user_name/paleobiodb_utilities/pulls and click "New pull request", and then "Create Pull Request". Write a note explaining the changes you made and click "Send pull request"! Once we get a chance to review your changes, they will show up on the list.


<a name="scripts"></a>
## Scripts
If you would like to add your script to this list, please refer to [submitting a script](#submissions) above. As more scripts are added, it may become necessary to organize by language or purpose.

```{r}
# Simple example to identify possibly problematic homonym genera (or duplicates
# or multiple listings of a genus, as occurs when there are subgenera) (written 
# by Phil Novack-Gottshall <pnovack-gottshall@ben.edu> 
which.gsg <- 
  which((pbdb$accepted_rank == "genus" | pbdb$accepted_rank == "subgenus") 
        & pbdb$difference == "")
sort(table(pbdb$accepted_name[which.gsg]), decreasing = TRUE)[1:20]
# Example (as of 9/1/2019, includes a homonym and likely duplicate entry):
pbdb[which(pbdb$accepted_name == "Lowenstamia"), ]
```

=========
### rOpenSci 
**Description**:  R interface to the Paleobiology Database API   
**Language**: R  
**Authors**: Sara Varela, Javier Gonzalez-Hernandez and Luciano Fabris Sgarbi   
**Project website**: http://ropensci.org   
**Code**: https://github.com/ropensci/paleobioDB   

#### Matthew Clapham's PBDB R scripts
**Description**:  Various R scripts that utilize the Paleobiology Database, including one to calculate the maximum great circle distance between any two occurrences of a taxon in a time interval   
**Language**: R  
**Author**: Matthew Clapham  
**Code**: https://github.com/mclapham/PBDB-R-scripts

#### Phil Novack-Gottshall's PBDB R scripts
**Description**:  Various R scripts that utilize the Paleobiology Database, including one to create a compact taxonomic structure and to check for homonyms or problematic duplicate genera   
**Language**: R  
**Author**: Phil Novack-Gottshall  
**Code**: https://github.com/pnovack-gottshall/PBDB-R-scripts



