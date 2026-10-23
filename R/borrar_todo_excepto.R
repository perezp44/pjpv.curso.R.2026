#' Borra todos los objetos del globalenv salvo los indicados
#'
#' Elimina del entorno global todos los objetos cuyo nombre no esté
#' en `vv_no_borrar`. Útil para limpiar la sesión conservando solo
#' los objetos de interés.
#'
#' @param vv_no_borrar vector de caracteres con los nombres de los
#'   objetos que se quieren conservar.
#' @param envir entorno donde se hace la limpieza;
#'   por defecto `globalenv()`.
#'
#' @return Invisible: `NULL`. Se invoca por su efecto lateral.
#'
#' @examples
#' \dontrun{
#' # Conserva solo los objetos indicados y borra el resto:
#' borrar_todo_excepto(c("modelo_final", "resultado_vec"))
#' }
#' @export
borrar_todo_excepto <- function(vv_no_borrar, envir = globalenv()) {
  if (!is.character(vv_no_borrar)) {
    cli::cli_abort("{.arg vv_no_borrar} debe ser un vector de caracteres.")
  }
  existentes <- ls(envir)
  faltan <- setdiff(vv_no_borrar, existentes)
  if (length(faltan) > 0) {
    cli::cli_warn("no existen en {deparse(substitute(envir))}: {.val {faltan}}")
  }
  rm(list = setdiff(existentes, vv_no_borrar), envir = envir)
  invisible()
}
