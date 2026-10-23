test_that("devuelve una fila por variable con las columnas esperadas", {
  ss <- pjp_estadisticos_basicos(iris)

  expect_equal(nrow(ss), ncol(iris))
  expect_equal(ss$variables, names(iris))
  expect_named(ss, c(
    "variables", "q_zeros", "p_zeros", "q_na", "p_na", "type", "nn_unique",
    "rango", "min", "max", "mean", "sd", "NN", "NN_ok"
  ))
})

test_that("cuenta ceros, NA y valores únicos (sin NA)", {
  aa <- data.frame(x = c(0, 0, 1, NA))
  ss <- pjp_estadisticos_basicos(aa)

  expect_equal(ss$q_zeros, 2)
  expect_equal(ss$p_zeros, 50)
  expect_equal(ss$q_na, 1)
  expect_equal(ss$p_na, 25)
  expect_equal(ss$nn_unique, 2)
  expect_equal(ss$NN, 4)
  expect_equal(ss$NN_ok, 3)
})

test_that("los ceros solo se cuentan en numéricas", {
  aa <- data.frame(chr = c("0", "a"), lg = c(FALSE, TRUE))
  ss <- pjp_estadisticos_basicos(aa)

  expect_equal(ss$q_zeros, c(NA_real_, NA_real_))
  expect_equal(ss$p_zeros, c(NA_real_, NA_real_))
})

test_that("calcula estadísticos solo para numéricas", {
  aa <- data.frame(x = c(1, 2, 4), chr = c("a", "b", "c"))
  ss <- pjp_estadisticos_basicos(aa)

  expect_equal(ss$min, c(1, NA))
  expect_equal(ss$max, c(4, NA))
  expect_equal(ss$mean, c(2.33, NA))
  expect_equal(ss$sd, c(round(stats::sd(c(1, 2, 4)), 2), NA))
  expect_equal(ss$type, c("numeric", "character"))
})

test_that("en las lógicas mean es la proporción de TRUE", {
  aa <- data.frame(lg = c(TRUE, TRUE, FALSE, NA))
  ss <- pjp_estadisticos_basicos(aa)

  expect_equal(ss$mean, 0.67)
  expect_true(is.na(ss$min))
  expect_true(is.na(ss$sd))
})

test_that("rango solo se rellena para fechas", {
  aa <- data.frame(
    fe = as.Date(c("2020-03-01", NA, "2020-01-01")),
    x = 1:3
  )
  ss <- pjp_estadisticos_basicos(aa)

  expect_equal(ss$rango, c("2020-01-01 / 2020-03-01", NA))
})

test_that("decimales controla el redondeo", {
  aa <- data.frame(x = c(1, 2, 4))

  expect_equal(pjp_estadisticos_basicos(aa, decimales = 3)$mean, 2.333)
  expect_equal(pjp_estadisticos_basicos(aa, decimales = 0)$mean, 2)
})

test_that("con 0 filas los porcentajes son NA, no NaN", {
  ss <- pjp_estadisticos_basicos(iris[0, 1:2])

  expect_equal(ss$p_zeros, c(NA_real_, NA_real_))
  expect_equal(ss$p_na, c(NA_real_, NA_real_))
})

test_that("una numérica toda NA da NA sin warnings", {
  aa <- data.frame(x = c(NA_real_, NA_real_))

  expect_no_warning(ss <- pjp_estadisticos_basicos(aa))
  expect_true(is.na(ss$min))
  expect_true(is.na(ss$max))
})

test_that("da error si no es un data frame", {
  expect_error(pjp_estadisticos_basicos(1:3), "data frame")
})
