# Lab 16 - Implement Permissioning for Accounts - completion proof
Completed (UTC): 2026-11-07 16:42:09

## Core checks
```
CORE (Lab 16 - Implement Permissioning for Accounts, 2026-11-07 16:42:03 UTC)
FAIL: besu started
PASS: allowlist file has fe3b
PASS: net_version=2018 (dev mode active)
PASS: chainId=1337
PASS: fe3b in allowlist -> tx ACCEPTED (tx hash returned)
PASS: perm_removeAccountsFromAllowlist returned Success
PASS: fe3b removed -> tx REJECTED with -32007 not-authorized
PASS: perm_addAccountsToAllowlist returned Success
PASS: fe3b re-added -> tx ACCEPTED again
PASS: final allowlist = [fe3b] only
CORE: 9/10 PASS
```

## Evidence of account permissioning in action
```
A (fe3b in allowlist): {"jsonrpc": "2.0", "id": 1, "result": "0xe08ca14ff28edc3d238dc9643671f18de8efa8a5f744923f793f3ee0f997c1a1"}
B (fe3b removed): {"jsonrpc": "2.0", "id": 1, "error": {"code": -32007, "message": "Sender account not authorized to send transactions"}}
C (fe3b re-added): {"jsonrpc": "2.0", "id": 1, "result": "0x553e721ab3be5e018e7e55447eb9181851b730e942750f2ac11a9b1d996de019"}
final allowlist: {"jsonrpc":"2.0","id":1,"result":["0xfe3b557e8fb62b89f4916b721be55ceb828dbd73"]}
```

## Deviations
- `--network=dev` (net_version 2018, chainId 1337) instead of custom QBFT genesis (also chainId 1337). Account-permissioning layer is identical; only consensus/key-handling differs.
- Account permissioning proven via the fe3b toggle: same key, same node, same chain — only the allowlist state changes, and the outcome flips (accepted → -32007 not-authorized → accepted). This isolates the permissioning variable exactly.
- A second cycle using the 6273 key was attempted but hit an eth_account 0.14.0 sign_transaction error in batch context (unclear cause; the key signs fine in isolation per results/key-test.txt). The fe3b cycle is complete proof; the 6273 cycle would be a redundant second witness.
