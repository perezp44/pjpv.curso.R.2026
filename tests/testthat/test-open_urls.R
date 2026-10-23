test_that("abre cada URL con el navegador de getOption('browser')", {
  abiertas <- character()
  withr::local_options(browser = function(url) abiertas <<- c(abiertas, url))

  urls <- c("https://www.r-project.org", "https://cran.r-project.org")
  expect_invisible(ss <- open_urls(urls))
  expect_equal(ss, urls)
  expect_equal(abiertas, urls)
})

test_that("funciona con una sola URL", {
  abiertas <- character()
  withr::local_options(browser = function(url) abiertas <<- c(abiertas, url))

  open_urls("https://www.r-project.org")
  expect_equal(abiertas, "https://www.r-project.org")
})

test_that("añade https:// si falta el protocolo", {
  abiertas <- character()
  withr::local_options(browser = function(url) abiertas <<- c(abiertas, url))

  open_urls(c("www.r-project.org", "http://example.com", "mailto:a@b.es"))
  expect_equal(abiertas, c("https://www.r-project.org", "http://example.com", "mailto:a@b.es"))
})

test_that("quita NA, vacías y repetidas", {
  abiertas <- character()
  withr::local_options(browser = function(url) abiertas <<- c(abiertas, url))

  ss <- open_urls(c("www.r-project.org", NA, "", " ", "https://www.r-project.org"))
  expect_equal(abiertas, "https://www.r-project.org")
  expect_equal(ss, "https://www.r-project.org")
})

test_that("si hay más de max URLs da error y no abre ninguna", {
  abiertas <- character()
  withr::local_options(browser = function(url) abiertas <<- c(abiertas, url))

  urls <- paste0("https://example.com/", 1:21)
  expect_error(open_urls(urls), "21 URLs")
  expect_length(abiertas, 0)

  open_urls(urls, max = Inf)
  expect_length(abiertas, 21)
})
