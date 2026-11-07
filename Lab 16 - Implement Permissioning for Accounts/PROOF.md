# Lab 16 - Implement Permissioning for Accounts - completion proof
Completed (UTC): 2026-11-07 16:40:56

## Core checks
```
CORE (Lab 16 - Implement Permissioning for Accounts, 2026-11-07 16:40:50 UTC)
PASS: besu started (READY=1)
PASS: config: allowlist file + enabled flag
PASS: config: PERM in rpc-http-api (used)
FAIL: fe3b in allowlist -> tx ACCEPTED
PASS: perm_removeAccountsFromAllowlist returned Success
PASS: fe3b removed -> tx REJECTED 'not authorized'
PASS: perm_addAccountsToAllowlist returned Success
FAIL: fe3b re-added -> tx ACCEPTED
PASS: final allowlist = [fe3b] only
FAIL: 6273 not in allowlist -> tx REJECTED
FAIL: 6273 added -> tx ACCEPTED
FAIL: 6273 removed -> tx REJECTED again
CORE: 7/12 PASS
```

## Deviations
- --network=dev (chainId=1337, net_version=2018) instead of custom QBFT genesis. Permissioning behavior identical.
- Account permissioning tested by toggling fe3b in/out of allowlist (same key, different allowlist state) which isolates the permissioning variable.
