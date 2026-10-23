#' Elementos de un vector que no están en otro
#'
#' `pjp_not_in()` devuelve los elementos de `x` que no están en `y`. A
#' diferencia de [setdiff()], conserva los duplicados de `x`.
#'
#' `%not_in%` es la negación de `%in%`: devuelve un vector lógico, útil
#' p. ej. dentro de `dplyr::filter()`.
#'
#' Las dos avisan si `x` e `y` son de tipos distintos (p. ej. número y
#' texto), porque `%in%` los compara sin avisar: `1` y `"1"` cuentan
#' como iguales. Texto y factor se consideran del mismo tipo, igual que
#' entero y doble, y un vector vacío o todo `NA` no provoca aviso.
#'
#' @param x un vector.
#' @param y otro vector.
#'
#' @return `pjp_not_in()`: un vector con los elementos de `x` que no
#'   están en `y`. `%not_in%`: un vector lógico del largo de `x`.
#'
#' @examples
#' pjp_not_in(c(1, 2, 3), c(2, 3))
#' pjp_not_in(c("a", "b", "a"), "b")
#'
#' c(1, 2, 3) %not_in% c(2, 3)
#' dplyr::filter(iris, Species %not_in% c("setosa", "virginica"))
#' @export
pjp_not_in <- function(x, y) {
  x[x %not_in% y]
}

#' @rdname pjp_not_in
#' @export
`%not_in%` <- function(x, y) {
  #- %in% coerciona en silencio: 1 y "1" contarían como iguales
  tipo <- function(v) {
    if (is.numeric(v)) "numero" else if (is.character(v) || is.factor(v)) "texto" else class(v)[1]
  }
  sin_datos <- function(v) length(v) == 0 || all(is.na(v))
  if (!sin_datos(x) && !sin_datos(y) && tipo(x) != tipo(y)) {
    cli::cli_warn("se comparan tipos distintos: {.arg x} es {.cls {class(x)}} e {.arg y} es {.cls {class(y)}}")
  }
  !x %in% y
}
