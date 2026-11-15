set pagination off
set confirm off
file bin/debug_example
target remote 127.0.0.1:23456
break main
continue
printf "\n--- At main ---\n"
info registers pc sp ra
print num
print fact_result
print numbers
break factorial
continue
printf "\n--- At factorial ---\n"
print n
info registers a0 sp ra
break find_max
continue
printf "\n--- At find_max ---\n"
print size
print arr[0]@6
watch test_value
continue
printf "\n--- After watchpoint ---\n"
print test_value
info locals
backtrace
detach
quit
