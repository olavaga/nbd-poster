preprocess.kleborate <- function(kleborate.df) {
    selection <- colnames(kleborate.df)[endsWith(colnames(kleborate.df),
                                                     "_acquired")]

    resistance.df <- kleborate.df[, selection]
    colnames(resistance.df) <- gsub("_acquired","",colnames(resistance.df))
    selection <- colnames(resistance.df)

    resistance.df <- as.data.frame(apply(resistance.df,
                                         c(1,2),
                                         \(x) ifelse(x=="-", 0, 1)))
    return (resistance.df)
}
