if (!isGeneric("fortify"))
  setGeneric("fortify", ggplot2::fortify)

#' Fortify Method for SoilProfileCollection
#'
#' Called by `ggplot2::ggplot()`
#'
#' @param model a SoilProfileCollection
#' @param data not used
#' @param ... not used
#' @export
#' @return A data.frame
#' @importFrom ggplot2 fortify
fortify.SoilProfileCollection <- function(model, data, ...) {
  .spc_fortify(model, data, ...)
}

#' @importFrom tibble as_tibble
#' @importFrom data.table data.table
#' @importFrom aqp site horizons idname
.spc_fortify <- function(model, ...) {
  h <- aqp::horizons(model)
  res <- tibble::as_tibble(merge(data.table::data.table(h), aqp::site(model), by = aqp::idname(model)))
  assign('SPC', model, envir = ggspc.env)
  res
}

if (!isGeneric("ggplot"))
  setGeneric("ggplot", ggplot2::ggplot)

#' ggplot S3 method for SoilProfileCollection objects
#'
#' Makes ggplot aesthetics aware of SoilProfileCollection metadata.
#'
#' @param data A `SoilProfileCollection`
#' @param mapping Default `ggplot2::aes()`
#' @param ... Additional arguments passed to `ggplot.default()` (not used)
#' @param environment Default: `parent.frame()`
#' @return `gg` object from `ggplot2` package
#' @export
#' @importFrom aqp idname
#' @importFrom utils modifyList
ggplot.SoilProfileCollection <- function(data, mapping = ggplot2::aes(),
                                         ..., environment = parent.frame()) {
  if (!requireNamespace("ggplot2"))
    stop("package 'ggplot2' is required", call. = FALSE)

  # aesthetics injection
  # TODO: abstract method for modifying aes to include a SPC column name/internal name pair
  if (!"y" %in% names(mapping)) {
    # default y aesthetic is the "idname" from SPC
    y <- as.symbol(aqp::idname(data))
    mapping <- utils::modifyList(mapping, ggplot2::aes(y = {{y}}))
  }

  # pass through "fortified" data.frame to default method
  ggplot(data = .spc_fortify(data), mapping = mapping, ..., environment = environment)
}

#' @export
ggspc.env <- new.env()
