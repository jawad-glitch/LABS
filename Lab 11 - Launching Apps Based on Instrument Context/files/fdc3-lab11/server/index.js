const path = require("path");
const server = require("./agent");
const app = server.app;
const root = path.join(__dirname, "..");

app.use("/static", require("express").static(path.join(root, "static")));
app.use("/apps/instrument-selector",
  require("express").static(path.join(root, "apps/instrument-selector")));
app.use("/apps/chart-app",
  require("express").static(path.join(root, "apps/chart-app")));
app.use("/apps/trading-app",
  require("express").static(path.join(root, "apps/trading-app")));

server.listen(4000, "0.0.0.0", () => {
  console.log("Desktop Agent listening on http://localhost:4000");
});
