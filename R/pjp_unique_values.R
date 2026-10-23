#' Valores únicos de cada columna de un df, en una fila por variable
#'
#' `pjp_unique_values()` devuelve un df con una fila por variable y 3
#' columnas: el nombre de la variable, su nº de valores únicos y esos
#' valores únicos, ordenados y pegados con `sep`. Los `NA` no cuentan
#' como valor único.
#'
#' Las columnas que no son atómicas (p. ej. columnas lista) devuelven
#' `NA` en `nn_unique` y `unique_values`.
#'
#' @param df un data frame.
#' @param truncate si es `TRUE` se recorta `unique_values` a `nn`
#'   caracteres y se marca el recorte con `"..."`; por defecto `FALSE`.
#' @param nn nº máximo de caracteres de `unique_values` si
#'   `truncate = TRUE`; por defecto 100.
#' @param sep separador entre valores; por defecto `" - "`.
#' @param cifras nº de cifras significativas con que se muestran los
#'   números con decimales; por defecto 4. Solo afecta a
#'   `unique_values`, no al recuento `nn_unique`.
#'
#' @return Un data frame con las columnas `variables`, `nn_unique` y
#'   `unique_values`.
#'
#' @seealso [pjp_valores_unicos()] para tener los valores únicos en columnas.
#'
#' @examples
#' pjp_unique_values(iris)
#' pjp_unique_values(iris, truncate = TRUE, nn = 20)
#' pjp_unique_values(mtcars, sep = " | ", cifras = 2)
#' @export
pjp_unique_values <- function(df, truncate = FALSE, nn = 100, sep = " - ",
                              cifras = 4) {
  if (!is.data.frame(df)) {
    cli::cli_abort("{.arg df} debe ser un data frame.")
  }
  #- sort() descarta los NA
  unicos <- lapply(df, function(x) if (is.atomic(x)) sort(unique(x)) else NULL)
  es_atomica <- vapply(df, is.atomic, logical(1))

  unique_values <- vapply(unicos, function(x) {
    #- redondear puede juntar valores distintos: unique() tras signif()
    if (is.double(x) && !inherits(x, c("Date", "POSIXt", "difftime"))) {
      x <- unique(signif(x, cifras))
    }
    paste(x, collapse = sep)
  }, character(1))
  if (truncate) {
    recortar <- nchar(unique_values) > nn
    unique_values[recortar] <- paste0(substr(unique_values[recortar], 1, nn), "...")
  }

  data.frame(
    variables = names(df),
    nn_unique = ifelse(es_atomica, lengths(unicos), NA_integer_),
    unique_values = ifelse(es_atomica, unique_values, NA_character_),
    row.names = NULL
  )
}
