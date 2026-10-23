# pjpv.curso.R.2026

Paquete de R con los **datos y algunas funciones** que usamos en el curso de
introducción a R para el manejo de datos (curso 2026-27).

## Instalación

Solo hay que hacerlo una vez (tarda un poco, porque el paquete lleva bastantes datos):

```r
pak::pak("perezp44/pjpv.curso.R.2026")
```

Si no tienes el paquete `pak`, instálalo antes con `install.packages("pak")`.

## Datos

| dataset | contenido | fuente |
|---|---|---|
| `wb_paises_1960_2025` | esperanza de vida, PIB per cápita y población de 217 países (en 2025 aún no hay esperanza de vida) | World Bank |
| `nobel_1901_2026` | premios Nobel de 1901 a 2026, una fila por premio | Fundación Nobel |
| `ine_pob_mun_1996_2025` | población municipal por género (1996, 1998-2025) | INE, Padrón Municipal |
| `ine_pob_mun_1996_2020` | población municipal por género (1996-2020), versión anterior con otros nombres de variables | INE, Padrón Municipal |
| `ine_bebes_2016_2019` | nacimientos de 2016 y 2019, una fila por bebé | INE, microdatos de partos |
| `ine_censos_historicos_capitales` | población de las capitales de provincia en los censos de 1842 a 2011 | INE, Censos históricos |
| `ine_code_prov_pjp` | códigos INE de provincias y CCAA, con sus capitales | INE |

Para usar un dataset no hace falta cargar el paquete con `library()`:

```r
library(tidyverse)
df <- pjpv.curso.R.2026::wb_paises_1960_2025

df |>
  filter(year == 2024) |>
  slice_max(esperanza_vida, n = 5)
```

En la ayuda de cada dataset (p. ej. `?pjpv.curso.R.2026::nobel_1901_2026`)
tienes la descripción de sus variables.

## Funciones

Las más útiles para el curso:

- `pjp_dicc(df)`: un diccionario del df (tipo de cada variable, nº de valores
  únicos, NA's, mínimo, máximo, media ...).
- `pjp_valores_unicos(df)` y `pjp_unique_values(df)`: los valores únicos de cada
  variable.
- `pjp_estadisticos_basicos(df)`: estadísticos básicos de cada variable.
- `df_decimales(df, nn = 2)`: redondea las columnas numéricas de un df.
- `borrar_todo_excepto(c("df", "df_2"))`: borra los objetos del Global
  environment salvo los que le digas.
- `theme_pjp_maps()`: un tema de ggplot2 para mapas.
- `%not_in%`: lo contrario de `%in%`.

```r
pjpv.curso.R.2026::pjp_dicc(pjpv.curso.R.2026::nobel_1901_2026)
```

Y otras que uso yo para preparar los datos: `arreglar_prov_names()`,
`check_duplicated_labels()`, `pjp_etiquetas_comunes()`, `pjp_ff_etiquetas()`,
`eurostat_download()`, `pjp_round_nice()`, `open_urls()` y `pjp_ruta_a_carpeta()`.
