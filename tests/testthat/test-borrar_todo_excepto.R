test_that("borra todo salvo los indicados", {
  e <- new.env()
  e$uno <- 1
  e$dos <- 2
  e$tres <- 3

  borrar_todo_excepto(c("uno", "tres"), envir = e)

  expect_false(exists("dos", envir = e))
  expect_true(exists("uno", envir = e))
  expect_true(exists("tres", envir = e))
})

test_that("por defecto limpia el globalenv", {
  assign("a", 1, envir = globalenv())
  assign("b", 2, envir = globalenv())

  withCallingHandlers(
    borrar_todo_excepto("a"),
    warning = function(w) invokeRestart("muffleWarning")
  )

  expect_true(exists("a", envir = globalenv()))
  expect_false(exists("b", envir = globalenv()))
  rm("a", envir = globalenv())
})

test_that("avisa si un nombre no existe y conserva el resto", {
  e <- new.env()
  e$uno <- 1

  expect_warning(
    borrar_todo_excepto(c("uno", "no_esta"), envir = e),
    "no_esta"
  )
  expect_true(exists("uno", envir = e))
})

test_that("error si la entrada no es de caracteres", {
  expect_error(borrar_todo_excepto(1), "caracteres")
})
