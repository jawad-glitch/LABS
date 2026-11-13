interface Position {
  symbol: string;
  name: string;
  quantity: number;
  averageCost: number;
  currentPrice: number;
  unrealizedPnL: number;
}
interface PortfolioSnapshot {
  positions: Position[];
  totalValue: number;
  totalUnrealizedPnL: number;
  asOf: string;
}
