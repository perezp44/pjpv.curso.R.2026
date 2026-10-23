#' Añade ine_prov, ine_ccaa a un df que tiene una vv llamada ine_prov.n
#'
#' Añade al df las variables `ine_prov`, `ine_ccaa` y `ine_ccaa.n`
#' a partir de la variable `ine_prov.n` (nombre de provincia).
#' Con `.keep_all = TRUE` se añaden más variables: capitales,
#' códigos ISO, etc.
#'
#' @param df un data frame con una variable llamada `ine_prov.n`
#' @param .keep_all (default FALSE, si es TRUE se añaden más
#'   variables como `capital_prov`, `capital_ccaa`, etc.)
#'
#' @return El df original añadiendo `ine_prov`, `ine_ccaa` y
#'   `ine_ccaa.n`, o más variables si `.keep_all` es TRUE.
#'
#' @examples
#' \dontrun{
#' aa <- tibble::tibble(ine_prov.n = c("Almería", "Sevilla", "Zaragoza"))
#' arreglar_prov_names(aa)
#' arreglar_prov_names(aa, .keep_all = TRUE)
#' }
#' @export
arreglar_prov_names <- function(df, .keep_all = FALSE) {
  if (!"ine_prov.n" %in% names(df)) {
    cli::cli_abort("{.arg df} debe tener una variable llamada {.var ine_prov.n}.")
  }

  #- nombres de provincia sin respaldo (los NA preexistentes no cuentan)
  faltan <- setdiff(
    unique(df$ine_prov.n[!is.na(df$ine_prov.n)]),
    pjpv.curso.R.2026::ine_code_prov_pjp$ine_prov.n
  )
  if (length(faltan) > 0) {
    cli::cli_warn("hay nombres de provincias sin respaldo en {.code ine_code_prov_pjp} y, por tanto, no tendran codigo INE asignado: {.val {faltan}}")
  }

  aa <- dplyr::left_join(df, pjpv.curso.R.2026::ine_code_prov_pjp, by = "ine_prov.n")
  if (!.keep_all) {
    aa <- dplyr::select(aa, dplyr::all_of(c(names(df), "ine_prov", "ine_ccaa", "ine_ccaa.n")))
  }
  dplyr::relocate(aa, "ine_prov", .after = "ine_prov.n")
}
