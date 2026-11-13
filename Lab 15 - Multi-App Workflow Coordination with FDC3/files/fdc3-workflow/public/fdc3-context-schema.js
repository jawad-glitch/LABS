export function makePortfolioContext(portfolioId, clientId, name, holdings) {
  return {
    type: "fdc3.portfolio",
    id: { portfolio: portfolioId, client: clientId },
    portfolioId,
    clientId,
    name,
    holdings,
    source: "portfolio-app",
    timestamp: new Date().toISOString()
  };
}

export function makeContactContext(clientId, name, email, segment) {
  return {
    type: "fdc3.contact",
    id: { client: clientId },
    clientId,
    name,
    email,
    segment,
    source: "crm-app",
    timestamp: new Date().toISOString()
  };
}

export function makeInstrumentContext(ticker, name, exchange) {
  return {
    type: "fdc3.instrument",
    id: { ticker },
    ticker,
    name,
    exchange,
    source: "market-data-app",
    timestamp: new Date().toISOString()
  };
}
