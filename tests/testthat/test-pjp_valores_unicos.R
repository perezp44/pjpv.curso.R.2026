test_that("cada columna tiene sus únicos sin NA, rellenando con NA", {
  aa <- data.frame(x = c(1, 1, 2, NA), chr = c("a", "b", "c", "d"))
  ss <- pjp_valores_unicos(aa)

  expect_equal(names(ss), names(aa))
  expect_equal(ss$x, c(1, 2, NA, NA))
  expect_equal(ss$chr, c("a", "b", "c", "d"))
})

test_that("el nº de filas es el mayor nº de únicos si no llega a nn", {
  expect_equal(nrow(pjp_valores_unicos(iris)), 43)
  expect_equal(nrow(pjp_valores_unicos(data.frame(x = c(1, 1)))), 1)
})

test_that("recorta a nn y avisa de qué variables se recortan", {
  aa <- data.frame(x = 1:5, y = c(1, 1, 1, 2, 2))

  expect_warning(ss <- pjp_valores_unicos(aa, nn = 3), "x \\(5\\)")
  expect_equal(nrow(ss), 3)
  expect_equal(ss$x, 1:3)
  expect_equal(ss$y, c(1, 2, NA))
})

test_that("no avisa si ninguna variable supera nn", {
  expect_no_warning(pjp_valores_unicos(data.frame(x = 1:3), nn = 3))
})

test_that("ordenar = TRUE ordena; por defecto se respeta el orden de aparición", {
  aa <- data.frame(x = c(3, 1, 2))

  expect_equal(pjp_valores_unicos(aa)$x, c(3, 1, 2))
  expect_equal(pjp_valores_unicos(aa, ordenar = TRUE)$x, c(1, 2, 3))
})

test_that("mantiene la clase de factores y fechas", {
  aa <- data.frame(
    f = factor(c("a", "b")),
    fe = as.Date(c("2020-01-01", "2020-01-02"))
  )
  ss <- pjp_valores_unicos(aa)

  expect_s3_class(ss$f, "factor")
  expect_s3_class(ss$fe, "Date")
})

test_that("las columnas lista salen todo NA en vez de error", {
  aa <- tibble::tibble(li = list(1, 2), x = c(2, 1))
  ss <- pjp_valores_unicos(aa)

  expect_true(all(is.na(ss$li)))
  expect_equal(ss$x, c(2, 1))
})

test_that("respeta nombres de columnas no sintácticos", {
  aa <- data.frame(`mi var` = 1:2, check.names = FALSE)

  expect_equal(names(pjp_valores_unicos(aa)), "mi var")
})

test_that("da error si no es un data frame", {
  expect_error(pjp_valores_unicos(1:3), "data frame")
})
