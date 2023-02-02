StatDepthWeighted <- ggplot2::ggproto("StatDepthWeighted", ggplot2::Stat,
  setup_params = function(self, data, params) {
    self$FUN <- params$FUN
    self$SPC <- params$SPC
    params
  },
  setup_data = function(self, data, params) {
    # print(head(data, 1))
    data
  },
  compute_layer = function(self, data, scales, e) {

    # take mean of aes x for each group y
    res <- do.call('rbind', lapply(split(data, data[["y"]]), function(d)
                              data.frame(
                                x = self$FUN(d[["x"]], d[[".thk"]], na.rm = TRUE),
                                y = d[["y"]]
                              )))
    # need a default y (idname) for "point" geom
    # TODO: need to handle panels/facets
    res$PANEL <- 1
    res
  },
  compute_group = function(self, data, scales, spc, FUN) {

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
#'
#' @return A `ggplot2::layer()` (a combination of data, Stat and `geom` with a potential position adjustment)
#' @importFrom ggplot2 layer ggproto
#' @export
stat_depth_weighted <- function(mapping = NULL,
                                data = NULL,
                                geom = "point",
                                position = "identity",
                                na.rm = FALSE,
                                show.legend = NA,
                                inherit.aes = TRUE,
                                FUN = weighted.mean,
                                ...) {

  # access SPC from ggspc plotting environment
  spc <- get('SPC', envir = ggspc.env)

  ggplot2::layer(
    stat = StatDepthWeighted,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    # function, SPC, and any additional arguments passed as parameters
    params = list(na.rm = na.rm, FUN = FUN, spc = spc, ...)
  )
}

