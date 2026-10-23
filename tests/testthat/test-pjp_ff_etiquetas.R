test_that("sin nombres: cambia las etiquetas por orden de aparición", {
  df <- data.frame(id = 1:4, sexo = c("H", "M", "M", "H"))
  ss <- pjp_ff_etiquetas(df, sexo, c("Home", "Dona"))

  expect_equal(ss$sexo, c("Home", "Dona", "Dona", "Home"))
  expect_equal(ss$id, df$id)
})

test_that("sin nombres: el NA cuenta como un valor más", {
  df <- data.frame(sexo = c("H", NA, "M"))

  expect_equal(pjp_ff_etiquetas(df, sexo, c("Home", "Sin dato", "Dona"))$sexo, c("Home", "Sin dato", "Dona"))
})

test_that("con nombres: la correspondencia no depende del orden", {
  df <- data.frame(sexo = c("M", "H", "M"))

  expect_equal(pjp_ff_etiquetas(df, sexo, c(H = "Home", M = "Dona"))$sexo, c("Dona", "Home", "Dona"))
})

test_that("con nombres: los NA se quedan como NA", {
  df <- data.frame(sexo = c("H", NA))

  expect_equal(pjp_ff_etiquetas(df, sexo, c(H = "Home"))$sexo, c("Home", NA))
})

test_that("con nombres: los valores sin etiqueta se conservan y se avisa", {
  df <- data.frame(sexo = c("H", "X"))

  expect_warning(ss <- pjp_ff_etiquetas(df, sexo, c(H = "Home")), '"X"')
  expect_equal(ss$sexo, c("Home", "X"))
})

test_that("con nombres: funciona con códigos numéricos", {
  df <- data.frame(sexo = c(1, 2, 1))

  expect_equal(pjp_ff_etiquetas(df, sexo, c(`1` = "Home", `2` = "Dona"))$sexo, c("Home", "Dona", "Home"))
})

test_that("la variable se queda en su posición", {
  df <- data.frame(sexo = c("H", "M"), id = 1:2)

  expect_named(pjp_ff_etiquetas(df, sexo, c("Home", "Dona")), c("sexo", "id"))
})

test_that("un factor sigue siendo factor con niveles en el orden de my_etiquetas", {
  df <- data.frame(sexo = factor(c("M", "H", "M")))

  ss <- pjp_ff_etiquetas(df, sexo, c(H = "Home", M = "Dona"))
  expect_s3_class(ss$sexo, "factor")
  expect_equal(levels(ss$sexo), c("Home", "Dona"))
  expect_equal(as.character(ss$sexo), c("Dona", "Home", "Dona"))

  ss_sin <- pjp_ff_etiquetas(df, sexo, c("Dona", "Home"))
  expect_equal(levels(ss_sin$sexo), c("Dona", "Home"))
})

test_that("NSE y strings dan el mismo resultado", {
  df <- data.frame(sexo = c("H", "M"))

  expect_identical(
    pjp_ff_etiquetas(df, sexo, c("Home", "Dona")),
    pjp_ff_etiquetas(df, "sexo", c("Home", "Dona"))
  )
})

test_that("da error si el nº de etiquetas no coincide (sin nombres)", {
  df <- data.frame(sexo = c("H", "M"))

  expect_error(pjp_ff_etiquetas(df, sexo, "Home"), "tantos elementos")
})

test_that("da error si solo algunas etiquetas tienen nombre", {
  df <- data.frame(sexo = c("H", "M"))

  expect_error(pjp_ff_etiquetas(df, sexo, c(H = "Home", "Dona")), "todos sus elementos")
})

test_that("da error si la variable no existe", {
  df <- data.frame(sexo = c("H", "M"))

  expect_error(pjp_ff_etiquetas(df, edad, c("a", "b")), "edad")
})
