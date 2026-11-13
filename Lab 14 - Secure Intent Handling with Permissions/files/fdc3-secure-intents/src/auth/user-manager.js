const fs = require("fs/promises");
const path = require("path");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const ROOT = path.resolve(__dirname, "../..");
const CONFIG_FILE = path.join(ROOT, "config/app-config.json");
const USERS_FILE = path.join(ROOT, "data/users.json");

const ROLE_LEVELS = {
  viewer: 25,
  trader: 50,
  financial_analyst: 75,
  admin: 100
};

class UserManager {
  constructor() {
    this.config = null;
    this.users = [];
  }

  async initialize() {
    this.config = JSON.parse(await fs.readFile(CONFIG_FILE, "utf8"));
    if (!this.config.security?.jwtSecret || !this.config.security?.tokenExpiry) {
      throw new Error("JWT security configuration is incomplete");
    }

    try {
      this.users = JSON.parse(await fs.readFile(USERS_FILE, "utf8"));
    } catch (error) {
      if (error.code !== "ENOENT") throw error;
      const defaults = [
        {id:"user-admin",username:"admin",password:"admin123",role:"admin"},
        {id:"user-analyst",username:"analyst",password:"analyst123",role:"financial_analyst"},
        {id:"user-trader",username:"trader",password:"trader123",role:"trader"},
        {id:"user-viewer",username:"viewer",password:"viewer123",role:"viewer"}
      ];
      this.users = [];
      for (const user of defaults) {
        this.users.push({
          id:user.id,
          username:user.username,
          role:user.role,
          passwordHash:await bcrypt.hash(user.password, 10)
        });
      }
      await fs.writeFile(USERS_FILE, JSON.stringify(this.users, null, 2), {mode:0o600});
    }
    return this;
  }

  async authenticate(username, password) {
    const user = this.users.find(item => item.username === username);
    if (!user || !(await bcrypt.compare(String(password || ""), user.passwordHash))) {
      throw new Error("INVALID_CREDENTIALS");
    }

    const permissionLevel = ROLE_LEVELS[user.role];
    if (!permissionLevel) throw new Error("INVALID_CREDENTIALS");

    const payload = {
      userId:user.id,
      username:user.username,
      role:user.role,
      permissionLevel
    };
    const token = jwt.sign(payload, this.config.security.jwtSecret, {
      expiresIn:this.config.security.tokenExpiry
    });

    return {
      token,
      user:{
        id:user.id,
        username:user.username,
        role:user.role,
        permissionLevel
      }
    };
  }

  verifyToken(token) {
    try {
      if (!this.config) return null;
      const payload = jwt.verify(token, this.config.security.jwtSecret);
      if (!payload.userId || !payload.username || !payload.role ||
          !Number.isInteger(payload.permissionLevel)) return null;
      return {
        userId:payload.userId,
        username:payload.username,
        role:payload.role,
        permissionLevel:payload.permissionLevel
      };
    } catch (_) {
      return null;
    }
  }
}

module.exports = UserManager;
