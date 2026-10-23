#' Población municipal del INE (1996, 1998-2025)
#'
#' Población municipal por género de la "Revisión del Padrón Municipal"
#' del INE: cifras oficiales de población de los municipios españoles
#' a 1 de enero de cada año. Formato largo: una fila por municipio,
#' año y categoría de población (Total, Hombres, Mujeres).
#'
#' Procesado a partir de `pobmun.zip`
#' (<https://www.ine.es/pob_xls/pobmun.zip>). El nombre del municipio
#' (`ine_muni.n`) es el vigente en el último año; `ine_muni.n.orig`
#' guarda el nombre que tenía en cada año (hay municipios que han
#' cambiado de nombre o desaparecido).
#'
#' @format Un tibble con las variables:
#' \itemize{
#'   \item ine_muni: código INE del municipio (5 dígitos)
#'   \item ine_muni.n: nombre del municipio (el del último año)
#'   \item year: año de la revisión del Padrón
#'   \item poblacion: Total, Hombres o Mujeres
#'   \item values: población
#'   \item ine_muni.n.orig: nombre del municipio en ese año
#'   \item ine_prov: código INE de la provincia (2 dígitos)
#'   \item ine_prov.n: nombre de la provincia
#'   \item ine_ccaa / ine_ccaa.n: código y nombre de la CCAA
#'   \item capital_prov / capital_ccaa: "Sí"/"No" si es capital de provincia o de CCAA
#' }
#'
#' @source INE, Revisión del Padrón Municipal
#'   \url{https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177011&menu=resultados&idp=1254734710990}
#'
#' @examples
#' \dontrun{
#' ine_pob_mun_1996_2025 |>
#'   dplyr::filter(year == 2025, poblacion == "Total") |>
#'   dplyr::slice_max(values, n = 10)
#' }
"ine_pob_mun_1996_2025"

#' Esperanza de vida, PIB per cápita y población de los países (World Bank, 1960-2024)
#'
#' Tres indicadores de los World Development Indicators del World Bank,
#' parecidos a los del paquete gapminder, para 217 países y los años
#' 1960-2024 (una fila por país y año), con la región del World Bank.
#' Descargados con el paquete wbstats.
#'
#' @format Un tibble con las variables:
#' \itemize{
#'   \item iso2c, iso3c: códigos ISO del país (2 y 3 letras)
#'   \item country: nombre del país (en inglés)
#'   \item region: región del World Bank (7 regiones)
#'   \item year: año
#'   \item esperanza_vida: esperanza de vida al nacer, en años (SP.DYN.LE00.IN)
#'   \item pib_percapita: PIB per cápita, en dólares corrientes (NY.GDP.PCAP.CD)
#'   \item poblacion: población total (SP.POP.TOTL)
#' }
#'
#' @source World Bank, World Development Indicators \url{https://databank.worldbank.org/source/world-development-indicators}
#'
#' @examples
#' \dontrun{
#' wb_paises_1960_2024 |>
#'   dplyr::filter(year == 2024) |>
#'   dplyr::slice_max(esperanza_vida, n = 10)
#' }
"wb_paises_1960_2024"

#' Premios Nobel (1901-2026)
#'
#' Todos los premios Nobel de 1901 a 2026, una fila por premio (una persona
#' u organización con dos premios sale dos veces). Datos de la API oficial de
#' la Fundación Nobel (v2.1), simplificados; son los mismos que se usaron en
#' la entrega_05 de BigData 26-27 (`nobel_api_2026.csv`).
#'
#' Ojo: EE.UU. es "USA" y los Países Bajos "the Netherlands"; las
#' organizaciones no tienen país de nacimiento ni género (NA); algunas fechas
#' incompletas en la API son NA.
#'
#' @format Un tibble con 1.036 filas y las variables:
#' \itemize{
#'   \item prize_year: año del premio
#'   \item category: Chemistry, Economics, Literature, Medicine, Peace o Physics
#'   \item full_name: nombre de la persona u organización
#'   \item laureate_type: "Individual" u "Organization"
#'   \item gender: "Male" o "Female" (NA en las organizaciones)
#'   \item birth_date: fecha de nacimiento
#'   \item birth_country: país de nacimiento (el de entonces, p. ej. "Prussia")
#'   \item birth_country_now: país de nacimiento (el de hoy, p. ej. "Poland")
#'   \item birth_continent: continente de nacimiento
#'   \item death_date: fecha de la muerte (NA si sigue vivo o es una organización)
#'   \item prize_status: "received", "declined" (rechazado) o "restricted"
#'   \item motivation: por qué le dieron el premio (en inglés)
#'   \item wikipedia: enlace a su página de la Wikipedia en inglés
#'   \item n_affiliations: nº de afiliaciones (universidad o centro) cuando le dieron el premio
#'   \item affiliation: afiliaciones, separadas por "; " si hay varias
#'   \item affiliation_country_now: país (de hoy) de cada afiliación, en el mismo orden y separados igual
#' }
#'
#' @source Fundación Nobel, API v2.1 \url{https://www.nobelprize.org/about/developer-zone-2/}
#'
#' @examples
#' \dontrun{
#' nobel_1901_2026 |>
#'   dplyr::count(birth_country, sort = TRUE)
#' }
"nobel_1901_2026"

