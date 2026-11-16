# From the project folder: Rscript build-site.R
# install.packages("shinylive") once before building.
.libPaths(c("../tmp/R-library", .libPaths()))
shinylive::export("app", "site", wasm_packages = TRUE,
                 template_params = list(title = "FuelWise - Fuel Economy Explorer"))
dir.create("site/pitch", recursive = TRUE, showWarnings = FALSE)
files <- list.files("pitch", full.names = TRUE, all.files = TRUE, no.. = TRUE)
stopifnot(all(file.copy(files, "site/pitch", recursive = TRUE, overwrite = TRUE)))
file.create("site/.nojekyll")
