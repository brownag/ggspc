test_that("ggplot dispatch on SoilProfileCollection works", {
  skip_if_not_installed("soilDB")

  data(loafercreek, package = "soilDB")
  aqp::GHL(loafercreek) <- "dspcomplayerid"
  x <- ggplot2::ggplot(loafercreek, ggplot2::aes(earthcovkind1, slope_field)) +
    ggplot2::geom_boxplot(na.rm = TRUE)
  expect_true(inherits(x, 'gg'))
})
