class SecurityTestClient {
  constructor(baseUrl) { this.baseUrl = baseUrl.replace(/\/$/,''); }

  async post(endpoint, body) {
    try {
      const response = await fetch(this.baseUrl + endpoint, {
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify(body)
      });
      return { httpStatus:response.status, ...(await response.json()) };
    } catch (error) {
      return { httpStatus:0, error:error.message };
    }
  }

  testIntent(userId,roleId,intentName) {
    return this.post('/evaluate/intent',{userId,roleId,intentName});
  }
  testContext(userId,roleId,contextType,direction) {
    return this.post('/evaluate/context',{userId,roleId,contextType,direction});
  }
  testChannel(userId,roleId,channelId) {
    return this.post('/evaluate/channel',{userId,roleId,channelId});
  }
  testApp(userId,roleId,appId) {
    return this.post('/evaluate/app',{userId,roleId,appId});
  }
}
window.SecurityTestClient = SecurityTestClient;
