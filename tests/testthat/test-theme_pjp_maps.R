test_that("devuelve un tema de ggplot2 completo", {
  tt <- theme_pjp_maps()

  expect_s3_class(tt, "theme")
  expect_true(attr(tt, "complete"))
})

test_that("quita ejes y rejilla y muestra los títulos de las facetas", {
  tt <- theme_pjp_maps()

  expect_s3_class(tt$axis.text.x, "element_blank")
  expect_s3_class(tt$panel.grid.major, "element_blank")
  expect_s3_class(tt$strip.text, "element_text")
  expect_equal(tt$strip.text$face, "bold")
})

test_that("por defecto la leyenda va dentro, abajo a la derecha", {
  tt <- theme_pjp_maps()

  expect_equal(tt$legend.position, "inside")
  expect_equal(tt$legend.position.inside, c(0.9, 0.2))
})

test_that("legend_pos acepta coordenadas o posiciones de ggplot2", {
  expect_equal(theme_pjp_maps(legend_pos = c(0.1, 0.8))$legend.position.inside, c(0.1, 0.8))
  expect_equal(theme_pjp_maps(legend_pos = "bottom")$legend.position, "bottom")
  expect_error(theme_pjp_maps(legend_pos = "abajo"))
  expect_error(theme_pjp_maps(legend_pos = 0.5), "2 elementos")
})

test_that("base_size cambia el tamaño y el título escala con él", {
  tt <- theme_pjp_maps(base_size = 14)

  expect_equal(tt$text$size, 14)
  expect_equal(unclass(tt$plot.title$size), 1.4)
})

test_that("family cambia la fuente; por defecto es Ubuntu", {
  expect_equal(theme_pjp_maps()$text$family, "Ubuntu")
  expect_equal(theme_pjp_maps(family = "")$text$family, "")
})

test_that("se aplica a un gráfico con facetas sin avisos", {
  pp <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, color = cyl)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~am) +
    theme_pjp_maps()

  expect_no_warning(ggplot2::ggplot_build(pp))
})
