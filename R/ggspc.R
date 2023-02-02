if (!isGeneric("fortify"))
  setGeneric("fortify", ggplot2::fortify)

#' Fortify Method for SoilProfileCollections
#'
#' Called by `ggplot2::ggplot()`
#'
#' @param model a SoilProfileCollection
#' @param data not used
#' @param ... not used
#' @export
#' @return A data.frame
#' @importFrom ggplot2 fortify
#' @importFrom data.table data.table
fortify.SoilProfileCollection <- function(model, data, ...) {
  h <- aqp::horizons(model)
  res <- as.data.frame(merge(data.table::data.table(h), aqp::site(model), by = idname(model)))
  assign('SPC', model, envir = ggspc.env)
  res
}

#' @export
ggspc.env <- new.env()
