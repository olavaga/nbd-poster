#' Download pathogen.watch data
#'
#' Checks if a pathogenwatch file is present and downloads it when missing.
#' @param filename The name of the file you want to download (unzipped)
#' @param dirpath Optional path of the directory where you want to put it
download.pw <- function(filename, dirpath = "raw/") {
    require(R.utils)
    pathogen.watch.endpoint <- "https://pathogenwatch-public.ams3.cdn.digitaloceanspaces.com/"

	if (.Platform$OS.type == "windows") {
		download.method = "wininet"

	} else if (.Platform$OS.type == "unix") {
		download.method = "wget"

	} else {
		stop("Unknown Operating System")
	}

	if (!file.exists(paste0(dirpath,filename))) {
		dir.create(dirpath, showWarnings=FALSE)
		download.file(url=paste0(pathogen.watch.endpoint,filename,".gz"),
			      destfile=paste0(dirpath,filename,".gz"),
			      method=download.method)
		gunzip(paste0(dirpath,filename,".gz"))
	}
}

#download.pw("Klebsiella pneumoniae__kleborate.csv")
#download.pw("Klebsiella pneumoniae__metadata.csv")
