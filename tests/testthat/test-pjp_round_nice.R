test_that("redondea con digits decimales fijos y sin ceros negativos", {
  expect_equal(
    pjp_round_nice(c(-0.0002, 0.0002, 0.5, -0.5, -0.002), digits = 3),
    c("0.000", "0.000", "0.500", "-0.500", "-0.002")
  )
})

test_that("por defecto usa 2 decimales", {
  expect_equal(pjp_round_nice(c(1, 1.234, -0.001)), c("1.00", "1.23", "0.00"))
})

test_that("con digits = 0 tampoco hay ceros negativos", {
  expect_equal(pjp_round_nice(c(-0.2, -1.6, 0.4), digits = 0), c("0", "-2", "0"))
})

test_that("no toca los negativos que no redondean a cero", {
  expect_equal(pjp_round_nice(c(-10.001, -0.05), digits = 1), c("-10.0", "-0.1"))
})

test_that("da error si x no es numérico", {
  expect_error(pjp_round_nice("1.2"), "numerico")
})

test_that("los NA se quedan como NA", {
  ss <- pjp_round_nice(c(1.234, NA))

  expect_equal(ss, c("1.23", NA))
  expect_true(is.na(ss[2]))
})

test_that("dec y big_mark cambian los separadores", {
  expect_equal(pjp_round_nice(1234567.891, dec = ",", big_mark = "."), "1.234.567,89")
  expect_equal(pjp_round_nice(-0.001, dec = ","), "0,00")
  expect_equal(pjp_round_nice(1234.5), "1234.50")
})

test_that("da error si digits no es un entero >= 0", {
  expect_error(pjp_round_nice(1, digits = -1), "entero")
  expect_error(pjp_round_nice(1, digits = 1.5), "entero")
  expect_error(pjp_round_nice(1, digits = NA), "entero")
  expect_error(pjp_round_nice(1, digits = "2"), "entero")
})
