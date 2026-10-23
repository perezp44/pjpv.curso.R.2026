test_that("descarga una tabla con cada código junto a su etiqueta", {
  skip_on_cran()
  skip_if_not_installed("eurostat")
  skip_if_offline()

  expect_message(ss <- eurostat_download("crim_off_cat"), "crim_off_cat")
  expect_s3_class(ss, "data.frame")
  expect_gt(nrow(ss), 0)
  expect_equal(which(names(ss) == "geo_code") + 1, which(names(ss) == "geo"))
  expect_false(any(c("values_code", "TIME_PERIOD_code", "flags_code") %in% names(ss)))
  expect_true(all(c("flags", "TIME_PERIOD", "values") %in% names(ss)))
  expect_type(attr(ss, "titulo"), "character")
})

test_that("con filters y lang: filtra, traduce y mantiene TIME_PERIOD", {
  skip_on_cran()
  skip_if_not_installed("eurostat")
  skip_if_offline()

  ss <- suppressMessages(eurostat_download("crim_off_cat", lang = "fr", filters = list(geo = "ES")))
  expect_equal(unique(ss$geo_code), "ES")
  expect_equal(unique(ss$geo), "Espagne")
  expect_type(ss$TIME_PERIOD, "character")
})

test_that("da error con un idioma no disponible", {
  expect_error(eurostat_download("crim_off_cat", lang = "es"))
})
