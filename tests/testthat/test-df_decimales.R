test_that("redondea las columnas numéricas a nn decimales", {
  aa <- data.frame(x = c(1.2345, 2.3456), y = c(10.111, 20.999))

  expect_equal(df_decimales(aa, nn = 1), data.frame(x = c(1.2, 2.3), y = c(10.1, 21)))
})

test_that("por defecto redondea a 2 decimales", {
  aa <- data.frame(x = 3.14159)

  expect_equal(df_decimales(aa)$x, 3.14)
})

test_that("deja intactas las columnas no numéricas", {
  aa <- tibble::tibble(x = 1.567, chr = "a", fct = factor("b"))
  ss <- df_decimales(aa, nn = 0)

  expect_equal(ss$x, 2)
  expect_identical(ss$chr, aa$chr)
  expect_identical(ss$fct, aa$fct)
})

test_that("conserva la clase tibble", {
  aa <- tibble::tibble(x = 1.234)

  expect_s3_class(df_decimales(aa), "tbl_df")
})

test_that("funciona con un df sin columnas numéricas o sin columnas", {
  aa <- data.frame(chr = c("a", "b"))

  expect_identical(df_decimales(aa), aa)
  expect_identical(df_decimales(data.frame()), data.frame())
})

test_that("da error si df no es un data frame", {
  expect_error(df_decimales(1:3), "data frame")
})
