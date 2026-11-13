# FDC3 Lab 3 — API Overview

This project is a **local teaching simulation** of selected FDC3-style behaviors. It is not a production Desktop Agent, full FDC3 2.0 implementation, or conformance certification.

## Run
- `npm test` runs five Jest behavior tests.
- `npm start` serves the two browser apps at `http://localhost:8080`.
- Blotter: `/apps/blotter/`
- Chart: `/apps/chart/`

The browser apps share one in-page mock agent. Because each browser tab has its own JavaScript runtime, this mock does not provide cross-tab transport. The automated tests validate the selected API behaviors in-process.
