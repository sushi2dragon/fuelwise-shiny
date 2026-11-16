# FuelWise — Shiny application and reproducible pitch

A complete source package for the Developing Data Products course project. The app uses R's built-in `mtcars` dataset to explore weight, horsepower, predicted MPG, uncertainty, and annual fuel cost.

## GitHub Pages deployment

The public deployment uses Posit's Shinylive to execute the R Shiny application in the visitor's browser. This provides an interactive app without a remote R server. It is not a shinyapps.io deployment and does not satisfy a literal requirement for RStudio/Shiny-server hosting; use `deploy.R` when that hosting account is connected.

To build the static deployment, install `shinylive` and run `Rscript build-site.R`. Publish the contents of the generated `site/` folder to GitHub Pages. The app is at the site root and the five-slide pitch is at `/pitch/`. The first app visit downloads an R runtime and may take a moment to load.

## Run the app

Install R and RStudio, then run in the R console:

```r
install.packages(c("shiny", "rsconnect"))
```

Open this folder as your working directory and run:

```r
source("run.R")
```

Or run `shiny::runApp("app")`. The app includes its own Start here, Model & limitations, and Observed data tabs. No external documentation is needed to use it.

## App files

- `app/ui.R`: sliders, numeric inputs, outputs, and user documentation.
- `app/server.R`: reactive predictions, plot, cost calculations, reset, and CSV download.
- `app/global.R`: fitted model and scenario calculation.
- `app/www/style.css`: responsive custom design.
- `test.R`: executable checks of the actual reactive server.
- `pitch/`: five-slide reproducible presentation, rendered HTML and supporting assets.

## Publish the Shiny app

1. Sign in to shinyapps.io and choose the free plan if available for your account.
2. In RStudio, open Tools → Global Options → Publishing → Connect, then connect shinyapps.io using that service's account setup instructions. Keep tokens out of this repository and out of chat.
3. Run `source("deploy.R")` from this folder. It uploads only the four app source/style files, not your other coursework.
4. Open the returned public URL in a signed-out browser. Change an input and confirm the output changes.

Official deployment guide: https://docs.posit.co/shinyapps.io/guide/getting_started/

## Publish the source and pitch

Create a GitHub repository containing this folder's files. Keep the pitch's HTML and libraries together. Turn on GitHub Pages for the branch/folder that contains the presentation. Use the deployed page URL for the presentation submission and the repository URL for the source submission. Do not upload `.Rhistory`, account tokens, or deployment records.

## Submission checklist

- Public Shiny application URL: pending account connection and deployment.
- GitHub source URL: pending repository creation/upload.
- Five-slide presentation URL: pending publication.

Local files are ready to run; they are not public submission URLs. Review the app and presentation before submitting them.

## Verify

From this folder, run `source("test.R")`. The test exercises the actual `server.R` reactive path, checks predictions against R's `predict()`, tests changes in distance, price, and horsepower, and checks invalid/nonphysical scenarios. With the app running, `node smoke.mjs` verifies the live Shiny server connection and generated chart output. See `VERIFICATION.md` for results and verification limits.

The model is educational. It uses 32 historical cars, fits all observations, and does not claim held-out predictive accuracy, causal effects, or suitability for modern vehicle purchasing decisions.
