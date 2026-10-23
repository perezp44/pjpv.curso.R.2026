test_that("devuelve nombre, nº de únicos y únicos pegados y ordenados, sin NA", {
  aa <- data.frame(x = c(3, 1, 3, NA), chr = c("b", "a", "b", "a"))
  ss <- pjp_unique_values(aa)

  expect_equal(ss$variables, c("x", "chr"))
  expect_equal(ss$nn_unique, c(2, 2))
  expect_equal(ss$unique_values, c("1 - 3", "a - b"))
})

test_that("truncate recorta a nn caracteres y lo marca con ...", {
  aa <- data.frame(x = 1:100)

  ss <- pjp_unique_values(aa, truncate = TRUE, nn = 10)
  expect_equal(ss$unique_values, "1 - 2 - 3 ...")

  ss_sin <- pjp_unique_values(aa, nn = 10)
  expect_gt(nchar(ss_sin$unique_values), 10)
})

test_that("da error si no es un data frame", {
  expect_error(pjp_unique_values(1:3), "data frame")
})

test_that("una columna toda NA tiene 0 valores únicos", {
  aa <- data.frame(x = c(NA, NA))
  ss <- pjp_unique_values(aa)

  expect_equal(ss$nn_unique, 0)
  expect_equal(ss$unique_values, "")
})

test_that("una columna toda NA tiene 0 valores únicos", {
  aa <- data.frame(x = c(NA, NA))
  ss <- pjp_unique_values(aa)

  expect_equal(ss$nn_unique, 0)
  expect_equal(ss$unique_values, "")
})

test_that("si no hace falta recortar no añade ...", {
  aa <- data.frame(x = 1:3)

  expect_equal(pjp_unique_values(aa, truncate = TRUE, nn = 50)$unique_values, "1 - 2 - 3")
})

test_that("las columnas lista dan NA en vez de error", {
  aa <- tibble::tibble(li = list(1, 2), x = 1:2)
  ss <- pjp_unique_values(aa)

  expect_equal(ss$nn_unique, c(NA, 2))
  expect_equal(ss$unique_values, c(NA, "1 - 2"))
})

test_that("sep cambia el separador", {
  aa <- data.frame(s = c("a - b", "c"))

  expect_equal(pjp_unique_values(aa, sep = " | ")$unique_values, "a - b | c")
})

test_that("cifras redondea solo la presentación de los decimales", {
  aa <- data.frame(
    x = c(1 / 3, 1.00001, 1.00002),
    i = 1:3,
    fe = as.Date(c("2020-01-01", "2020-01-02", "2020-01-03"))
  )
  ss <- pjp_unique_values(aa)

  expect_equal(ss$unique_values[1], "0.3333 - 1")
  expect_equal(ss$nn_unique[1], 3)
  expect_equal(ss$unique_values[2], "1 - 2 - 3")
  expect_equal(ss$unique_values[3], "2020-01-01 - 2020-01-02 - 2020-01-03")
  expect_equal(pjp_unique_values(aa, cifras = 2)$unique_values[1], "0.33 - 1")
})
