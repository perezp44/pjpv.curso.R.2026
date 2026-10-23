test_that("devuelve los elementos de x que no están en y", {
  expect_equal(pjp_not_in(c(1, 2, 3), c(2, 3)), 1)
  expect_equal(pjp_not_in(c("a", "b", "c"), c("z")), c("a", "b", "c"))
})

test_that("conserva los duplicados de x", {
  expect_equal(pjp_not_in(c("a", "b", "a"), "b"), c("a", "a"))
})

test_that("devuelve un vector vacío si todo está en y", {
  expect_equal(pjp_not_in(1:3, 1:5), integer(0))
})

test_that("los NA se tratan como un valor más", {
  expect_equal(pjp_not_in(c(1, NA), 1), NA_real_)
  expect_equal(pjp_not_in(c(1, NA), NA), 1)
})

test_that("%not_in% es la negación de %in%", {
  expect_equal(c(1, 2, 3) %not_in% c(2, 3), c(TRUE, FALSE, FALSE))
  expect_equal(c(1, NA) %not_in% NA, c(TRUE, FALSE))
})

test_that("%not_in% funciona dentro de filter()", {
  ss <- dplyr::filter(iris, Species %not_in% c("setosa", "virginica"))

  expect_equal(unique(as.character(ss$Species)), "versicolor")
})

test_that("avisa si se comparan tipos distintos", {
  expect_warning(pjp_not_in(c(1, 2), c("1")), "tipos distintos")
  expect_warning(c(TRUE, FALSE) %not_in% 1, "tipos distintos")
  expect_warning(Sys.Date() %not_in% "2020-01-01", "tipos distintos")
})

test_that("no avisa con tipos compatibles, vacíos o todo NA", {
  expect_no_warning(1:3 %not_in% c(1, 2))
  expect_no_warning(c("a", "b") %not_in% factor("a"))
  expect_no_warning(c(1, 2) %not_in% NA)
  expect_no_warning(c(1, 2) %not_in% character(0))
})
