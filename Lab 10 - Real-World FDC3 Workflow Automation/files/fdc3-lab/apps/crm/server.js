const express = require("express");
const path = require("path");
const app = express();

app.use(express.static(path.join(__dirname, "public")));

app.get("/health", (_req, res) => res.json({ status: "ok" }));

app.listen(3001, "0.0.0.0", () => {
  console.log("CRM application listening on port 3001");
});
