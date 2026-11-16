# FuelWise pitch

Open `index.html` in a browser. Use the left/right arrow keys to move through exactly five slides, including the title slide. Keep `assets/` and `libraries/` beside the HTML file.

This is a genuine Slidify presentation. Slide 3 executes an R regression and displays the predicted MPG and annual fuel cost. Slide 4 executes R code to draw the prediction interval.

## Rebuild

Install these packages in R:

```r
install.packages(c("remotes", "knitr", "markdown", "commonmark", "whisker", "yaml"))
remotes::install_github("ramnathv/slidify")
remotes::install_github("ramnathv/slidifyLibraries")
```

From the project folder, run in a terminal:

```text
Rscript pitch/render.R
```

The script uses Slidify 0.5 and contains a session-local compatibility adapter for modern Markdown. It also replaces remote font and jQuery references with local assets. The HTML and support folders are already rendered; you do not need R to view them.

## Publish

Publish the entire directory using GitHub Pages. Include `.nojekyll` at the published site root. Do not upload only `index.html` to RPubs: this deck needs the bundled assets, and the assignment specifies GitHub Pages for Slidify.

Official Slidify documentation: https://slidify.github.io/start/
