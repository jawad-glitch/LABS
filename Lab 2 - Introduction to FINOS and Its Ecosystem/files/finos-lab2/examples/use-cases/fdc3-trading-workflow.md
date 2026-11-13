# FDC3 Trading Workflow Use Case

## Scenario
A trader selects an instrument in a market-data application.

## Workflow
1. The market-data application creates an `fdc3.instrument` context.
2. The application broadcasts the context through its FDC3 API.
3. A connected trading application receives the context.
4. The trading application displays the selected instrument.
5. Other compatible applications may use the same context for research or portfolio analysis.

## Benefits
- Less repeated manual data entry.
- More consistent instrument selection.
- Faster movement between compatible applications.

This is an illustrative workflow, not a claim that every application supports these capabilities.
