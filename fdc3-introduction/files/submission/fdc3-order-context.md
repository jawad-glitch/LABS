# Custom FDC3 Order Context

Context type: `fdc3.order`

| Field | Type | Required | Description |
|---|---|---:|---|
| type | string | Yes | Must equal `fdc3.order` |
| id | string | Yes | Unique order identifier |
| instrument | object | Yes | Instrument identity |
| instrument.ticker | string | Yes | Instrument ticker |
| instrument.MIC | string | No | Market Identifier Code |
| side | string | Yes | BUY or SELL |
| quantity | number | Yes | Positive order quantity |
| orderType | string | Yes | MARKET or LIMIT |

Example:

    {
      "type": "fdc3.order",
      "id": "order-001",
      "instrument": {"ticker": "AAPL", "MIC": "XNAS"},
      "side": "BUY",
      "quantity": 10,
      "orderType": "MARKET"
    }

This is a lab-defined context schema, not a claim of official FDC3 standardization.
