#' Resumen básico de las variables de un df
#'
#' `pjp_estadisticos_basicos()` devuelve un df con una fila por cada
#' variable del df de entrada y algunas de sus características:
#' número y porcentaje de ceros (`q_zeros`, `p_zeros`) y de `NA`
#' (`q_na`, `p_na`), tipo, nº de valores únicos (sin contar `NA`),
#' rango de las fechas y, para las numéricas, mínimo, máximo, media y
#' desviación típica.
#'
#' Los ceros solo se cuentan en variables numéricas. En las lógicas,
#' `mean` es la proporción de `TRUE`.
#'
#' Adaptada de `df_status()` del paquete funModeling de Pablo Casas
#' (gracias Pablo!!); se copia para no depender de ese paquete.
#'
#' @param data un data frame.
#' @param decimales nº de decimales de los porcentajes y estadísticos;
#'   por defecto 2.
#'
#' @return Un data frame con las columnas `variables`, `q_zeros`,
#'   `p_zeros`, `q_na`, `p_na`, `type`, `nn_unique`, `rango` (texto
#'   `"min / max"`, solo para fechas), `min`, `max`, `mean`, `sd`, `NN`
#'   (nº de filas) y `NN_ok` (nº de filas sin `NA`).
#'
#' @examples
#' pjp_estadisticos_basicos(cars)
#' pjp_estadisticos_basicos(iris, decimales = 1)
#' @export
pjp_estadisticos_basicos <- function(data, decimales = 2) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} debe ser un data frame.")
  }
  nn <- nrow(data)
  #- con 0 filas los porcentajes serían NaN (0/0)
  porcentaje <- function(q) if (nn == 0) NA_real_ else round(100 * q / nn, decimales)

  q_zeros <- vapply(data, function(x) {
    if (!is.numeric(x)) return(NA_real_)
    sum(x == 0, na.rm = TRUE)
  }, numeric(1))
  q_na <- vapply(data, function(x) sum(is.na(x)), numeric(1))

  #- con todo NA min()/max() darían Inf y un warning
  resumir <- function(ff, logicas = FALSE) {
    vapply(data, function(x) {
      ok <- is.numeric(x) || (logicas && is.logical(x))
      if (!ok || all(is.na(x))) return(NA_real_)
      round(ff(x, na.rm = TRUE), decimales)
    }, numeric(1))
  }
  rango <- vapply(data, function(x) {
    if (!inherits(x, c("Date", "POSIXt")) || all(is.na(x))) return(NA_character_)
    paste(format(range(x, na.rm = TRUE)), collapse = " / ")
  }, character(1))

  data.frame(
    variables = names(data),
    q_zeros = q_zeros,
    p_zeros = porcentaje(q_zeros),
    q_na = q_na,
    p_na = porcentaje(q_na),
    type = vapply(data, function(x) class(x)[1], character(1)),
    nn_unique = vapply(data, function(x) sum(!is.na(unique(x))), numeric(1)),
    rango = rango,
    min = resumir(min),
    max = resumir(max),
    mean = resumir(mean, logicas = TRUE),
    sd = resumir(stats::sd),
    NN = nn,
    NN_ok = nn - q_na,
    row.names = NULL
  )
}
