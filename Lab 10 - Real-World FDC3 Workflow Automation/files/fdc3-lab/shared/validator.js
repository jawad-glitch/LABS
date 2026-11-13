function validateContext(intentName, context) {
  if (!context || typeof context !== "object" || Array.isArray(context)) {
    return { valid: false, reason: "Context must be a JSON object" };
  }

  const expected = {
    ViewContact: "fdc3.contact",
    ViewInstrument: "fdc3.instrument"
  }[intentName];

  if (!expected) {
    return { valid: false, reason: "Unsupported intent: " + intentName };
  }

  if (context.type !== expected) {
    return {
      valid: false,
      reason: `Intent ${intentName} requires context type ${expected}`
    };
  }

  if (!context.id || typeof context.id !== "object") {
    return { valid: false, reason: "Context id object is required" };
  }

  if (intentName === "ViewContact" &&
      (!context.name || !context.id.email)) {
    return { valid: false, reason: "Contact requires name and id.email" };
  }

  if (intentName === "ViewInstrument" &&
      (!context.name || !context.id.ticker)) {
    return { valid: false, reason: "Instrument requires name and id.ticker" };
  }

  return { valid: true };
}

module.exports = validateContext;
