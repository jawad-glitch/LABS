const test = require("node:test");
const assert = require("node:assert/strict");
const toolkit = require("../src");

test("greets a supplied name", () => {
  assert.equal(toolkit.greet("Raheel"), "Hello, Raheel!");
});

test("uses fallback for empty input", () => {
  assert.equal(toolkit.greet(""), "Hello, Open Source!");
});

test("normalizes repeated whitespace", () => {
  assert.equal(toolkit.normalizeName("  Open   Source  "), "Open Source");
});

test("handles non-string names safely", () => {
  assert.equal(toolkit.greet(123), "Hello, Open Source!");
});

test("returns project metadata", () => {
  assert.equal(toolkit.projectInfo().license, "MIT");
});
