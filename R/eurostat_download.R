#' Descarga una tabla de Eurostat con códigos y etiquetas
#'
#' `eurostat_download()` descarga una tabla de Eurostat con
#' [eurostat::get_eurostat()] (con el tiempo en formato `"raw"` y los
#' flags) y le añade las etiquetas con [eurostat::label_eurostat()].
#' Cada dimensión de la tabla (`geo`, `unit`...) queda con su código
#' (sufijo `_code`) justo antes de su etiqueta. Informa por consola del
#' título de la tabla, que también se guarda en el atributo `"titulo"`.
#'
#' Necesita el paquete eurostat y conexión a internet.
#'
#' @param id el código de una tabla de Eurostat; p. ej. `"crim_off_cat"`.
#' @param lang idioma de las etiquetas y del título: `"en"` (por
#'   defecto), `"fr"` o `"de"`.
#' @param filters lista con filtros para descargar solo una parte de la
#'   tabla; p. ej. `list(geo = "ES")`. Se pasa a
#'   [eurostat::get_eurostat()]. Por defecto `NULL` (toda la tabla).
#'   Con filtros Eurostat no devuelve la columna `flags`.
#'
#' @return Un data frame con los datos de la tabla y el atributo
#'   `"titulo"`.
#'
#' @examples
#' \dontrun{
#' dd <- eurostat_download("crim_off_cat")
#' attr(dd, "titulo")
#' eurostat_download("crim_off_cat", lang = "fr", filters = list(geo = "ES"))
#' }
#' @export
eurostat_download <- function(id, lang = c("en", "fr", "de"), filters = NULL) {
  rlang::check_installed("eurostat")
  lang <- rlang::arg_match(lang)

  #- con filters eurostat no devuelve flags y llama `time` (factor) al tiempo
  df <- eurostat::get_eurostat(id, time_format = "raw", filters = filters,
                               keepFlags = is.null(filters))
  if ("time" %in% names(df) && !"TIME_PERIOD" %in% names(df)) {
    df <- dplyr::rename(df, TIME_PERIOD = "time")
    df$TIME_PERIOD <- as.character(df$TIME_PERIOD)
  }
  #- tiempo, valores y flags no tienen etiqueta: su _code sería un duplicado
  dimensiones <- setdiff(names(df), c("TIME_PERIOD", "values", "flags"))
  df <- eurostat::label_eurostat(df, code = dimensiones, lang = lang, fix_duplicated = TRUE)
  orden <- c(rbind(paste0(dimensiones, "_code"), dimensiones))
  df <- dplyr::relocate(df, dplyr::all_of(orden))

  titulo <- eurostat::label_eurostat_tables(id, lang = lang)
  cli::cli_inform("{.val {id}}: {titulo}")
  attr(df, "titulo") <- titulo
  df
}
