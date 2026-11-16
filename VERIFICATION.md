# Verification record

Verified locally on November 16, 2026.

- The running Shiny endpoint returned HTTP 200 and included the app inputs and embedded documentation.
- `Rscript test.R` passed: UI construction, actual reactive server calculations, interval values, displayed metric HTML, annual distance and price scaling, horsepower changes, extrapolation warning, and invalid annual distance.
- `node smoke.mjs` passed against the running app's WebSocket endpoint: generated chart output; default 22.1 MPG / $2,172; doubling annual miles to 24,000 kept MPG unchanged and produced $4,344; raising horsepower to 210 changed the result to 18.9 MPG.
- Independent R reference: default prediction 22.0988 MPG, 95% prediction interval 16.6858–27.5117 MPG, annual fuel cost $2,172.07.
- Slidify source was rendered through `slidify::slidify()`. The resulting HTML contains five content slides including the title, and evaluated R output. Slidify also emits a decorative backdrop element, which is not a presentation page.

Limits: native browser automation could not select Chrome because its URL could not be determined; the in-app browser could not access localhost. App visual layout, actual mouse/keyboard input bindings, reset, and the CSV download have not been verified in a browser. Live protocol checks verify server responses, not those browser interactions. Public deployment is pending account connection and repository setup.
