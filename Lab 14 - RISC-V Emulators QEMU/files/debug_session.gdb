set pagination off
set confirm off
file debug_example
target remote 127.0.0.1:23456
break main
continue
printf "\nStopped at main:\n"
info registers pc sp a0 a1
print num
break factorial
continue
printf "\nStopped inside factorial:\n"
info registers pc sp a0 a1
print n
break divide_numbers
continue
printf "\nStopped inside divide_numbers:\n"
print a
print b
continue
detach
quit
