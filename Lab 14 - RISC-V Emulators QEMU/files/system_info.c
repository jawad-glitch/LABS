#include <stdio.h>
#include <unistd.h>
#include <sys/utsname.h>

int main(void) {
    struct utsname info;
    printf("=== RISC-V System Information ===\n");
    if (uname(&info) == 0) {
        printf("System: %s\n", info.sysname);
        printf("Node: %s\n", info.nodename);
        printf("Release: %s\n", info.release);
        printf("Version: %s\n", info.version);
        printf("Machine reported by uname: %s\n", info.machine);
    } else {
        perror("uname");
        return 1;
    }
    printf("Process ID: %d\n", getpid());
    printf("Parent process ID: %d\n", getppid());
    return 0;
}
