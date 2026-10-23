#' Ruta a la carpeta del documento activo
#'
#' `pjp_ruta_a_carpeta()` devuelve la ruta a la carpeta donde está el
#' documento activo en el editor (RStudio o Positron), o a una
#' subcarpeta suya. Es útil cuando se trabaja con documentos Quarto o
#' R Markdown.
#'
#' Fuera de un IDE (p. ej. al renderizar con `quarto render`) no hay
#' documento activo: en ese caso hay que indicar `path`. En Positron
#' tampoco lo hay si el foco está en la consola: hay que ejecutarla
#' desde el documento (p. ej. desde un chunk).
#'
#' @param q_carpeta nombre de una subcarpeta; si se indica, la ruta
#'   apunta a esa subcarpeta. Por defecto `NULL`. No se comprueba que
#'   exista.
#' @param path ruta a un archivo; se usa su carpeta. Por defecto `NULL`,
#'   que usa el documento activo del editor (requiere rstudioapi).
#'
#' @return Un string con la ruta a la carpeta (sin `/` final).
#'
#' @examples
#' pjp_ruta_a_carpeta(path = "informes/informe.qmd")
#' pjp_ruta_a_carpeta("datos", path = "informes/informe.qmd")
#' if (interactive()) {
#'   pjp_ruta_a_carpeta()
#' }
#' @export
pjp_ruta_a_carpeta <- function(q_carpeta = NULL, path = NULL) {
  if (is.null(path)) {
    rlang::check_installed("rstudioapi")
    if (!rstudioapi::isAvailable()) {
      cli::cli_abort(c(
        "no hay un editor (RStudio o Positron) del que sacar el documento activo.",
        "i" = "indica la ruta con {.arg path}."
      ))
    }
    path <- rstudioapi::getSourceEditorContext()$path
    if (is.null(path) || !nzchar(path)) {
      cli::cli_abort(c(
        "no se puede saber la ruta del documento activo.",
        "i" = "comprueba que esta guardado.",
        "i" = "en Positron, ejecuta la funcion desde el documento, no desde la consola.",
        "i" = "o indica la ruta con {.arg path}."
      ))
    }
  }
  ruta <- dirname(path)
  if (!is.null(q_carpeta)) {
    ruta <- file.path(ruta, q_carpeta)
  }
  ruta
}
