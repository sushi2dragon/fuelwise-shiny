# From this folder: Rscript run.R
.libPaths(c("../tmp/R-library", .libPaths()))
shiny::runApp("app", host = "127.0.0.1", port = 3838, launch.browser = interactive())
