set pagination off
set confirm off
file bin/debug_improved
target remote 127.0.0.1:23458
break main
continue
info locals
break find_max
continue
print size
print arr[0]@5
watch max
continue
info locals
backtrace
detach
quit
