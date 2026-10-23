#' Compara las etiquetas de una variable en dos df
#'
#' `pjp_etiquetas_comunes()` sirve para chequear si dos df usan las
#' mismas etiquetas para los mismos códigos. Se queda con las
#' combinaciones únicas de `vv_codes` y `vv_etiquetas` de cada df y las
#' une por `vv_codes`; las etiquetas de cada df quedan en columnas con
#' sufijo `..df1` y `..df2` y la columna `coinciden` indica si son
#' iguales. El resultado se ordena por `vv_codes`.
#'
#' Si en algún df un código tiene más de una etiqueta se avisa, porque
#' en ese caso el join multiplica filas.
#'
#' @param df1 un data frame.
#' @param df2 otro data frame.
#' @param vv_codes el nombre de la vv. donde están los códigos; se acepta
#'   NSE (`codes`) o string (`"codes"`).
#' @param vv_etiquetas el nombre de la vv. donde están las etiquetas; se
#'   acepta NSE (`labels`) o string (`"labels"`).
#' @param tipo_join tipo de join: `"full"` (por defecto), `"left"` o
#'   `"right"`; se aceptan también `"full_join"`, `"left_join"` y
#'   `"right_join"`.
#' @param solo_diferencias si es `TRUE` solo se devuelven las filas en
#'   las que `coinciden` no es `TRUE`; por defecto `FALSE`.
#'
#' @return Un data frame con `vv_codes`, las etiquetas de cada df y
#'   `coinciden`: `TRUE` si la etiqueta es la misma en los dos df
#'   (dos `NA` cuentan como iguales), `FALSE` si es distinta y `NA` si
#'   el código solo está en uno de los df.
#'
#' @examples
#' df1 <- data.frame(cod = c(1, 2, 3), etiq = c("a", "b", "c"))
#' df2 <- data.frame(cod = c(1, 2, 4), etiq = c("a", "B", "d"))
#' pjp_etiquetas_comunes(df1, df2, cod, etiq)
#' pjp_etiquetas_comunes(df1, df2, "cod", "etiq", tipo_join = "left")
#' pjp_etiquetas_comunes(df1, df2, cod, etiq, solo_diferencias = TRUE)
#' @export
pjp_etiquetas_comunes <- function(df1, df2, vv_codes, vv_etiquetas,
                                  tipo_join = c("full", "left", "right", "full_join", "left_join", "right_join"),
                                  solo_diferencias = FALSE) {
  vv_codes <- rlang::as_name(rlang::ensym(vv_codes))
  vv_etiquetas <- rlang::as_name(rlang::ensym(vv_etiquetas))
  tipo_join <- sub("_join$", "", rlang::arg_match(tipo_join))

  #- 1 y "01" podrían no ser lo mismo: mejor parar que convertir
  cod_1 <- df1[[vv_codes]]
  cod_2 <- df2[[vv_codes]]
  compatibles <- (is.numeric(cod_1) && is.numeric(cod_2)) ||
    ((is.character(cod_1) || is.factor(cod_1)) && (is.character(cod_2) || is.factor(cod_2))) ||
    identical(class(cod_1), class(cod_2))
  if (!compatibles) {
    cli::cli_abort(c(
      "{.var {vv_codes}} no es del mismo tipo en los dos df.",
      "x" = "en {.arg df1} es {.cls {class(cod_1)}} y en {.arg df2} es {.cls {class(cod_2)}}."
    ))
  }

  zz_1 <- dplyr::distinct(df1, dplyr::across(dplyr::all_of(c(vv_codes, vv_etiquetas))))
  zz_2 <- dplyr::distinct(df2, dplyr::across(dplyr::all_of(c(vv_codes, vv_etiquetas))))

  #- un código con varias etiquetas multiplica filas en el join
  for (nombre_df in c("df1", "df2")) {
    cods <- list(df1 = zz_1, df2 = zz_2)[[nombre_df]][[vv_codes]]
    dups <- unique(cods[duplicated(cods)])
    if (length(dups) > 0) {
      cli::cli_warn("en {.arg {nombre_df}} hay codigos con mas de una etiqueta: {.val {dups}}")
    }
  }

  unir <- switch(tipo_join,
    full = dplyr::full_join,
    left = dplyr::left_join,
    right = dplyr::right_join
  )
  et_1 <- paste0(vv_etiquetas, "..df1")
  et_2 <- paste0(vv_etiquetas, "..df2")
  aa <- unir(zz_1, zz_2, by = vv_codes, suffix = c("..df1", "..df2"),
             relationship = "many-to-many")

  en_los_dos <- aa[[vv_codes]] %in% zz_1[[vv_codes]] & aa[[vv_codes]] %in% zz_2[[vv_codes]]
  iguales <- dplyr::coalesce(
    as.character(aa[[et_1]]) == as.character(aa[[et_2]]),
    is.na(aa[[et_1]]) & is.na(aa[[et_2]])
  )
  aa$coinciden <- ifelse(en_los_dos, iguales, NA)

  if (solo_diferencias) {
    aa <- aa[!aa$coinciden %in% TRUE, , drop = FALSE]
  }
  dplyr::arrange(aa, .data[[vv_codes]])
}
