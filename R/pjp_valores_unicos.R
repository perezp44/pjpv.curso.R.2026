#' Valores únicos de cada columna de un df, en columnas
#'
#' `pjp_valores_unicos()` devuelve un df con las mismas columnas que el
#' de entrada, pero en cada una están sus valores únicos (sin `NA`).
#' El nº de filas es el menor entre `nn` y el mayor nº de valores únicos
#' de las variables; las variables con menos valores se rellenan con
#' `NA`. Si alguna variable tiene más de `nn` valores únicos se recorta
#' y se avisa.
#'
#' Las columnas que no son atómicas (p. ej. columnas lista) salen
#' todo `NA`.
#'
#' @param df un data frame.
#' @param nn nº máximo de valores únicos que se muestran por variable;
#'   por defecto 100.
#' @param ordenar si es `TRUE` los valores se ordenan; si es `FALSE`
#'   (por defecto) salen en el orden en que aparecen en `df`.
#'
#' @return Un data frame con las mismas columnas (y clases) que `df`.
#'
#' @seealso [pjp_unique_values()] para tener los valores únicos en una
#'   fila por variable.
#'
#' @examples
#' pjp_valores_unicos(iris, nn = 5)
#' pjp_valores_unicos(iris, nn = 5, ordenar = TRUE)
#' @export
pjp_valores_unicos <- function(df, nn = 100, ordenar = FALSE) {
  if (!is.data.frame(df)) {
    cli::cli_abort("{.arg df} debe ser un data frame.")
  }
  unicos <- lapply(df, function(x) {
    if (!is.atomic(x)) return(NULL)
    uu <- unique(x)
    uu <- uu[!is.na(uu)]
    if (ordenar) sort(uu) else uu
  })
  nn_unicos <- lengths(unicos)

  recortadas <- nn_unicos > nn
  if (any(recortadas)) {
    detalle <- paste0(names(df)[recortadas], " (", nn_unicos[recortadas], ")", collapse = ", ")
    cli::cli_warn("se muestran solo {nn} valores unicos de: {detalle}")
  }

  n_filas <- min(nn, max(0, nn_unicos))
  #- indexar con seq_len() rellena con NA y mantiene la clase (factor, Date...)
  aa <- lapply(seq_along(df), function(ii) {
    if (is.null(unicos[[ii]])) return(rep(NA, n_filas))
    unicos[[ii]][seq_len(n_filas)]
  })
  as.data.frame(aa, col.names = names(df), optional = TRUE)
}
