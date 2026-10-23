#' Diccionario de un df
#'
#' `pjp_dicc()` devuelve un tibble con una fila por variable del df de
#' entrada que combina [pjp_estadisticos_basicos()] y
#' [pjp_unique_values()]: tipo, valores únicos, `NA`, ceros, rango de
#' las fechas y estadísticos básicos de las numéricas.
#'
#' @param df un data frame.
#' @param truncate si es `TRUE` se recorta `unique_values` a `nn`
#'   caracteres y se marca el recorte con `"..."`; por defecto `TRUE`.
#' @param nn nº máximo de caracteres de `unique_values` si
#'   `truncate = TRUE`; por defecto 100.
#' @param sep separador entre valores de `unique_values`; por defecto
#'   `" - "`.
#' @param cifras nº de cifras significativas con que se muestran en
#'   `unique_values` los números con decimales; por defecto 4.
#' @param decimales nº de decimales de los porcentajes y estadísticos;
#'   por defecto 2.
#'
#' @return Un tibble con las columnas `variables`, `type`, `nn_unique`,
#'   `unique_values`, `q_na`, `p_na`, `q_zeros`, `p_zeros`, `rango`,
#'   `min`, `max`, `mean`, `sd`, `NN` y `NN_ok`.
#'
#' @examples
#' pjp_dicc(iris)
#' pjp_dicc(mtcars, nn = 30, cifras = 3, decimales = 1)
#' @export
pjp_dicc <- function(df, truncate = TRUE, nn = 100, sep = " - ", cifras = 4,
                     decimales = 2) {
  aa <- pjp_estadisticos_basicos(df, decimales = decimales)
  bb <- pjp_unique_values(df, truncate = truncate, nn = nn, sep = sep, cifras = cifras)
  #- ambas tienen una fila por variable en el mismo orden: se unen por posición
  dplyr::bind_cols(aa, bb["unique_values"]) |>
    dplyr::select(dplyr::all_of(c(
      "variables", "type", "nn_unique", "unique_values", "q_na", "p_na",
      "q_zeros", "p_zeros", "rango", "min", "max", "mean", "sd", "NN", "NN_ok"
    ))) |>
    tibble::as_tibble()
}
