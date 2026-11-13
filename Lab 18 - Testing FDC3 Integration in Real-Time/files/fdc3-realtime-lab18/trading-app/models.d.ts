interface Instrument {
  symbol: string;
  name: string;
  price: number;
  change: number;
  changePercent: number;
}
interface OrderRequest {
  symbol: string;
  quantity: number;
  side: "buy" | "sell";
}
interface OrderConfirmation {
  orderId: string;
  symbol: string;
  quantity: number;
  side: "buy" | "sell";
  executedPrice: number;
  timestamp: string;
  status: "filled";
}