#' Nacimientos en España en 2016 y 2019 (microdatos del INE)
#'
#' Microdatos de partos del INE (Movimiento Natural de la Población) de 2016
#' y 2019: una fila por bebé, con datos del parto, de la madre y del padre.
#' Son los datos de la prueba_01 de BigData 26-27 (`df_bebes_16y19.rds`).
#' El INE no da el municipio de los de menos de 10.000 habitantes
#' (`muni_inscrip` es NA).
#'
#' @format Un tibble con 773.669 filas y 33 variables; entre otras:
#' \itemize{
#'   \item year_parto: año del parto ("2016" o "2019", character)
#'   \item muni_inscrip / muni_inscrip.n: código INE y nombre del municipio de inscripción
#'   \item prov_inscrip / prov_inscrip.n: código INE y nombre de la provincia de inscripción
#'   \item sexo_bebe: "1" niño, "6" niña
#'   \item peso_bebe: peso en gramos
#'   \item parto_nn_semanas: semanas de gestación
#'   \item edad_madre / edad_padre: edad en años
#'   \item estudios_madre.f / estudios_padre.f, ocupacion_madre.f / ocupacion_padre.f: estudios y ocupación (factores)
#'   \item fecha_parto, nn_hijos_tot, id_parto ...
#' }
#'
#' @source INE, Movimiento Natural de la Población (microdatos de partos)
#'   \url{https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736177007&menu=resultados&idp=1254735573002}
#'
#' @examples
#' \dontrun{
#' ine_bebes_2016_2019 |>
#'   dplyr::count(year_parto, sexo_bebe)
#' }
"ine_bebes_2016_2019"

#' Población municipal del INE (1996-2020), versión antigua
#'
#' Versión antigua de [ine_pob_mun_1996_2025], con otros nombres de
#' variables: `poblacion` vale "pob_total", "pob_hombres" o "pob_mujeres" y
#' los valores están en `pob_values`. Son los datos de la prueba_01 de
#' BigData 26-27 (`df_pob_mun.rds`), que se cruzan con [ine_bebes_2016_2019].
#'
#' @format Un tibble con 584.160 filas y las variables:
#' \itemize{
#'   \item year: año de la revisión del Padrón
#'   \item ine_muni / ine_muni.n: código INE (5 dígitos) y nombre del municipio
#'   \item ine_prov / ine_prov.n: código INE (2 dígitos) y nombre de la provincia
#'   \item poblacion: "pob_total", "pob_hombres" o "pob_mujeres"
#'   \item pob_values: población
#'   \item ine_ccaa / ine_ccaa.n: código y nombre de la CCAA
#'   \item capital_prov / capital_ccaa: "Sí"/"No" si es capital de provincia o de CCAA
#' }
#'
#' @source INE, Revisión del Padrón Municipal
#'
#' @examples
#' \dontrun{
#' ine_pob_mun_1996_2020 |>
#'   dplyr::filter(year == 2019, poblacion == "pob_mujeres")
#' }
"ine_pob_mun_1996_2020"

#' Población de las capitales de provincia en los Censos históricos del INE (1842-2011)
#'
#' Población de hecho, de derecho y hogares de las 52 capitales de provincia
#' en los 18 censos de 1842 a 2011. Viene del paquete antiguo pjpv.curso.R.2022.
#'
#' @format Un tibble con 936 filas y las variables:
#' \itemize{
#'   \item ine_muni / ine_muni.n: código INE (5 dígitos) y nombre del municipio (en 2020)
#'   \item ine_prov / ine_prov.n: código INE (2 dígitos) y nombre de la provincia
#'   \item year: año del censo (1842, 1857, 1860, 1877 ... 2011)
#'   \item pob_de_hecho, pob_de_derecho: población de hecho y de derecho
#'   \item hogares: nº de hogares
#'   \item codigo_INE / nombre_INE: como ine_muni e ine_muni.n, pero sacados de la tabla del INE
#'   \item ine_ccaa / ine_ccaa.n: código y nombre de la CCAA
#'   \item capital_prov / capital_ccaa: "Sí"/"No" si es capital de provincia o de CCAA
#' }
#'
#' @source INE, Censos de población (históricos)
#'   \url{https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736176998&menu=resultados&idp=1254735572981}
#'
#' @examples
#' \dontrun{
#' ine_censos_historicos_capitales |>
#'   dplyr::filter(ine_muni.n == "Valencia")
#' }
"ine_censos_historicos_capitales"

#' Provincias y CCAA: códigos INE, capitales y códigos ISO
#'
#' Tabla con códigos INE de provincia y CCAA, sus capitales
#' (provincial y autonómica) y códigos ISO.
#' Copiada del paquete `pjpv.pkg.datos.2024` (vía `pjpv.pkg.ff.2026`).
#' La usa [arreglar_prov_names()].
#'
#' @format A tibble with 52 rows y 10 variables:
#' \itemize{
#'   \item ine_ccaa: código INE de la CCAA
#'   \item ine_ccaa.n: nombre de la CCAA
#'   \item ine_prov: código INE de la provincia
#'   \item ine_prov.n: nombre de la provincia
#'   \item capital_prov: código INE de la capital de provincia
#'   \item capital_prov.n: nombre de la capital de provincia
#'   \item capital_ccaa: código INE de la capital de la CCAA
#'   \item capital_ccaa.n: nombre de la capital de la CCAA
#'   \item iso_code_prov: código ISO de la provincia
#'   \item iso_code_ccaa: código ISO de la CCAA
#' }
#'
#' @examples
#' \dontrun{
#' ine_code_prov_pjp
#' }
"ine_code_prov_pjp"
