# stats.R
StatPSCSWeightedAverage <- ggplot2::ggproto("StatPSCSWeightedAverage", ggplot2::Stat,
                                            compute_group = function(data, scales) {
                                              spc <- get('SPC', envir = ggspc.env)
                                              pscs_bdys <- aqp::estimatePSCS(spc)
                                              horizons(trunc(spc, pscs_bdys$pscs_top, pscs_bdys$pscs_bottom))
                                            },
                                            required_aes = c("x")
)

#' `stat_pscs_wtd()`
#'
#' A `ggplot2`-style layer using the `StatPSCSWeightedAverage` statistic
#'
#' @param mapping mapping
#' @param data a SoilProfileCollection
#' @param geom default: point
#' @param position default: identity
#' @param na.rm default: false
#' @param show.legend default: NA
#' @param inherit.aes default: TRUE
#' @param ... additonal arguments passed as parameters to `ggplot2::layer()`
#' @return A `ggplot2::layer()` (a combination of data, Stat and `geom` with a potential position adjustment)
#' @importFrom ggplot2 layer ggproto
#' @export
stat_pscs_wtd <- function(mapping = NULL,
                          data = NULL,
                          geom = "boxplot",
                          position = "identity",
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE,
                          ...) {
  ggplot2::layer(
    stat = StatPSCSWeightedAverage,
    data = data,
    mapping = mapping,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

