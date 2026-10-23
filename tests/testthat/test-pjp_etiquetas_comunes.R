df1 <- data.frame(cod = c(3, 1, 2, 3), etiq = c("c", "a", "b", "c"))
df2 <- data.frame(cod = c(1, 2, 4), etiq = c("a", "B", "d"))

test_that("full por defecto: todos los códigos, ordenados, con coinciden", {
  ss <- pjp_etiquetas_comunes(df1, df2, cod, etiq)

  expect_named(ss, c("cod", "etiq..df1", "etiq..df2", "coinciden"))
  expect_equal(ss$cod, c(1, 2, 3, 4))
  expect_equal(ss$etiq..df1, c("a", "b", "c", NA))
  expect_equal(ss$etiq..df2, c("a", "B", NA, "d"))
  expect_equal(ss$coinciden, c(TRUE, FALSE, NA, NA))
})

test_that("left y right se quedan con los códigos de un df", {
  expect_equal(pjp_etiquetas_comunes(df1, df2, cod, etiq, tipo_join = "left")$cod, c(1, 2, 3))
  expect_equal(pjp_etiquetas_comunes(df1, df2, cod, etiq, tipo_join = "right")$cod, c(1, 2, 4))
})

test_that("acepta también los nombres largos de join", {
  expect_identical(
    pjp_etiquetas_comunes(df1, df2, cod, etiq, tipo_join = "left_join"),
    pjp_etiquetas_comunes(df1, df2, cod, etiq, tipo_join = "left")
  )
})

test_that("dos NA en un código común cuentan como iguales", {
  aa <- data.frame(cod = 1, etiq = NA)

  expect_true(pjp_etiquetas_comunes(aa, aa, cod, etiq)$coinciden)
})

test_that("solo_diferencias devuelve las filas sin coincidencia", {
  ss <- pjp_etiquetas_comunes(df1, df2, cod, etiq, solo_diferencias = TRUE)

  expect_equal(ss$cod, c(2, 3, 4))
})

test_that("avisa si un código tiene más de una etiqueta", {
  aa <- data.frame(cod = c(1, 1), etiq = c("a", "A"))

  expect_warning(ss <- pjp_etiquetas_comunes(df1, aa, cod, etiq), "df2")
  expect_equal(ss$coinciden[ss$cod == 1], c(TRUE, FALSE))
})

test_that("da error si los códigos son de distinto tipo", {
  aa <- data.frame(cod = c("1", "2"), etiq = c("a", "b"))

  expect_error(pjp_etiquetas_comunes(df1, aa, cod, etiq), "mismo tipo")
})

test_that("códigos texto y factor son compatibles", {
  aa <- data.frame(cod = c("1", "2"), etiq = c("a", "b"))
  bb <- data.frame(cod = factor(c("1", "2")), etiq = c("a", "b"))

  expect_equal(suppressWarnings(pjp_etiquetas_comunes(aa, bb, cod, etiq))$coinciden, c(TRUE, TRUE))
})

test_that("NSE y strings dan el mismo resultado", {
  expect_identical(
    pjp_etiquetas_comunes(df1, df2, cod, etiq),
    pjp_etiquetas_comunes(df1, df2, "cod", "etiq")
  )
})

test_that("da error con un tipo de join desconocido", {
  expect_error(pjp_etiquetas_comunes(df1, df2, cod, etiq, tipo_join = "inner"))
})
