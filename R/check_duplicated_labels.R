#' Comprueba si dos vv. de un df tienen valores únicos compartidos
#'
#' `check_duplicated_labels()` chequea si 2 variables de un df tienen
#' valores únicos entre ellas dos; es decir, que un valor de una de
#' las variables se corresponde con un único valor de la segunda
#' variable (& viceversa).
#'
#' Los `NA` participan en el chequeo: un `NA` en códigos y otro en
#' etiquetas cuentan como una combinación única. Si hay `NA`s se
#' avisa de ello.
#'
#' @param df (a data frame)
#' @param vv_codes (el nombre de la vv. donde están los códigos);
#'   se acepta NSE (`codes`) o string (`"codes"`)
#' @param vv_etiquetas (el nombre de la vv. donde están las etiquetas);
#'   se acepta NSE (`labels`) o string (`"labels"`)
#'
#' @return Invisible: `TRUE` si el mapeo es 1:1, `FALSE` si no. Además
#'   muestra por consola el número de códigos, etiquetas y
#'   combinaciones únicas y, si falla, qué valores están duplicados.
#'
#' @examples
#' check_duplicated_labels(ine_code_prov_pjp, ine_prov, ine_prov.n)
#' check_duplicated_labels(ine_code_prov_pjp, "ine_prov", "ine_prov.n")
#' @export
check_duplicated_labels <- function(df, vv_codes, vv_etiquetas) {
  #- aceptar NSE (codes) o string ("codes")
  vv_codes <- rlang::ensym(vv_codes)
  vv_etiquetas <- rlang::ensym(vv_etiquetas)

  aa <- df |> dplyr::distinct(!!vv_codes, !!vv_etiquetas)
  aa1 <- nrow(aa)
  aa2 <- aa |> dplyr::distinct(!!vv_codes) |> nrow()
  aa3 <- aa |> dplyr::distinct(!!vv_etiquetas) |> nrow()

  cli::cli_inform(
    "codigos unicos: {aa2}; etiquetas unicas: {aa3}; combinaciones unicas: {aa1}"
  )

  #- los NA cuentan como combinaciones: avisar de su presencia
  n_na <- aa |>
    dplyr::filter(is.na(!!vv_codes) | is.na(!!vv_etiquetas)) |>
    nrow()
  if (n_na > 0) {
    cli::cli_warn("{n_na} combinacion{?es} contienen NA y participan en el chequeo")
  }

  todo_ok <- aa1 == aa2 && aa2 == aa3
  if (!todo_ok) {
    #- diagnóstico: qué valores no mapean 1:1
    labels_dup <- aa |>
      dplyr::count(!!vv_etiquetas) |>
      dplyr::filter(.data$n > 1) |>
      dplyr::pull(!!vv_etiquetas)
    codes_dup <- aa |>
      dplyr::count(!!vv_codes) |>
      dplyr::filter(.data$n > 1) |>
      dplyr::pull(!!vv_codes)
    if (length(codes_dup) > 0 && length(labels_dup) > 0) {
      cli::cli_warn("no es un mapeo 1:1: codigos con mas de una etiqueta: {.val {codes_dup}}; etiquetas con mas de un codigo: {.val {labels_dup}}")
    } else if (length(codes_dup) > 0) {
      cli::cli_warn("no es un mapeo 1:1: codigos con mas de una etiqueta: {.val {codes_dup}}")
    } else {
      cli::cli_warn("no es un mapeo 1:1: etiquetas con mas de un codigo: {.val {labels_dup}}")
    }
  }
  invisible(todo_ok)
}
