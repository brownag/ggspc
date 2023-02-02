StatDepthWeighted <- ggplot2::ggproto("StatDepthWeighted", ggplot2::Stat,
  setup_params = function(self, data, params) {
    params
  },
  setup_data = function(self, data, params) {
    self$FUN <- params$FUN
    self$SPC <- params$spc
    self$GEOM <- params$geom
    if (is.symbol(params$from)) {
      self$FROM <- self$SPC[[deparse(params$from)]]
    } else {
      self$FROM <- params$from
    }
    if (is.symbol(params$to)) {
      self$TO <- self$SPC[[deparse(params$to)]]
    } else {
      self$TO <- params$to
    }
    # crds <- aqp::metadata(self$SPC)$coordinates
    data$.id <- aqp::horizons(self$SPC)[[aqp::idname(self$SPC)]]
    data$.hzid <- aqp::hzID(self$SPC)
    s <- trunc(self$SPC, self$FROM, self$TO)
    data <- data[which(data[[".hzid"]] %in% aqp::hzID(s)), ]
    hzd <- aqp::horizonDepths(s)
    data$.top <- s[[hzd[1]]]
    data$.bottom <- s[[hzd[2]]]
    data$.thk <- data$.bottom - data$.top
    data$.hzd <- s[[aqp::hzdesgnname(s)]]
    data$.tex <- s[[aqp::hztexclname(s)]]
    data$.ghl <- s[[aqp::GHL(s)]]
    data
  },
  compute_layer = function(self, data, scales, e) {
    # take mean of aes x for each group y
      res <- do.call('rbind', lapply(split(data, data[["y"]]), function(d)
          data.frame(
            x = self$FUN(d[["x"]], d[[".thk"]], na.rm = TRUE),
            y = d[["y"]]
          )))
    # TODO: need to handle panels/facets
    res$PANEL <- 1
    res
  },
  compute_group = function(self, data, scales, spc, geom, FUN, from, to) {

    # we override compute_layer, a higher-level function in the ggproto stack

    # do nothing
    data
  },
  required_aes = c("x")
)

#' `stat_depth_weighted()`: applies depth (thickness) weighted functions
#'
#' A `ggplot2`-style layer using the `StatDepthWeighted` statistic
#'
#' @param mapping Aesthetic mapping constructed via `ggplot2::aes()`
#' @param data A `SoilProfileCollection`
#' @param geom Default: "point"
#' @param position Default: `"identity"`
#' @param na.rm Default: `FALSE`
#' @param show.legend Default: `NA`
#' @param inherit.aes Default: `TRUE`
#' @param FUN A function. First argument is values, second argument is weights. Should accept `na.rm` argument. Default: `weighted.mean()`
#' @param ... additional arguments passed as parameters to `ggplot2::layer()`
#' @param from Top depth of weighted function interval. Default: `0`.
#' @param to Bottom depth of weighted function interval. Default: `200`.
#'
#' @return A `ggplot2::layer()` (a combination of data, Stat and `geom` with a potential position adjustment)
#' @importFrom ggplot2 layer ggproto
#' @importFrom stats weighted.mean
#' @export
stat_depth_weighted <- function(mapping = NULL,
                                data = NULL,
                                geom = "point",
                                position = "identity",
                                na.rm = FALSE,
                                show.legend = NA,
                                inherit.aes = TRUE,
                                FUN = stats::weighted.mean,
                                from = 0, to = 200,
                                ...) {

  # TODO: consider options for geom, position

  # access SPC from ggspc plotting environment to pass as parameter
  spc <- get('SPC', envir = ggspc.env)

  from <- substitute(from)
  to <- substitute(to)

  ggplot2::layer(
    stat = StatDepthWeighted,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    # function, SPC, and any additional arguments passed as parameters
    params = list(na.rm = na.rm, FUN = FUN, from = from, to = to, spc = spc, geom = geom, ...)
  )
}

