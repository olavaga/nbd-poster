require.multiple <- function(package.list, message="failed to load.") {
    failFlag <- FALSE
    for (package in package.list) {
        success <- require(package, character.only = TRUE)
        if (!success) {
            failFlag <- TRUE
            print(paste(package, message))
        }
    }
    
    return (failFlag)
}
