const { DesktopAgent } = require("../agent/core");
describe("Mock FDC3 Desktop Agent", () => {
 let a;
 beforeEach(() => { a = new DesktopAgent(); a.connect("research",{title:"Research"}); a.connect("chart",{title:"Chart"}); a.connect("trading",{title:"Trading"}); });
 test("connects application sessions", () => { expect(a.getInfo("research").title).toBe("Research"); });
 test("returns null for unknown metadata", () => { expect(a.getInfo("missing")).toBeNull(); });
 test("joins a user channel", () => { expect(a.joinChannel("research","red").channel).toBe("red"); });
 test("rejects invalid channel session", () => { expect(()=>a.joinChannel("missing","red")).toThrow(); });
 test("validates FDC3 context type", () => { expect(()=>a.broadcast("research",{type:"bad"})).toThrow(); });
 test("delivers context to matching listener", () => {
   a.joinChannel("research","red"); a.joinChannel("chart","red");
   const fn=jest.fn(); a.addContextListener("chart","fdc3.instrument",fn);
   a.broadcast("research",{type:"fdc3.instrument",id:{ticker:"AAPL"}});
   expect(fn).toHaveBeenCalledTimes(1);
 });
 test("does not deliver to another channel", () => {
   a.joinChannel("research","red"); a.joinChannel("chart","blue");
   const fn=jest.fn(); a.addContextListener("chart","fdc3.instrument",fn);
   a.broadcast("research",{type:"fdc3.instrument"}); expect(fn).not.toHaveBeenCalled();
 });
 test("does not deliver a different context type", () => {
   const fn=jest.fn(); a.addContextListener("chart","fdc3.instrument",fn);
   a.broadcast("research",{type:"fdc3.contact"}); expect(fn).not.toHaveBeenCalled();
 });
 test("removes context listener", () => {
   const token=a.addContextListener("chart","fdc3.instrument",jest.fn());
   expect(a.removeContextListener("chart",token)).toBe(true);
   expect(a.removeContextListener("chart",token)).toBe(false);
 });
 test("registers and resolves an intent", () => {
   a.addIntentHandler("trading","PlaceOrder",x=>({accepted:x.quantity===10}));
   expect(a.raiseIntent("research","PlaceOrder",{quantity:10}).status).toBe("resolved");
 });
 test("returns unresolved when no intent handler exists", () => {
   expect(a.raiseIntent("research","UnknownIntent",{}).status).toBe("unresolved");
 });
 test("returns application metadata", () => {
   expect(a.getInfo("trading")).toMatchObject({appId:"trading",title:"Trading"});
 });
});
