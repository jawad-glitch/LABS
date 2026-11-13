const express = require('express');
const cors = require('cors');
const fs = require('fs-extra');
const path = require('path');

const app = express();
const PORT = 3001;
const DATA_FILE = path.join(__dirname, 'apps.json');
const TEMP_FILE = path.join(__dirname, 'apps.json.tmp');

let applications = [];

async function saveApps() {
  await fs.writeJson(TEMP_FILE, { applications }, { spaces: 2 });
  await fs.rename(TEMP_FILE, DATA_FILE);
}

async function loadApps() {
  await fs.ensureFile(DATA_FILE);
  const data = await fs.readJson(DATA_FILE).catch(() => ({ applications: [] }));
  applications = Array.isArray(data.applications) ? data.applications : [];
  if (!Array.isArray(data.applications)) await saveApps();
}

app.use(cors());
app.use(express.json({ limit: '1mb' }));

app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    appCount: applications.length,
    ts: new Date().toISOString()
  });
});

app.get('/v2/apps/search', (req, res) => {
  const intent = typeof req.query.intent === 'string' ? req.query.intent.toLowerCase() : null;
  const context = typeof req.query.context === 'string' ? req.query.context : null;

  const results = applications.filter(record => {
    const intents = Array.isArray(record.intents) ? record.intents : [];
    const intentMatch = !intent || intents.some(item =>
      typeof item.name === 'string' && item.name.toLowerCase() === intent
    );
    const contextMatch = !context || intents.some(item =>
      Array.isArray(item.contexts) && item.contexts.includes(context)
    );
    return intentMatch && contextMatch;
  });

  res.json({ applications: results });
});

app.get('/v2/apps', (req, res) => {
  res.json({ applications });
});

app.get('/v2/apps/:appId', (req, res) => {
  const record = applications.find(item => item.appId === req.params.appId);
  if (!record) return res.status(404).json({ error: 'Application not found' });
  res.json(record);
});

app.post('/v2/apps', async (req, res, next) => {
  try {
    const record = req.body;
    if (!record || typeof record !== 'object' || Array.isArray(record)) {
      return res.status(400).json({ error: 'Request body must be a JSON object' });
    }
    if (!record.appId || typeof record.appId !== 'string' ||
        !record.name || typeof record.name !== 'string' ||
        !record.type || typeof record.type !== 'string') {
      return res.status(400).json({ error: 'appId, name and type are required strings' });
    }
    if (applications.some(item => item.appId === record.appId)) {
      return res.status(409).json({ error: 'appId already exists', appId: record.appId });
    }
    if (record.intents !== undefined &&
        (!Array.isArray(record.intents) || record.intents.some(item =>
          !item || typeof item.name !== 'string' ||
          !Array.isArray(item.contexts) ||
          item.contexts.some(context => typeof context !== 'string')
        ))) {
      return res.status(400).json({ error: 'Each intent requires a name and contexts array' });
    }
    if (record.categories !== undefined &&
        (!Array.isArray(record.categories) ||
         record.categories.some(category => typeof category !== 'string'))) {
      return res.status(400).json({ error: 'categories must be an array of strings' });
    }

    applications.push(record);
    await saveApps();
    res.status(201).json(record);
  } catch (error) {
    next(error);
  }
});

app.use((err, req, res, next) => {
  if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
    return res.status(400).json({ error: 'Malformed JSON request body' });
  }
  console.error('Request error:', err.message);
  res.status(500).json({ error: 'Internal server error' });
});

loadApps().then(() => {
  const server = app.listen(PORT, '0.0.0.0', () => {
    console.log(`FDC3 App Directory listening on port ${PORT}`);
    console.log(`Loaded ${applications.length} application records`);
  });

  const pidFile = path.join(__dirname, 'server.pid');
  fs.writeFileSync(pidFile, String(process.pid));

  function shutdown() {
    server.close(async () => {
      try { await fs.remove(pidFile); } catch (_) {}
      process.exit(0);
    });
  }
  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);
}).catch(error => {
  console.error('Could not load App Directory:', error.message);
  process.exitCode = 1;
});
