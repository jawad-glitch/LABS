set pagination off
set confirm off
file bin/assembly_debug
target remote 127.0.0.1:23457
break _start
continue
printf "\n--- Assembly entry ---\n"
info registers pc sp ra
display/i $pc
stepi
info registers x1 x2 x3
stepi
info registers x1 x2 x3
break loop
continue
printf "\n--- Loop breakpoint ---\n"
info registers x6 x7 pc
stepi
info registers x6 x7 pc
x/4wx &result
detach
quit
