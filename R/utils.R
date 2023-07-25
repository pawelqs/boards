
'%not in%' <- function(x,y)!('%in%'(x,y))


msg <- function(...,
                collapse = "",
                col = "steelblue3",
                verbose = TRUE) {
  msg <- stringr::str_c(list(...), collapse = collapse)
  if (verbose) {
    cli::cat_line(msg, col = col)
  }
}
