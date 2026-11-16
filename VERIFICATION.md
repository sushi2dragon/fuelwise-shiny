# Verification record

Verified locally on November 16, 2026.

- The running Shiny endpoint returned HTTP 200 and included the app inputs and embedded documentation.
- `Rscript test.R` passed: UI construction, actual reactive server calculations, interval values, displayed metric HTML, annual distance and price scaling, horsepower changes, extrapolation warning, and invalid annual distance.
- `node smoke.mjs` passed against the running app's WebSocket endpoint: generated chart output; default 22.1 MPG / $2,172; doubling annual miles to 24,000 kept MPG unchanged and produced $4,344; raising horsepower to 210 changed the result to 18.9 MPG.
- Independent R reference: default prediction 22.0988 MPG, 95% prediction interval 16.6858–27.5117 MPG, annual fuel cost $2,172.07.
- Slidify source was rendered through `slidify::slidify()`. The resulting HTML contains five content slides including the title, and evaluated R output. Slidify also emits a decorative backdrop element, which is not a presentation page.

Public deployment: GitHub Pages build `6410605343ae23cb3a416245902b4117b57548f3` completed successfully. Both the application landing page and `/pitch/` return HTTP 200 without authentication. The public pitch has five content slides, and the public repository includes the original `app/server.R`.

The deployment uses Posit's Shinylive to execute R in the browser. A shinyapps.io/remote R server deployment is still pending a connected hosting account.

Initial local verification limits: native browser automation could not select Chrome because its URL could not be determined; the in-app browser could not access localhost. Live protocol checks verified server responses separately from browser interactions.
