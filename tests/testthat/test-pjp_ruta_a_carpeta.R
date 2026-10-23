test_that("con path devuelve la carpeta del archivo", {
  expect_equal(pjp_ruta_a_carpeta(path = "informes/informe.qmd"), "informes")
  expect_equal(pjp_ruta_a_carpeta(path = "/home/yo/a/b.qmd"), "/home/yo/a")
})

test_that("q_carpeta apunta a una subcarpeta, sin / final", {
  expect_equal(
    pjp_ruta_a_carpeta("datos", path = "/home/yo/a/b.qmd"),
    "/home/yo/a/datos"
  )
})

test_that("sin path y sin editor da un error claro", {
  skip_if_not_installed("rstudioapi")
  skip_if(rstudioapi::isAvailable())

  expect_error(pjp_ruta_a_carpeta(), "path")
})
