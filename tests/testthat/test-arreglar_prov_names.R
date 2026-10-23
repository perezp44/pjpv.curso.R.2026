test_that("añade ine_prov, ine_ccaa y ine_ccaa.n", {
  aa <- tibble::tibble(ine_prov.n = c("Almería", "Sevilla", "Zaragoza"))

  ss <- arreglar_prov_names(aa)

  expect_named(ss, c("ine_prov.n", "ine_prov", "ine_ccaa", "ine_ccaa.n"))
  expect_equal(ss$ine_prov, c("04", "41", "50"))
  expect_equal(ss$ine_ccaa.n, c("Andalucía", "Andalucía", "Aragón"))
})

test_that(".keep_all = TRUE añade las variables extra", {
  aa <- tibble::tibble(ine_prov.n = c("Almería"))

  ss <- arreglar_prov_names(aa, .keep_all = TRUE)

  expect_true(all(c("capital_prov.n", "capital_ccaa.n", "iso_code_prov",
                    "iso_code_ccaa") %in% names(ss)))
  expect_equal(ss$capital_ccaa.n, "Sevilla")
})

test_that("conserva las variables originales del df", {
  aa <- tibble::tibble(id = 1:2, ine_prov.n = c("Huesca", "Teruel"))

  ss <- arreglar_prov_names(aa)

  expect_equal(ss$id, 1:2)
  expect_equal(ss$ine_prov, c("22", "44"))
})

test_that("avisa con provincias sin respaldo", {
  aa <- tibble::tibble(ine_prov.n = c("Almería", "Atlantis"))

  expect_warning(arreglar_prov_names(aa), "Atlantis|respaldo")
})

test_that("las provincias desconocidas quedan con NA", {
  aa <- tibble::tibble(ine_prov.n = c("Almería", "Atlantis"))

  suppressWarnings(ss <- arreglar_prov_names(aa))

  expect_equal(ss$ine_prov, c("04", NA))
})

test_that("los NA preexistentes en ine_prov.n no disparan el aviso", {
  aa <- tibble::tibble(ine_prov.n = c("Almería", NA))

  expect_no_warning(arreglar_prov_names(aa))
})

test_that("error si el df no tiene la columna ine_prov.n", {
  aa <- tibble::tibble(provincia = "Almería")

  expect_error(arreglar_prov_names(aa), "ine_prov.n")
})
