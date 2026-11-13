const fs = require("fs/promises");
const path = require("path");

const ROOT = path.resolve(__dirname, "../..");
const CONFIG_FILE = path.join(ROOT, "config/app-config.json");
const AUDIT_FILE = path.join(ROOT, "logs/permission-audit.json");

class PermissionManager {
  constructor() {
    this.config = JSON.parse(require("fs").readFileSync(CONFIG_FILE, "utf8"));
    this.writeQueue = Promise.resolve();
  }

  async _appendAudit(record) {
    const operation = async () => {
      await fs.mkdir(path.dirname(AUDIT_FILE), {recursive:true});
      let records = [];
      try {
        records = JSON.parse(await fs.readFile(AUDIT_FILE, "utf8"));
        if (!Array.isArray(records)) records = [];
      } catch (error) {
        if (error.code !== "ENOENT") throw error;
      }
      records.push(record);
      records = records.slice(-1000);
      await fs.writeFile(AUDIT_FILE, JSON.stringify(records, null, 2), {mode:0o600});
      await fs.chmod(AUDIT_FILE, 0o600);
    };

    this.writeQueue = this.writeQueue.then(operation);
    await this.writeQueue;
  }

  async checkPermission(intentName, userContext, intentData = {}) {
    const user = userContext || {};
    let allowed = false;
    let reason = "UNKNOWN_INTENT";
    let restrictions = {};

    const policy = this.config.permissions.intents[intentName];

    if (policy) {
      if (!Number.isFinite(user.permissionLevel) ||
          user.permissionLevel < policy.minimumLevel) {
        reason = "INSUFFICIENT_PERMISSION_LEVEL";
      } else if (!policy.allowedRoles.includes(user.role)) {
        reason = "ROLE_NOT_ALLOWED";
      } else if (intentName === "StartTrade" &&
          Number(intentData?.trade?.amount) > this.config.permissions.maxTradeAmount) {
        reason = "TRADE_AMOUNT_EXCEEDED";
      } else {
        allowed = true;
        reason = "PERMISSION_GRANTED";
        if (intentName === "StartTrade") {
          restrictions = {maxTradeAmount:this.config.permissions.maxTradeAmount};
        }
      }
    }

    const record = {
      timestamp:new Date().toISOString(),
      intentName:String(intentName || "UNKNOWN"),
      userId:String(user.userId || "unknown"),
      username:String(user.username || "unknown"),
      role:String(user.role || "unknown"),
      permissionLevel:Number.isFinite(user.permissionLevel) ? user.permissionLevel : 0,
      allowed,
      reason
    };

    await this._appendAudit(record);
    return {allowed,reason,restrictions};
  }

  async getAuditLog(limit = 50) {
    await this.writeQueue;
    let records = [];
    try {
      records = JSON.parse(await fs.readFile(AUDIT_FILE, "utf8"));
      if (!Array.isArray(records)) records = [];
    } catch (error) {
      if (error.code !== "ENOENT") throw error;
    }
    const count = Math.max(0, Math.min(1000, Number(limit) || 50));
    return records.slice(-count).reverse();
  }
}

module.exports = PermissionManager;
