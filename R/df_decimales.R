#' Redondea las columnas numéricas de un df
#'
#' `df_decimales()` devuelve el mismo data frame pero con los valores de
#' sus columnas numéricas redondeados a `nn` decimales. Las columnas no
#' numéricas se dejan intactas.
#'
#' @param df un data frame (o tibble).
#' @param nn número de decimales; por defecto 2.
#'
#' @return Un data frame de la misma clase que `df` con sus columnas
#'   numéricas redondeadas a `nn` decimales.
#'
#' @examples
#' df_decimales(iris, nn = 1)
#' df_decimales(cars)
#' @export
df_decimales <- function(df, nn = 2) {
  if (!is.data.frame(df)) {
    cli::cli_abort("{.arg df} debe ser un data frame.")
  }
  #- vapply y no sapply: con un df sin columnas sapply devuelve list()
  es_num <- vapply(df, is.numeric, logical(1))
  df[es_num] <- lapply(df[es_num], round, digits = nn)
  df
}
