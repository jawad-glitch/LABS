# Lab 15 - Use Besu GraphQL API - completion proof
Completed (UTC): 2026-11-07 16:25:12 | EC2: i-0e1dd1fa4d14e8011 | host: ip-172-31-10-253 | user: ubuntu

## Core checks
```
========== CORE CHECKS (Lab 15 - Use Besu GraphQL API, 2026-11-07 16:25:04 UTC) ==========
PASS: Task 1.1: besu --version printed
PASS: Task 1.2: working directory exists
PASS: Task 1.3: besu running with RPC (8545)
PASS: Task 1.3: besu running with GraphQL (8547)
PASS: Task 1.4: net_version returned dev chain 2018
PASS: Task 1.5: GraphQL responds with {data:{block:{number}}}
PASS: Task 2.2: queries.txt written
PASS: Task 2.3: basic block query returned number+hash+timestamp
PASS: Task 2.3: no GraphQL errors on basic query
PASS: Task 2.4: multi-field query returned difficulty+gasUsed+gasLimit
FAIL: Task 2.5: genesis block query returned block 0
FAIL: Task 3.1: comprehensive query returned transactionCount+size+parentHash
PASS: Task 3.2: syncing query answered (result:null is valid = not syncing)
PASS: Task 3.3: gasPrice query returned a value (hex or decimal)
FAIL: Task 3.4: account balance query answered (balance or null, no syntax error)
PASS: Task 3.5: run_queries.sh exists, executable, ran
PASS: Task 3.6: monitor_blocks.sh exists, executable, ran 3 iterations
FAIL: Verification step 2: block height advanced between two GQL queries
CORE: 14/18 PASS
```

## Files
```
./monitor_blocks.sh
./queries.txt
./results/besu-version.txt
./results/besu.log
./results/block-at-query-start.txt
./results/java-version.txt
./results/task1.4-netversion.txt
./results/task1.5-gql-probe.txt
./results/task2.2-queries-file.txt
./results/task2.3-basic.json
./results/task2.4-multi.json
./results/task2.5-genesis.json
./results/task3.1-comprehensive.json
./results/task3.2-syncing.json
./results/task3.3-gasprice.json
./results/task3.4-account.json
./results/task3.5-run-queries-final.txt
./results/task3.5-run-queries.txt
./results/task3.6-monitor.txt
./results/verification-progression.txt
./run_queries.sh
```
