#' Redondea números "de forma chachi"
#'
#' `pjp_round_nice()` redondea un vector numérico a `digits` decimales y
#' lo devuelve como texto, siempre con ese nº de decimales (`0.5` pasa a
#' `"0.50"`) y sin ceros negativos: `-0.0002` pasa a `"0.00"`, no a
#' `"-0.00"`. Los `NA` se quedan como `NA`.
#'
#' Idea de Karl Broman (gracias Karl!!):
#' <https://twitter.com/hspter/status/314858331598626816>.
#'
#' @param x un vector numérico.
#' @param digits nº de decimales, un entero >= 0; por defecto 2.
#' @param dec separador decimal; por defecto `"."`.
#' @param big_mark separador de miles; por defecto `""` (ninguno).
#'
#' @return Un vector de caracteres del largo de `x`.
#'
#' @examples
#' pjp_round_nice(c(-0.0002, 0.0002, 0.5, -0.5, -0.002), digits = 3)
#' pjp_round_nice(-0.2, digits = 0)
#' pjp_round_nice(1234567.891, dec = ",", big_mark = ".")
#' @export
pjp_round_nice <- function(x, digits = 2, dec = ".", big_mark = "") {
  if (!is.numeric(x)) {
    cli::cli_abort("{.arg x} debe ser numerico, no {.cls {class(x)}}.")
  }
  if (!is.numeric(digits) || length(digits) != 1 || is.na(digits) ||
      digits < 0 || digits != round(digits)) {
    cli::cli_abort("{.arg digits} debe ser un entero >= 0.")
  }
  g <- formatC(x, format = "f", digits = digits, decimal.mark = dec, big.mark = big_mark)
  #- "-0", "-0,00"... (valores que redondean a cero) pasan a positivos
  cero_negativo <- startsWith(g, "-") & !grepl("[1-9]", g)
  g[cero_negativo] <- sub("^-", "", g[cero_negativo])
  g[is.na(x)] <- NA_character_
  g
}
