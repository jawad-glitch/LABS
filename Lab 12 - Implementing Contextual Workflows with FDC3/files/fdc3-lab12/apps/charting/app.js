const statusEl = document.getElementById("status");
const symbolEl = document.getElementById("symbol");
const sourceEl = document.getElementById("source");
const canvas = document.getElementById("chart");
const ctx = canvas.getContext("2d");

let currentContext = null;
let currentSource = "contextUpdate";

window.addEventListener("fdc3status", event => {
  statusEl.textContent = event.detail.connected ? "Connected" : "Disconnected";
  statusEl.classList.toggle("online", event.detail.connected);
});

function makePrices(ticker, count = 36) {
  let seed = 2166136261;
  for (let i = 0; i < ticker.length; i++) {
    seed ^= ticker.charCodeAt(i);
    seed = Math.imul(seed, 16777619);
  }
  const random = () => {
    seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0;
    return seed / 4294967296;
  };

  let price = 90 + (seed % 80);
  const values = [];
  for (let i = 0; i < count; i++) {
    price += (random() - 0.47) * 8;
    values.push(price);
  }
  return values;
}

function drawChart() {
  if (!currentContext) return;

  const width = Math.max(320, canvas.clientWidth);
  const height = 340;
  const dpr = window.devicePixelRatio || 1;
  canvas.width = Math.round(width * dpr);
  canvas.height = Math.round(height * dpr);
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  ctx.clearRect(0, 0, width, height);

  const values = makePrices(currentContext.id.ticker);
  const min = Math.min(...values) - 5;
  const max = Math.max(...values) + 5;
  const left = 55, right = width - 18, top = 20, bottom = height - 42;
  const x = i => left + i * (right - left) / (values.length - 1);
  const y = value => bottom - (value - min) * (bottom - top) / (max - min);

  ctx.strokeStyle = "#526178";
  ctx.lineWidth = 1;
  ctx.fillStyle = "#dbe6f5";
  ctx.font = "12px Arial";

  for (let i = 0; i <= 4; i++) {
    const value = min + (max - min) * i / 4;
    const yy = y(value);
    ctx.beginPath();
    ctx.moveTo(left, yy);
    ctx.lineTo(right, yy);
    ctx.stroke();
    ctx.fillText(value.toFixed(1), 5, yy + 4);
  }

  ctx.beginPath();
  values.forEach((value, i) => {
    if (i === 0) ctx.moveTo(x(i), y(value));
    else ctx.lineTo(x(i), y(value));
  });
  ctx.strokeStyle = "#54b6ff";
  ctx.lineWidth = 2.5;
  ctx.stroke();

  values.forEach((value, i) => {
    ctx.beginPath();
    ctx.arc(x(i), y(value), 2.5, 0, Math.PI * 2);
    ctx.fillStyle = "#8bd0ff";
    ctx.fill();
  });

  ctx.fillStyle = "#dbe6f5";
  ctx.fillText("Time →", (left + right) / 2, height - 8);
  ctx.save();
  ctx.translate(14, (top + bottom) / 2);
  ctx.rotate(-Math.PI / 2);
  ctx.fillText("Price", 0, 0);
  ctx.restore();
  ctx.fillText("1", left - 3, bottom + 18);
  ctx.fillText(String(values.length), right - 10, bottom + 18);
}

function updateChart(context, source) {
  if (!context || context.type !== "fdc3.instrument") return;
  currentContext = context;
  currentSource = source;
  symbolEl.textContent = `${context.id.ticker} — ${context.name}`;
  sourceEl.textContent = `Rendered from ${source} | ${new Date().toLocaleTimeString()}`;
  drawChart();
}

async function initApp() {
  await window.fdc3.connect("charting", ["ViewChart"], ["fdc3.instrument"]);
  await window.fdc3.addContextListener("fdc3.instrument", context => {
    updateChart(context, "context broadcast");
  });
  await window.fdc3.addIntentListener("ViewChart", context => {
    updateChart(context, "ViewChart intent");
  });
}

window.addEventListener("resize", drawChart);

initApp().catch(error => {
  statusEl.textContent = "Connection failed";
  console.error("Charting initialization failed:", error);
});
