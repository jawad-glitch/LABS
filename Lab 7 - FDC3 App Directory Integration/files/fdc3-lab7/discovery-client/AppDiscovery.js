const http = require('http');

class AppDiscovery {
  constructor(directoryBaseUrl) {
    this.directoryBaseUrl = directoryBaseUrl;
  }

  _get(pathname) {
    return new Promise((resolve, reject) => {
      let url;
      try {
        url = new URL(pathname, this.directoryBaseUrl);
        if (url.protocol !== 'http:') throw new Error('Only HTTP URLs are supported');
      } catch (error) {
        reject(error);
        return;
      }

      const request = http.get(url, response => {
        let body = '';
        response.setEncoding('utf8');
        response.on('data', chunk => body += chunk);
        response.on('end', () => {
          if (response.statusCode < 200 || response.statusCode >= 300) {
            reject(new Error('HTTP ' + response.statusCode));
            return;
          }
          try {
            resolve(JSON.parse(body));
          } catch (error) {
            reject(error);
          }
        });
      });
      request.setTimeout(5000, () => request.destroy(new Error('Request timed out')));
      request.on('error', reject);
    });
  }

  async listAll() {
    try {
      const data = await this._get('/v2/apps');
      return Array.isArray(data.applications) ? data.applications : [];
    } catch (_) {
      return [];
    }
  }

  async findByIntent(intentName) {
    try {
      const data = await this._get('/v2/apps/search?intent=' + encodeURIComponent(intentName));
      const records = Array.isArray(data.applications) ? data.applications : [];
      return records.filter(app => Array.isArray(app.intents) &&
        app.intents.some(item => item.name.toLowerCase() === String(intentName).toLowerCase()));
    } catch (_) {
      return [];
    }
  }

  async findByContext(contextType) {
    try {
      const data = await this._get('/v2/apps/search?context=' + encodeURIComponent(contextType));
      const records = Array.isArray(data.applications) ? data.applications : [];
      return records.filter(app => Array.isArray(app.intents) &&
        app.intents.some(item => Array.isArray(item.contexts) && item.contexts.includes(contextType)));
    } catch (_) {
      return [];
    }
  }

  async findByCategory(category) {
    try {
      const records = await this.listAll();
      return records.filter(app => Array.isArray(app.categories) &&
        app.categories.includes(category));
    } catch (_) {
      return [];
    }
  }

  async getCapabilities(appId) {
    try {
      const data = await this._get('/v2/apps/' + encodeURIComponent(appId));
      const intents = Array.isArray(data.intents) ? data.intents : [];
      return {
        intents: [...new Set(intents.map(item => item.name).filter(Boolean))],
        contexts: [...new Set(intents.flatMap(item =>
          Array.isArray(item.contexts) ? item.contexts : []
        ))]
      };
    } catch (_) {
      return null;
    }
  }
}

module.exports = AppDiscovery;
