class BaseIntentHandler {
  constructor(permissionManager) {
    this.permissionManager = permissionManager;
  }

  async dispatch(intentName, intentData, userContext) {
    const timestamp = new Date().toISOString();
    let decision;

    try {
      decision = await this.permissionManager.checkPermission(
        intentName, userContext, intentData || {}
      );
    } catch (error) {
      return {
        success:false,
        error:"AUDIT_FAILURE",
        message:"Permission audit could not be recorded; execution blocked.",
        timestamp
      };
    }

    if (!decision.allowed) {
      return {
        success:false,
        error:"PERMISSION_DENIED",
        message:decision.reason,
        timestamp
      };
    }

    try {
      const data = await this.execute(
        intentName, intentData || {}, userContext, decision.restrictions || {}
      );
      return {
        success:true,
        data,
        restrictions:decision.restrictions || {},
        timestamp:new Date().toISOString()
      };
    } catch (error) {
      return {
        success:false,
        error:"HANDLER_ERROR",
        message:String(error.message || error),
        timestamp:new Date().toISOString()
      };
    }
  }

  async execute() {
    throw new Error("Concrete intent handler must implement execute()");
  }
}

module.exports = BaseIntentHandler;
