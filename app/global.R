library(shiny)

# R's bundled Motor Trend data: 32 cars from 1973-74.
fuel_model <- lm(mpg ~ wt + hp, data = mtcars)
predict_scenario <- function(weight, horsepower, miles, price) {
  values <- c(weight, horsepower, miles, price)
  stopifnot(length(values) == 4L, all(is.finite(values)),
            weight >= 1.5, weight <= 5.5, horsepower >= 50, horsepower <= 350,
            miles >= 1000, miles <= 30000, price >= 1, price <= 10)
  p <- predict(fuel_model, data.frame(wt = weight, hp = horsepower),
               interval = "prediction", level = 0.95)
  list(mpg = unname(p[1, "fit"]), lower = unname(p[1, "lwr"]),
       upper = unname(p[1, "upr"]),
       gallons = if (p[1, "fit"] > 0) miles / p[1, "fit"] else NA_real_,
       cost = if (p[1, "fit"] > 0) miles / p[1, "fit"] * price else NA_real_)
}
