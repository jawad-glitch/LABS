const fs = require('fs');
const path = require('path');

class AuditLogger {
  constructor(logDir) {
    this.logDir = logDir;
    fs.mkdirSync(logDir, { recursive:true });
  }
  filename() {
    return path.join(this.logDir, 'audit-' + new Date().toISOString().slice(0,10) + '.jsonl');
  }
  write(record) {
    const entry = {
      timestamp:new Date().toISOString(),
      userId:record.userId || 'unknown',
      roleId:record.roleId || 'unknown',
      operation:record.operation,
      resource:record.resource,
      direction:record.direction ?? null,
      allowed:Boolean(record.allowed),
      reason:String(record.reason || ''),
      securityLevel:record.securityLevel ?? null
    };
    fs.appendFileSync(this.filename(), JSON.stringify(entry) + '\n', { mode:0o600 });
  }
  readSession() {
    const f = this.filename();
    return fs.existsSync(f) ? fs.readFileSync(f,'utf8').split('\n').filter(Boolean).map(JSON.parse) : [];
  }
  readDenials() {
    return fs.readdirSync(this.logDir)
      .filter(f => f.startsWith('audit-') && f.endsWith('.jsonl'))
      .flatMap(f => fs.readFileSync(path.join(this.logDir,f),'utf8').split('\n').filter(Boolean).map(line => {
        try { return JSON.parse(line); } catch (_) { return null; }
      }).filter(Boolean))
      .filter(r => r.allowed === false);
  }
}
module.exports = AuditLogger;
