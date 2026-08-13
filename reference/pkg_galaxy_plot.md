# Package Galaxy Plot

Draws a colorful "galaxy" of your installed packages: each package is
placed along a golden-angle spiral, colored by which library it lives
in, and (optionally) sized by its on-disk footprint. Purely decorative,
but a nice way to see how many packages you have and how they're spread
across your libraries.

## Usage

``` r
pkg_galaxy_plot(sizes = TRUE)
```

## Arguments

- sizes:

  `TRUE` (default) scales point size by each package's footprint on disk
  (computed with
  [`fs::dir_info()`](https://fs.r-lib.org/reference/dir_ls.html)).
  `FALSE` draws every point the same size, which is much faster.

## Value

Invisibly returns the `data.frame` used to draw the plot, with one row
per installed package.

## Examples

``` r
# \donttest{
pkg_galaxy_plot(sizes = FALSE)

# }
```
