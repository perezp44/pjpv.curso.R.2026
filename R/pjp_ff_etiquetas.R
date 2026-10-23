#' Cambia las etiquetas de una variable de un df
#'
#' `pjp_ff_etiquetas()` devuelve el mismo df pero con los valores de
#' `vv` sustituidos por `my_etiquetas`. La variable se queda en su
#' posición. Hay dos formas de indicar las etiquetas:
#'
#' * Vector con nombres, p. ej. `c(H = "Home", M = "Dona")`: cada valor
#'   se sustituye por la etiqueta de su nombre. Los `NA` se quedan como
#'   `NA` y los valores que no aparecen en los nombres conservan su
#'   valor original (y se avisa de ello).
#' * Vector sin nombres: la correspondencia es por orden de aparición;
#'   el primer valor distinto de `vv` que aparece en `df` pasa a ser
#'   `my_etiquetas[1]`, el segundo `my_etiquetas[2]`, etc. Debe tener
#'   tantos elementos como valores distintos tenga `vv` (`NA` incluido).
#'
#' Si `vv` es un factor el resultado sigue siendo factor, con las nuevas
#' etiquetas como niveles en el orden de `my_etiquetas`.
#'
#' @param df un data frame.
#' @param vv la variable a la que se le cambian las etiquetas; se acepta
#'   NSE (`sexo`) o string (`"sexo"`).
#' @param my_etiquetas vector con las nuevas etiquetas, con o sin nombres
#'   (ver detalles).
#'
#' @return `df` con las etiquetas de `vv` cambiadas.
#'
#' @examples
#' df <- data.frame(id = 1:4, sexo = c("H", "M", "M", NA))
#' pjp_ff_etiquetas(df, sexo, c(H = "Home", M = "Dona"))
#' pjp_ff_etiquetas(df, sexo, c("Home", "Dona", "Sin dato"))
#' @export
pjp_ff_etiquetas <- function(df, vv, my_etiquetas) {
  vv <- rlang::as_name(rlang::ensym(vv))
  if (!vv %in% names(df)) {
    cli::cli_abort("{.arg df} no tiene una variable llamada {.var {vv}}.")
  }
  xx <- df[[vv]]
  nombres <- names(my_etiquetas)
  con_nombres <- !is.null(nombres)
  if (con_nombres && any(is.na(nombres) | nombres == "")) {
    cli::cli_abort("{.arg my_etiquetas} debe tener nombre en todos sus elementos o en ninguno.")
  }

  if (con_nombres) {
    #- los valores sin etiqueta conservan el original
    nuevas <- unname(my_etiquetas[as.character(xx)])
    sin_etiqueta <- is.na(nuevas) & !is.na(xx)
    if (any(sin_etiqueta)) {
      cli::cli_warn("valores de {.var {vv}} sin etiqueta, se dejan como estaban: {.val {unique(as.character(xx[sin_etiqueta]))}}")
      nuevas[sin_etiqueta] <- as.character(xx[sin_etiqueta])
    }
    niveles <- unique(c(unname(my_etiquetas), as.character(xx[sin_etiqueta])))
  } else {
    valores <- unique(xx)
    n_valores <- length(valores)
    n_etiquetas <- length(my_etiquetas)
    if (n_valores != n_etiquetas) {
      cli::cli_abort(c(
        "{.arg my_etiquetas} debe tener tantos elementos como valores distintos tiene {.var {vv}}.",
        "x" = "{.var {vv}} tiene {n_valores} valor{?es} distinto{?s}.",
        "x" = "{.arg my_etiquetas} tiene {n_etiquetas} elemento{?s}."
      ))
    }
    nuevas <- my_etiquetas[match(xx, valores)]
    niveles <- unique(my_etiquetas)
  }

  if (is.factor(xx)) {
    nuevas <- factor(nuevas, levels = niveles[!is.na(niveles)])
  }
  df[[vv]] <- nuevas
  df
}
