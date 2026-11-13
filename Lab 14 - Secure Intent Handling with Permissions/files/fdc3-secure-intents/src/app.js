const express = require("express");
const cors = require("cors");
const UserManager = require("./auth/user-manager");
const PermissionManager = require("./permissions/permission-manager");
const FinancialIntentHandler = require("./handlers/financial-intent-handler");

async function main() {
  const userManager = await new UserManager().initialize();
  const permissionManager = new PermissionManager();
  const intentHandler = new FinancialIntentHandler(permissionManager);

  const app = express();
  app.disable("x-powered-by");
  app.use(cors());
  app.use(express.json({limit:"100kb"}));

  function authenticate(req, res, next) {
    const header = req.headers.authorization || "";
    const match = header.match(/^Bearer\s+(.+)$/i);
    if (!match) {
      return res.status(401).json({error:"UNAUTHORIZED",message:"Bearer token required"});
    }
    const user = userManager.verifyToken(match[1]);
    if (!user) {
      return res.status(401).json({error:"UNAUTHORIZED",message:"Token invalid or expired"});
    }
    req.user = user;
    next();
  }

  app.get("/health", (req, res) => res.json({status:"ok"}));

  app.post("/auth/login", async (req, res) => {
    try {
      const result = await userManager.authenticate(req.body?.username, req.body?.password);
      res.json(result);
    } catch (_) {
      res.status(401).json({error:"INVALID_CREDENTIALS"});
    }
  });

  app.get("/auth/verify", authenticate, (req, res) => {
    res.json({valid:true,user:req.user});
  });

  app.post("/intents/:intentName", authenticate, async (req, res) => {
    const result = await intentHandler.dispatch(
      req.params.intentName, req.body || {}, req.user
    );
    res.status(result.success ? 200 : result.error === "PERMISSION_DENIED" ? 403 : 500)
      .json(result);
  });

  app.get("/permissions/audit", authenticate, async (req, res) => {
    try {
      const limit = Math.min(1000, Math.max(1, Number(req.query.limit) || 50));
      res.json(await permissionManager.getAuditLog(limit));
    } catch (error) {
      res.status(500).json({error:"AUDIT_READ_FAILED",message:error.message});
    }
  });

  app.use((error, req, res, next) => {
    console.error("Request error:", error.message);
    res.status(400).json({error:"BAD_REQUEST",message:"Invalid request"});
  });

  const port = Number(process.env.PORT || 3014);
  app.listen(port, "0.0.0.0", () => {
    console.log("FDC3 Secure Intent API listening on port " + port);
  });
}

main().catch(error => {
  console.error("Startup failed:", error);
  process.exitCode = 1;
});
