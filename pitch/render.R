args <- commandArgs(trailingOnly = FALSE)
script <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
setwd(dirname(normalizePath(script, mustWork = TRUE)))

.libPaths(c("../../tmp/R-library", .libPaths()))

# Slidify 0.5 calls a Markdown helper removed in markdown 2.
# Render the slide body as an HTML fragment using its supported API.
if (!"markdownExtensions" %in% getNamespaceExports("markdown")) {
  assignInNamespace("md2html", function(md) {
    commonmark::markdown_html(md, extensions = "table")
  }, ns = "slidify")
}

# Slidify's package-table check can miss packages in a project library.
assignInNamespace("is_installed", function(package) {
  nzchar(system.file(package = package))
}, ns = "slidify")

slidify::slidify("index.Rmd")

# Keep Slidify's HTML and navigation usable without network access.
jquery <- system.file("libraries/widgets/quiz/js/jquery.js", package = "slidifyLibraries")
jquery_dir <- "libraries/widgets/quiz/js"
dir.create(jquery_dir, recursive = TRUE, showWarnings = FALSE)
stopifnot(file.copy(jquery, jquery_dir, overwrite = TRUE))

html <- readLines("index.html", encoding = "UTF-8", warn = FALSE)
cdn <- grepl("ajax.aspnetcdn.com", html, fixed = TRUE)
html[cdn] <- '  <script src="libraries/widgets/quiz/js/jquery.js"></script>'
html <- html[!grepl("window.jQuery || document.write", html, fixed = TRUE)]
writeLines(html, "index.html", useBytes = TRUE)

framework_css <- "libraries/frameworks/io2012/css/slidify.css"
css <- readLines(framework_css, warn = FALSE)
writeLines(css[!grepl("fonts.googleapis.com", css, fixed = TRUE)], framework_css)

slide_config <- "libraries/frameworks/io2012/js/slide_config.js"
config <- readLines(slide_config, warn = FALSE)
fonts_start <- match("    fonts: [", config)
if (!is.na(fonts_start)) {
  fonts_end <- match("    ],", config)
  writeLines(config[-seq.int(fonts_start, fonts_end)], slide_config)
}

unlink("index.md")
