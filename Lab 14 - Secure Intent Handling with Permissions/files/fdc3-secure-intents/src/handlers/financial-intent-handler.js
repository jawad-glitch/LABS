const BaseIntentHandler = require("./base-intent-handler");

class FinancialIntentHandler extends BaseIntentHandler {
  constructor(permissionManager) {
    super(permissionManager);
    this.instruments = {
      AAPL:{symbol:"AAPL",name:"Apple Inc.",classification:"public",price:190.25},
      MSFT:{symbol:"MSFT",name:"Microsoft Corp.",classification:"public",price:420.50},
      GOOGL:{symbol:"GOOGL",name:"Alphabet Inc.",classification:"public",price:175.30},
      CLASSIFIED:{symbol:"CLASSIFIED",name:"CLASSIFIED Internal Holding",classification:"restricted",price:999.99}
    };
    this.portfolios = {
      portfolio_001:{
        id:"portfolio_001",
        holdings:[
          {symbol:"AAPL",quantity:100},
          {symbol:"MSFT",quantity:50}
        ],
        totalValue:40000
      }
    };
  }

  async execute(intentName, intentData, userContext, restrictions) {
    const requestedName =
      intentData?.instrument?.id?.ticker ||
      intentData?.instrument?.id?.name ||
      intentData?.instrument?.symbol ||
      "AAPL";

    const symbol = String(requestedName).toUpperCase();
    const instrument = this.instruments[symbol] || {
      symbol,
      name:symbol,
      classification:"unknown",
      price:0
    };

    switch (intentName) {
      case "ViewChart":
        return {
          instrument,
          chart:{type:"line",points:[instrument.price * 0.98,instrument.price,instrument.price * 1.02]}
        };

      case "ViewQuote":
        return {instrument,quote:{price:instrument.price,currency:"USD"}};

      case "StartTrade": {
        const amount = Number(intentData?.trade?.amount);
        if (!Number.isFinite(amount) || amount <= 0) {
          throw new Error("A positive trade amount is required");
        }
        return {
          trade:{
            id:"TRD-" + Date.now(),
            symbol,
            side:String(intentData.trade.side || "BUY").toUpperCase(),
            amount,
            status:"PENDING_APPROVAL"
          },
          approvalId:intentData.approvalId || null
        };
      }

      case "ViewAnalysis":
        return {
          instrument,
          analysis:{
            trend:"NEUTRAL",
            risk:"MODERATE",
            classification:instrument.classification,
            summary:instrument.classification === "restricted"
              ? "Restricted instrument: handle according to internal classification policy."
              : "Mock analysis data for lab validation."
          }
        };

      case "ViewPortfolio": {
        const portfolioId = intentData?.portfolio?.id || "portfolio_001";
        const portfolio = this.portfolios[portfolioId];
        if (!portfolio) throw new Error("Portfolio not found");
        return {
          accessLevel:userContext.role,
          portfolio
        };
      }

      default:
        throw new Error("No handler implemented for intent " + intentName);
    }
  }
}

module.exports = FinancialIntentHandler;
