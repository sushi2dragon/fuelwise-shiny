# First connect your account through RStudio's Publishing settings.
# This script never embeds tokens or account secrets.
accounts <- rsconnect::accounts()
accounts <- accounts[accounts$server == "shinyapps.io", , drop = FALSE]
if (nrow(accounts) != 1L) stop("Connect exactly one shinyapps.io account in RStudio, or specify account explicitly in deploy.R.")
rsconnect::deployApp(appDir = "app", appName = "fuelwise-explorer",
  appTitle = "FuelWise - Fuel Economy Explorer", account = accounts$name[[1]],
  server = "shinyapps.io", appFiles = c("global.R", "ui.R", "server.R", "www/style.css"),
  launch.browser = FALSE)
