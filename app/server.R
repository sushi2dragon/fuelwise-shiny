library(shiny)

function(input, output, session) {
  scenario <- reactive({
    req(input$weight, input$horsepower, input$miles, input$price)
    validate(need(is.finite(input$miles) && input$miles >= 1000 && input$miles <= 30000,
                  "Enter an annual distance from 1,000 to 30,000 miles."),
             need(is.finite(input$price) && input$price >= 1 && input$price <= 10,
                  "Enter a fuel price from $1 to $10 per US gallon."))
    predict_scenario(input$weight, input$horsepower, input$miles, input$price)
  })
  observeEvent(input$reset, {
    updateSliderInput(session, "weight", value = 3)
    updateSliderInput(session, "horsepower", value = 110)
    updateNumericInput(session, "miles", value = 12000)
    updateNumericInput(session, "price", value = 4)
  })
  metric <- function(label, value, note, accent = FALSE) {
    div(class = paste("metric", if (accent) "accent" else ""),
        p(class = "eyebrow", label), div(class = "metric-value", value), p(class = "fine", note))
  }
  output$metrics <- renderUI({
    s <- scenario()
    div(class = "metrics",
      metric("PREDICTED ECONOMY", if (s$mpg > 0) sprintf("%.1f MPG", s$mpg) else "Not usable",
             "Model point estimate", TRUE),
      metric("95% PREDICTION INTERVAL", sprintf("%.1f–%.1f", s$lower, s$upper), "MPG for a comparable car"),
      metric("ANNUAL FUEL COST", if (is.finite(s$cost)) paste0("$", format(round(s$cost), big.mark = ",", trim = TRUE)) else "Not usable",
             if (is.finite(s$gallons)) sprintf("%.0f US gallons per year", s$gallons) else "Choose a plausible scenario"))
  })
  output$caution <- renderUI({
    s <- scenario()
    outside <- input$weight < min(mtcars$wt) || input$weight > max(mtcars$wt) ||
      input$horsepower < min(mtcars$hp) || input$horsepower > max(mtcars$hp)
    if (s$mpg <= 0) div(class = "notice", role = "status", "This scenario produces nonpositive MPG. Fuel consumption and cost cannot be estimated. Choose a lighter or lower-power car.")
    else if (outside || s$lower <= 0) div(class = "notice", role = "status", "Use caution: this scenario extrapolates beyond an observed input range or its interval includes nonphysical MPG. Treat it as a model demonstration.")
    else div(class = "quiet-note", "Historical-data estimate • Changing distance or price changes cost, not MPG.")
  })
  output$economyPlot <- renderPlot({
    s <- scenario()
    grid <- data.frame(wt = seq(1.5, 5.5, length.out = 120), hp = input$horsepower)
    fit <- predict(fuel_model, grid, interval = "prediction")
    par(mar = c(4.5, 4.5, 1, 1), bg = "#ffffff", fg = "#18383b", col.axis = "#526769", col.lab = "#18383b")
    plot(mtcars$wt, mtcars$mpg, type = "n", xlim = c(1.5, 5.5), ylim = range(c(0, mtcars$mpg, fit)),
         xlab = "Vehicle weight (1,000 lb)", ylab = "Fuel economy (MPG)", bty = "n")
    abline(h = seq(-10, 50, 10), col = "#edf2ef")
    polygon(c(grid$wt, rev(grid$wt)), c(fit[, "lwr"], rev(fit[, "upr"])), col = "#dfefea", border = NA)
    lines(grid$wt, fit[, "fit"], col = "#167d75", lwd = 2)
    points(mtcars$wt, mtcars$mpg, pch = 21, bg = "#a8bab8", col = "white", cex = 1.5)
    points(input$weight, s$mpg, pch = 23, bg = "#f3b65f", col = "#18383b", cex = 2)
    legend("topright", c("Observed cars", "Your scenario"), pch = c(21, 23),
           pt.bg = c("#a8bab8", "#f3b65f"), col = "#18383b", bty = "n", cex = 0.9)
  }, res = 110, alt = "Observed MPG versus weight with model predictions and a selected scenario.")
  output$modelSummary <- renderPrint({
    cat(sprintf("MPG = %.3f %+.3f × weight %+.4f × horsepower\n", coef(fuel_model)[1], coef(fuel_model)[2], coef(fuel_model)[3]))
    cat(sprintf("32 observations | Training R-squared: %.3f | Residual standard error: %.2f MPG\n", summary(fuel_model)$r.squared, sigma(fuel_model)))
  })
  output$dataTable <- renderTable({
    data.frame(Car = rownames(mtcars), MPG = mtcars$mpg, Weight = mtcars$wt, Horsepower = mtcars$hp)
  }, striped = TRUE, spacing = "s", digits = 2)
  output$download <- downloadHandler(filename = function() "fuelwise-scenario.csv", content = function(file) {
    s <- scenario()
    write.csv(data.frame(weight_1000lb = input$weight, horsepower = input$horsepower,
      annual_miles = input$miles, usd_per_us_gallon = input$price, predicted_mpg = s$mpg,
      prediction_lower_95 = s$lower, prediction_upper_95 = s$upper,
      annual_us_gallons = s$gallons, annual_cost_usd = s$cost), file, row.names = FALSE)
  })
}
