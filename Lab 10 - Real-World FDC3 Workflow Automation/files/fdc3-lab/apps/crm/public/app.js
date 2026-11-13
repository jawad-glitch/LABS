const DA = "http://" + window.location.hostname + ":3000";

const contacts = [
  {
    name: "John Smith",
    email: "john.smith@example.com",
    company: "Global Investments",
    instruments: [
      { ticker: "NVDA", name: "NVIDIA Corporation" },
      { ticker: "AAPL", name: "Apple Inc." }
    ]
  },
  {
    name: "Sarah Johnson",
    email: "sarah.johnson@example.com",
    company: "Capital Partners",
    instruments: [
      { ticker: "MSFT", name: "Microsoft Corporation" },
      { ticker: "IBM", name: "IBM" }
    ]
  }
];

const status = document.getElementById("status");

function showStatus(message, data) {
  status.textContent = message + (data ? "\n" + JSON.stringify(data, null, 2) : "");
}

async function daPost(endpoint, body) {
  const response = await fetch(DA + endpoint, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });
  const data = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(data.reason || data.error || "HTTP " + response.status);
  return data;
}

async function raiseIntent(intent, context) {
  try {
    const result = await daPost("/raise-intent", { intent, context });
    showStatus("SUCCESS: Intent dispatched", result);
  } catch (error) {
    showStatus("ERROR: " + error.message);
  }
}

function renderContacts() {
  const root = document.getElementById("contacts");
  for (const contact of contacts) {
    const card = document.createElement("section");
    card.className = "card";

    const heading = document.createElement("h2");
    heading.textContent = contact.name;
    card.appendChild(heading);

    const details = document.createElement("p");
    details.textContent = contact.email + " | " + contact.company;
    card.appendChild(details);

    const share = document.createElement("button");
    share.textContent = "Share Contact";
    share.onclick = () => raiseIntent("ViewContact", {
      type: "fdc3.contact",
      name: contact.name,
      id: { email: contact.email }
    });
    card.appendChild(share);

    const instrumentHeading = document.createElement("h4");
    instrumentHeading.textContent = "Preferred instruments";
    card.appendChild(instrumentHeading);

    for (const instrument of contact.instruments) {
      const button = document.createElement("button");
      button.textContent = "View Instrument: " + instrument.ticker;
      button.onclick = () => raiseIntent("ViewInstrument", {
        type: "fdc3.instrument",
        name: instrument.name,
        id: { ticker: instrument.ticker }
      });
      card.appendChild(button);
    }
    root.appendChild(card);
  }
}

async function initialize() {
  try {
    const health = await fetch(DA + "/health");
    if (!health.ok) throw new Error("Desktop Agent health check failed");
    await daPost("/register-intent", {
      appId: "crm-app",
      handlerUrl: "http://localhost:3001",
      intents: []
    });
    document.getElementById("connection").textContent = "Connected and registered";
    document.getElementById("connection").style.color = "green";
  } catch (error) {
    document.getElementById("connection").textContent = "Disconnected: " + error.message;
    document.getElementById("connection").style.color = "red";
  }
}

renderContacts();
initialize();
