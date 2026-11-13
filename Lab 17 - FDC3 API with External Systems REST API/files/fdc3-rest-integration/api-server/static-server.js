const express = require("express");
const path = require("path");
const app = express();
const publicDir = path.join(__dirname, "..", "public");
app.use(express.static(publicDir));
app.get("/", (req, res) => res.redirect("/market-data-viewer.html"));
app.listen(8090, "0.0.0.0", () => {
  console.log("FDC3 browser applications listening on http://0.0.0.0:8090");
});
