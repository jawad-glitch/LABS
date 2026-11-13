class PolicyEngine {
  constructor(roleManifest, permissionMatrix) {
    this.roles = roleManifest.roles || {};
    this.matrix = permissionMatrix;
  }

  check(roleId, resource, kind) {
    const role = this.roles[roleId];
    const rule = this.matrix[kind]?.[resource];
    if (!role) return { allowed:false, reason:'Unknown or unauthenticated role: ' + roleId, securityLevel:rule?.securityLevel || 'unknown' };
    if (!rule) return { allowed:false, reason:'Resource not explicitly defined; default deny', securityLevel:'unknown' };
    const level = this.matrix.roleLevels[roleId] || 0;
    const minimum = this.matrix.roleLevels[rule.minRole] || 999;
    const grants = role[kind] || [];
    if (!grants.includes(resource)) return { allowed:false, reason:'Role restriction: resource is not in role allowlist', securityLevel:rule.securityLevel || 'unknown' };
    if (level < minimum) return { allowed:false, reason:'Role is below the resource minimum role', securityLevel:rule.securityLevel || 'unknown' };
    return { allowed:true, reason:'Allowed by role grant and permission matrix', securityLevel:rule.securityLevel || 'unknown' };
  }

  evaluateIntent(roleId, intentName) {
    return this.check(roleId, intentName, 'intents');
  }

  evaluateContext(roleId, contextType, direction) {
    if (!['share','receive'].includes(direction)) {
      return { allowed:false, reason:'Invalid context direction', securityLevel:'unknown' };
    }
    return this.check(roleId, contextType.replace(/^fdc3\./, ''), 'contexts');
  }

  evaluateChannel(roleId, channelId) {
    const r = this.check(roleId, channelId, 'channels');
    return { allowed:r.allowed, reason:r.reason };
  }

  evaluateApp(roleId, appId) {
    const r = this.check(roleId, appId, 'apps');
    return { allowed:r.allowed, reason:r.reason };
  }
}

module.exports = PolicyEngine;
