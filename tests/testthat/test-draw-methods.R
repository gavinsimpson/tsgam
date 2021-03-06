## Test draw() methods

## load packages
library("testthat")
library("tsgam")
library("mgcv")
library("ggplot2")
theme_set(theme_grey())

context("draw-methods")

test_that("draw.evaluated_1d_smooth() plots the smooth", {
    set.seed(1)
    dat <- gamSim(1, n = 400, dist = "normal", scale = 2, verbose = FALSE)
    m1 <- gam(y ~ s(x0) + s(x1) + s(x2) + s(x3), data = dat, method = "REML")
    sm <- evaluate_smooth(m1, "s(x2)")
    vdiffr::expect_doppelganger("draw 1d smooth for selected smooth", draw(sm))
})

test_that("draw.evaluated_2d_smooth() plots the smooth & SE", {
    set.seed(1)
    dat <- gamSim(2, n = 4000, dist = "normal", scale = 1, verbose = FALSE)
    m2 <- gam(y ~ s(x, z, k = 40), data = dat$data, method = "REML")
    sm <- evaluate_smooth(m2, "s(x,z)", n = 100)
    vdiffr::expect_doppelganger("draw 2d smooth", draw(sm))
    vdiffr::expect_doppelganger("draw std error of 2d smooth", draw(sm, show = "se"))
})

test_that("draw.gam() plots a simple multi-smooth AM", {
    set.seed(1)
    dat <- gamSim(1, n = 400, dist = "normal", scale = 2, verbose = FALSE)
    m1 <- gam(y ~ s(x0) + s(x1) + s(x2) + s(x3), data = dat, method = "REML")
    vdiffr::expect_doppelganger("draw simple multi-smooth AM", draw(m1))
    vdiffr::expect_doppelganger("draw simple multi-smooth AM with fixed scales",
                                draw(m1, scales = "fixed"))
})

test_that("draw.gam() plots an AM with a single 2d smooth", {
    set.seed(1)
    dat <- gamSim(2, n = 4000, dist = "normal", scale = 1, verbose = FALSE)
    m2 <- gam(y ~ s(x, z, k = 30), data = dat$data, method = "REML")
    vdiffr::expect_doppelganger("draw AM with 2d smooth", draw(m2))
})

test_that("draw.gam() plots an AM with a single factor by-variable smooth", {
    set.seed(1)
    dat <- gamSim(4, verbose = FALSE)
    m3 <- gam(y ~ fac + s(x2, by = fac) + s(x0), data = dat)
    vdiffr::expect_doppelganger("draw AM with factor by-variable smooth",
                                draw(m3))
    vdiffr::expect_doppelganger("draw AM with factor by-variable smooth with fixed scales",
                                draw(m3, scales = "fixed"))
})

## simulate date from y = f(x2)*x1 + error
dat <- gamSim(3, n = 400, verbose = FALSE)
mod <- gam(y ~ s(x2, by = x1), data = dat)

test_that("draw() works with continuous by", {
    vdiffr::expect_doppelganger("draw AM with continuous by-variable smooth",
                                draw(mod))
})

test_that("draw() works with continuous by and fixed scales", {
    vdiffr::expect_doppelganger("draw AM with continuous by-variable smooth with fixed scale",
                                draw(mod, scales = "fixed"))
})
