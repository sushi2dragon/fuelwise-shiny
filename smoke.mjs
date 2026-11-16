// Live server check: run the app, then node smoke.mjs.
// Exercises Shiny's WebSocket protocol; browser interaction/visual QA is separate.
import assert from 'node:assert/strict';
const socket = new WebSocket('ws://127.0.0.1:3838/websocket');
let phase = 0;
let plotSeen = false;
const timeout = setTimeout(() => { console.error('FAIL: Shiny response timed out'); process.exit(1); }, 20000);
socket.addEventListener('error', (event) => { if (phase === 3 && plotSeen) return; console.error('FAIL: socket error', event.message); process.exit(1); });
socket.addEventListener('message', ({data}) => {
  const message = JSON.parse(data);
  if (message.config) socket.send(JSON.stringify({method: 'init', data: {
    weight: 3, horsepower: 110, miles: 12000, price: 4, reset: 0, details: 'Start here',
    '.clientdata_output_economyPlot_width': 900, '.clientdata_output_economyPlot_height': 350,
    '.clientdata_output_economyPlot_hidden': false,
    '.clientdata_output_metrics_hidden': false, '.clientdata_output_caution_hidden': false,
    '.clientdata_pixelratio': 1, '.clientdata_url_protocol': 'http:',
    '.clientdata_url_hostname': '127.0.0.1', '.clientdata_url_port': '3838',
    '.clientdata_url_pathname': '/', '.clientdata_url_search': '', '.clientdata_url_hash_initial': ''
  }}));
  if (message.errors && Object.keys(message.errors).length) throw new Error(JSON.stringify(message.errors));
  if (message.values?.economyPlot?.src) plotSeen = true;
  const html = message.values?.metrics?.html;
  if (!html) return;
  if (phase === 0) {
    assert.match(html, /22\.1 MPG/); assert.match(html, /2,172/);
    phase = 1;
    socket.send(JSON.stringify({method: 'update', data: {miles: 24000}}));
  } else if (phase === 1) {
    assert.match(html, /22\.1 MPG/); assert.match(html, /4,344/);
    phase = 2;
    socket.send(JSON.stringify({method: 'update', data: {horsepower: 210}}));
  } else if (phase === 2) {
    assert.match(html, /18\.9 MPG/);
    assert.ok(plotSeen, 'Live plot output must have been generated');
    phase = 3;
    clearTimeout(timeout); socket.close();
    console.log('PASS: live Shiny session and plot: default 22.1 MPG / $2,172; double miles $4,344 with same MPG; 210 hp gives 18.9 MPG.');
  }
});
