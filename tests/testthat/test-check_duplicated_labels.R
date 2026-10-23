test_that("devuelve TRUE cuando el mapeo es 1:1", {
  aa <- tibble::tibble(codes = c("a", "b", "c"), labels = c("x", "y", "z"))

  expect_true(suppressMessages(check_duplicated_labels(aa, codes, labels)))
})

test_that("devuelve FALSE cuando hay duplicados", {
  aa <- tibble::tibble(codes = c("a", "a", "c"), labels = c("x", "y", "z"))

  expect_false(suppressMessages(suppressWarnings(
    check_duplicated_labels(aa, codes, labels)
  )))
})

test_that("detecta una etiqueta compartida por dos códigos", {
  aa <- tibble::tibble(codes = c("a", "b", "c"), labels = c("x", "x", "z"))

  expect_false(suppressMessages(suppressWarnings(
    check_duplicated_labels(aa, codes, labels)
  )))
})

test_that("funciona con columnas pasadas por nombre (estilo string)", {
  aa <- tibble::tibble(codes = c("a", "b"), labels = c("x", "y"))

  expect_true(suppressMessages(check_duplicated_labels(aa, "codes", "labels")))
})

test_that("NSE y strings dan el mismo resultado (1:1 y fallo)", {
  aa_ok <- tibble::tibble(codes = c("a", "b"), labels = c("x", "y"))
  aa_ko <- tibble::tibble(codes = c("a", "a"), labels = c("x", "y"))

  expect_true(suppressMessages(check_duplicated_labels(aa_ok, codes, labels)))
  expect_true(suppressMessages(check_duplicated_labels(aa_ok, "codes", "labels")))

  expect_false(suppressMessages(suppressWarnings(
    check_duplicated_labels(aa_ko, codes, labels)
  )))
  expect_false(suppressMessages(suppressWarnings(
    check_duplicated_labels(aa_ko, "codes", "labels")
  )))
})

test_that("los avisos de NA y diagnóstico funcionan con strings", {
  aa <- tibble::tibble(codes = c("a", "a", NA), labels = c("x", "y", NA))

  expect_warning(
    expect_warning(
      suppressMessages(check_duplicated_labels(aa, "codes", "labels")),
      "NA"
    ),
    '"a"'
  )
})

test_that("funciona con la tabla real del paquete", {
  expect_true(suppressMessages(
    check_duplicated_labels(ine_code_prov_pjp, ine_prov, ine_prov.n)
  ))
})

test_that("el warning del fallo incluye los valores duplicados", {
  aa <- tibble::tibble(codes = c("a", "b", "c"), labels = c("x", "x", "z"))

  expect_warning(
    suppressMessages(check_duplicated_labels(aa, codes, labels)),
    '"x"'
  )
})

test_that("avisa si hay NA en las variables chequeadas", {
  aa <- tibble::tibble(codes = c("a", "b", NA), labels = c("x", "y", NA))

  expect_warning(
    suppressMessages(check_duplicated_labels(aa, codes, labels)),
    "NA"
  )
})

test_that("mapeo 1:1 con NA en ambas variables cuenta como combinación única", {
  aa <- tibble::tibble(codes = c("a", "b", NA), labels = c("x", "y", NA))

  ss <- suppressMessages(suppressWarnings(
    check_duplicated_labels(aa, codes, labels)
  ))
  expect_true(ss)
})

test_that("el mapeo se rompe si un NA convive con valores reales", {
  aa <- tibble::tibble(codes = c("a", "a", NA), labels = c("x", "y", NA))

  expect_false(suppressMessages(suppressWarnings(
    check_duplicated_labels(aa, codes, labels)
  )))
})
