#' Tema de ggplot2 para mapas
#'
#' `theme_pjp_maps()` es un tema de ggplot2 apropiado para mapas: parte
#' de [ggplot2::theme_minimal()] y quita ejes y rejilla, con fondo gris
#' claro y fuente Ubuntu. Por defecto la leyenda va dentro del gráfico,
#' abajo a la derecha.
#'
#' @param base_size tamaño base del texto; por defecto 11. El título es
#'   un 40% mayor.
#' @param family fuente del texto; por defecto `"Ubuntu"`. Si no está
#'   instalada (o el dispositivo gráfico no la encuentra, como el PDF),
#'   usa `family = ""` para la fuente por defecto.
#' @param legend_pos posición de la leyenda: un vector numérico de 2
#'   elementos con sus coordenadas dentro del gráfico (entre 0 y 1; por
#'   defecto `c(0.9, 0.2)`) o una posición de ggplot2 (`"bottom"`,
#'   `"right"`, `"top"`, `"left"` o `"none"`).
#'
#' @return Un tema de ggplot2 (objeto de clase `theme`).
#'
#' @examples
#' library(ggplot2)
#' # family = "" para que el ejemplo funcione aunque no esté la fuente Ubuntu
#' pp <- ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   labs(title = "Un mapa (de calor)")
#' pp + theme_pjp_maps(family = "")
#' pp + theme_pjp_maps(base_size = 14, family = "", legend_pos = "bottom")
#' @export
theme_pjp_maps <- function(base_size = 11, family = "Ubuntu", legend_pos = c(0.9, 0.2)) {
  if (is.numeric(legend_pos)) {
    if (length(legend_pos) != 2) {
      cli::cli_abort("si {.arg legend_pos} es numerico debe tener 2 elementos.")
    }
    posicion <- ggplot2::theme(legend.position = "inside", legend.position.inside = legend_pos)
  } else {
    legend_pos <- rlang::arg_match(legend_pos, c("bottom", "right", "top", "left", "none"))
    posicion <- ggplot2::theme(legend.position = legend_pos)
  }

  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      text = ggplot2::element_text(family = family, color = "#22211d"),
      axis.line = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
      panel.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
      legend.background = ggplot2::element_rect(fill = "#f5f5f2", color = NA),
      panel.border = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold"),
      strip.background = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(size = ggplot2::rel(1.4), face = "bold")
    ) +
    posicion
}
