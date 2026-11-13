interface RegisterMessage {
  type: "register";
  appName: string;
  intentHandlers: string[];
}
interface BroadcastMessage {
  type: "broadcast";
  channelId: "red" | "orange" | "yellow" | "green" | "blue" | "purple";
  context: FDC3Context;
}
interface RaiseIntentMessage {
  type: "raiseIntent";
  intent: string;
  context: FDC3Context;
}
interface JoinChannelMessage {
  type: "joinChannel";
  channelId: "red" | "orange" | "yellow" | "green" | "blue" | "purple";
}
interface FDC3Context {
  type: string;
  name: string;
  id: Record<string, string>;
}
