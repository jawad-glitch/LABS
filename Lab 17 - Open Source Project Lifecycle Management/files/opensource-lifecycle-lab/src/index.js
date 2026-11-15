function greet(name) {
  const value = typeof name === "string" ? name.trim() : "";
  return `Hello, ${value || "Open Source"}!`;
}

module.exports = { greet };

function normalizeName(name) {
  return typeof name === "string" ? name.trim().replace(/\s+/g, " ") : "";
}

module.exports.normalizeName = normalizeName;

function projectInfo() {
  return {
    name: "opensource-lifecycle-toolkit",
    license: "MIT"
  };
}

module.exports.projectInfo = projectInfo;
