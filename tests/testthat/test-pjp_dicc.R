test_that("devuelve una fila por variable con las columnas esperadas", {
  ss <- pjp_dicc(iris)

  expect_equal(ss$variables, names(iris))
  expect_named(ss, c(
    "variables", "type", "nn_unique", "unique_values", "q_na", "p_na",
    "q_zeros", "p_zeros", "rango", "min", "max", "mean", "sd", "NN", "NN_ok"
  ))
})

test_that("combina bien estadísticos y valores únicos", {
  aa <- data.frame(x = c(1, 2, NA), chr = c("a", "a", "b"))
  ss <- pjp_dicc(aa)

  expect_equal(ss$nn_unique, c(2, 2))
  expect_equal(ss$unique_values, c("1 - 2", "a - b"))
  expect_equal(ss$q_na, c(1, 0))
  expect_equal(ss$max, c(2, NA))
})

test_that("por defecto trunca unique_values a nn caracteres", {
  aa <- data.frame(x = 1:100)

  expect_equal(nchar(pjp_dicc(aa, nn = 15)$unique_values), 15 + 3)
  expect_gt(nchar(pjp_dicc(aa, truncate = FALSE)$unique_values), 15)
})

test_that("no falla con columnas lista", {
  aa <- tibble::tibble(li = list(1, 2), x = 1:2)

  expect_no_error(ss <- pjp_dicc(aa))
  expect_true(is.na(ss$unique_values[1]))
})

test_that("devuelve un tibble", {
  expect_s3_class(pjp_dicc(iris), "tbl_df")
})

test_that("pasa sep, cifras y decimales a las funciones que combina", {
  aa <- data.frame(x = c(1 / 3, 2 / 3), zz = c(0, 1))
  ss <- pjp_dicc(aa, sep = " | ", cifras = 2, decimales = 3)

  expect_equal(ss$unique_values[1], "0.33 | 0.67")
  expect_equal(ss$mean[1], 0.5)
  expect_equal(ss$sd[1], round(stats::sd(c(1 / 3, 2 / 3)), 3))
  expect_equal(ss$q_zeros, c(0, 1))
})
