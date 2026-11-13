const express = require('express');
const path = require('path');
const PolicyEngine = require('./policy-engine');
const AuditLogger = require('./audit-logger');

const root = path.resolve(__dirname, '..');
const roles = require(path.join(root, 'policy/role-manifest.json'));
const matrix = require(path.join(root, 'policy/permission-matrix.json'));
const engine = new PolicyEngine(roles, matrix);
const audit = new AuditLogger(path.join(root, 'audit'));

const app = express();
app.use(express.json({ limit:'32kb' }));

function evaluate(operation, resourceField, directionField, method) {
  return (req, res) => {
    const body = req.body || {};
    const userId = body.userId || 'unknown';
    const roleId = body.roleId || 'unknown';
    const resource = body[resourceField] || '';
    const direction = directionField ? body[directionField] || null : null;
    const result = method(roleId, resource, ...(directionField ? [direction] : []));
    audit.write({
      userId, roleId, operation, resource, direction,
      allowed:result.allowed, reason:result.reason,
      securityLevel:result.securityLevel ?? null
    });
    res.status(result.allowed ? 200 : 403).json({ userId, roleId, ...result });
  };
}

app.get('/health', (req,res) => res.json({
  status:'ok',
  appCount:3,
  ts:new Date().toISOString()
}));

app.post('/evaluate/intent', evaluate('INTENT','intentName',null,(r,n)=>engine.evaluateIntent(r,n)));
app.post('/evaluate/context', evaluate('CONTEXT','contextType','direction',(r,c,d)=>engine.evaluateContext(r,c,d)));
app.post('/evaluate/channel', evaluate('CHANNEL','channelId',null,(r,c)=>engine.evaluateChannel(r,c)));
app.post('/evaluate/app', evaluate('APP','appId',null,(r,a)=>engine.evaluateApp(r,a)));

app.use('/ui', express.static(path.join(root, 'apps/trading-app')));
app.use((err,req,res,next) => {
  if (err instanceof SyntaxError && err.status === 400) {
    return res.status(400).json({ error:'Malformed JSON request body' });
  }
  res.status(500).json({ error:'Internal server error' });
});

const port = Number(process.env.PORT || 3000);
app.listen(port, '0.0.0.0', () => console.log('FDC3 security enforcement server listening on ' + port));
