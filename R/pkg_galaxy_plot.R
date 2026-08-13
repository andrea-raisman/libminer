#' Package Galaxy Plot
#'
#' Draws a colorful "galaxy" of your installed packages: each package is
#' placed along a golden-angle spiral, colored by which library it lives in,
#' and (optionally) sized by its on-disk footprint. Purely decorative, but a
#' nice way to see how many packages you have and how they're spread across
#' your libraries.
#'
#' @param sizes `TRUE` (default) scales point size by each package's
#'   footprint on disk (computed with [fs::dir_info()]). `FALSE` draws every
#'   point the same size, which is much faster.
#'
#' @returns Invisibly returns the `data.frame` used to draw the plot, with
#'   one row per installed package.
#'
#' @export
#' @examples
#' \donttest{
#' pkg_galaxy_plot(sizes = FALSE)
#' }
pkg_galaxy_plot <- function(sizes = TRUE) {
  pkgs <- utils::installed.packages()
  df <- data.frame(
    Package = pkgs[, "Package"],
    Library = pkgs[, "LibPath"],
    stringsAsFactors = FALSE
  )

  if (sizes) {
    df$size <- vapply(
      file.path(df$Library, df$Package),
      function(path) sum(fs::dir_info(path, recurse = TRUE, type = "file")$size),
      FUN.VALUE = numeric(1)
    )
  } else {
    df$size <- 1
  }

  n <- nrow(df)
  golden_angle <- pi * (3 - sqrt(5))
  theta <- seq_len(n) * golden_angle
  radius <- sqrt(seq_len(n))
  df$x <- radius * cos(theta)
  df$y <- radius * sin(theta)

  lib_levels <- unique(df$Library)
  palette <- grDevices::colorRampPalette(
    c("#f72585", "#7209b7", "#3a0ca3", "#4361ee", "#4cc9f0", "#80ffdb")
  )(length(lib_levels))
  df$color <- palette[match(df$Library, lib_levels)]

  if (sizes) {
    log_size <- log1p(df$size)
    spread <- diff(range(log_size))
    point_cex <- 0.4 + 2 * (log_size - min(log_size)) / (if (spread == 0) 1 else spread)
  } else {
    point_cex <- 1
  }

  old_par <- graphics::par(bg = "black", mar = c(1, 1, 3, 1))
  on.exit(graphics::par(old_par))

  graphics::plot(
    df$x, df$y,
    pch = 19,
    cex = point_cex,
    col = grDevices::adjustcolor(df$color, alpha.f = 0.75),
    axes = FALSE, xlab = "", ylab = "",
    asp = 1
  )
  graphics::title(
    main = sprintf(
      "%d packages across %d librar%s",
      n, length(lib_levels), if (length(lib_levels) == 1) "y" else "ies"
    ),
    col.main = "white", font.main = 1
  )

  invisible(df)
}
