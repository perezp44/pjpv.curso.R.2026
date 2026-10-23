#' Abre un grupo de URLs en el navegador
#'
#' `open_urls()` abre en el navegador cada una de las URLs de un vector,
#' con el navegador de `getOption("browser")`.
#'
#' Antes de abrirlas se quitan los `NA`, las cadenas vacías y las URLs
#' repetidas, y se añade `https://` a las que no indican protocolo
#' (p. ej. `"www.google.com"`). Si quedan más de `max` URLs no se abre
#' ninguna y se da un error.
#'
#' @param urls vector de caracteres con las URLs a abrir; por defecto
#'   `"https://www.google.com"`.
#' @param max nº máximo de URLs que se abren; por defecto 20. Con
#'   `max = Inf` no hay límite.
#'
#' @return Invisible: las URLs abiertas, ya limpias. Se invoca por su
#'   efecto lateral.
#'
#' @examples
#' if (interactive()) {
#'   open_urls("https://perezp44.github.io/intro-ds-21-22-web/")
#'   open_urls(c("www.r-project.org", "https://cran.r-project.org"))
#' }
#' @export
open_urls <- function(urls = "https://www.google.com", max = 20) {
  urls <- as.character(urls)
  urls <- unique(urls[!is.na(urls) & trimws(urls) != ""])
  #- sin protocolo algunos navegadores lo toman como un archivo local
  sin_protocolo <- !grepl("^[a-zA-Z][a-zA-Z0-9+.-]*:", urls)
  urls[sin_protocolo] <- paste0("https://", urls[sin_protocolo])
  urls <- unique(urls)

  if (length(urls) > max) {
    cli::cli_abort(c(
      "hay {length(urls)} URLs y el maximo es {max}; no se abre ninguna.",
      "i" = "usa {.code max = Inf} para abrirlas todas."
    ))
  }
  for (url in urls) {
    utils::browseURL(url, browser = getOption("browser"))
  }
  invisible(urls)
}
