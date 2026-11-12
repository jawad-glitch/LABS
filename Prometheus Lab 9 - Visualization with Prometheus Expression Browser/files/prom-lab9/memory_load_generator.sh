#!/bin/bash
echo "Generating memory load..."
# Allocate 100MB of memory
python3 -c "
import time
data = bytearray(100 * 1024 * 1024)  # 100MB
print('Memory allocated, sleeping for 60 seconds...')
time.sleep(60)
print('Memory load test completed')
" &
