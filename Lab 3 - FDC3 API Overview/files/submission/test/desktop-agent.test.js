const fdc3 = require("../config/desktop-agent.js");

beforeEach(() => fdc3._reset());

test("default broadcast delivers context", async () => {
  const handler = jest.fn();
  await fdc3.addContextListener(null, handler);
  const context = { type: "fdc3.instrument", id: { ticker: "AAPL" } };
  await fdc3.broadcast(context);
  expect(handler).toHaveBeenCalledWith(context);
});

test("typed listener filters other context types", async () => {
  const handler = jest.fn();
  await fdc3.addContextListener("fdc3.instrument", handler);
  await fdc3.broadcast({ type: "fdc3.contact", name: "Ada" });
  expect(handler).not.toHaveBeenCalled();
  await fdc3.broadcast({ type: "fdc3.instrument", id: { ticker: "MSFT" } });
  expect(handler).toHaveBeenCalledTimes(1);
});

test("intent resolution exposes source, version and result", async () => {
  const handler = jest.fn();
  await fdc3.addIntentListener("ViewChart", handler);
  const context = { type: "fdc3.instrument", id: { ticker: "NVDA" } };
  const resolution = await fdc3.raiseIntent("ViewChart", context);
  expect(resolution.source).toBeTruthy();
  expect(resolution.version).toBe("2.0");
  expect(await resolution.getResult()).toMatchObject({ delivered: true, intent: "ViewChart", context });
  expect(handler).toHaveBeenCalledTimes(1);
});

test("named channels are isolated from the default channel and each other", async () => {
  const defaultHandler = jest.fn();
  const channelHandler = jest.fn();
  await fdc3.addContextListener(null, defaultHandler);
  const channel = await fdc3.getOrCreateChannel("private");
  await channel.addContextListener(null, channelHandler);
  channel.broadcast({ type: "fdc3.instrument", id: { ticker: "AAPL" } });
  expect(channelHandler).toHaveBeenCalledTimes(1);
  expect(defaultHandler).not.toHaveBeenCalled();
});

test("unsubscribe stops future context notifications", async () => {
  const handler = jest.fn();
  const subscription = await fdc3.addContextListener(null, handler);
  await fdc3.broadcast({ type: "fdc3.instrument" });
  subscription.unsubscribe();
  await fdc3.broadcast({ type: "fdc3.instrument" });
  expect(handler).toHaveBeenCalledTimes(1);
});
