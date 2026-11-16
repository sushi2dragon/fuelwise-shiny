# Run from shiny-project: Rscript test.R
source("app/global.R")
ui <- source("app/ui.R")$value
stopifnot(inherits(ui, "shiny.tag.list"))
server <- source("app/server.R")$value
reference <- predict(lm(mpg ~ wt + hp, mtcars), data.frame(wt = 3, hp = 110), interval = "prediction")
shiny::testServer(server, {
  session$setInputs(weight = 3, horsepower = 110, miles = 12000, price = 4)
  a <- scenario()
  stopifnot(abs(a$mpg - reference[1, "fit"]) < 1e-10,
            abs(a$lower - reference[1, "lwr"]) < 1e-10,
            abs(a$upper - reference[1, "upr"]) < 1e-10,
            abs(a$cost - 48000 / a$mpg) < 1e-10,
            grepl(sprintf("%.1f MPG", a$mpg), output$metrics$html, fixed = TRUE))
  session$setInputs(miles = 24000)
  b <- scenario()
  stopifnot(a$mpg == b$mpg, abs(b$cost - 2 * a$cost) < 1e-10)
  session$setInputs(price = 8)
  stopifnot(abs(scenario()$cost - 4 * a$cost) < 1e-10)
  session$setInputs(horsepower = 210)
  stopifnot(scenario()$mpg < a$mpg,
            grepl(sprintf("%.1f MPG", scenario()$mpg), output$metrics$html, fixed = TRUE))
  session$setInputs(weight = 5.5, horsepower = 350)
  stopifnot(scenario()$lower < 0, is.finite(scenario()$cost),
            grepl("Use caution", output$caution$html, fixed = TRUE))
  session$setInputs(miles = -1)
  err <- tryCatch({scenario(); FALSE}, error = function(e) inherits(e, "shiny.silent.error"))
  stopifnot(err)
})
cat(sprintf("PASS: reactive default %.4f MPG; 95%% PI %.4f to %.4f; annual cost $%.2f\n", reference[1,1], reference[1,2], reference[1,3], 48000/reference[1,1]))
cat("PASS: distance and price scaling, horsepower update, rendered values, nonphysical interval warning, invalid distance.\n")
