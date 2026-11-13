class SenderApp {
  init() {
    this.form = document.getElementById("instrument-form");
    this.preview = document.getElementById("preview");
    this.status = document.getElementById("status");
    this.form.addEventListener("input", () => this.updatePreview());
    this.form.addEventListener("submit", event => {
      event.preventDefault();
      this.broadcastContext();
    });
    this.updatePreview();
  }

  readContext() {
    const ticker = document.getElementById("ticker").value.trim();
    const name = document.getElementById("name").value.trim();
    const MIC = document.getElementById("mic").value.trim().toUpperCase();
    const ISIN = document.getElementById("isin").value.trim().toUpperCase();
    const RIC = document.getElementById("ric").value.trim();
    if (!ticker || !name || !MIC || !ISIN) throw new Error("Ticker, name, MIC and ISIN are required.");
    if (!/^[A-Z0-9]{4}$/.test(MIC)) throw new Error("MIC must contain exactly four letters or digits.");
    if (!/^[A-Z0-9]{12}$/.test(ISIN)) throw new Error("ISIN must contain exactly 12 letters or digits.");
    return { type: "fdc3.instrument", name, id: { ticker, ISIN, MIC, ...(RIC ? { RIC } : {}) } };
  }

  async broadcastContext() {
    try {
      if (!window.fdc3) throw new Error("FDC3 Desktop Agent is not available.");
      const context = this.readContext();
      this.preview.textContent = JSON.stringify(context, null, 2);
      await window.fdc3.broadcast(context);
      this.status.textContent = `Success: broadcast ${context.id.ticker} at ${new Date().toISOString()}`;
    } catch (error) {
      this.status.textContent = `Error: ${error.message}`;
    }
  }

  updatePreview() {
    try { this.preview.textContent = JSON.stringify(this.readContext(), null, 2); }
    catch (error) { this.preview.textContent = `Complete the required fields. ${error.message}`; }
  }
}
window.addEventListener("DOMContentLoaded", () => new SenderApp().init());
