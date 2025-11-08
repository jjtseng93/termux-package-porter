#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    int ret = syscall(SYS_faccessat2, -100, ".", R_OK, 0);
    if (ret == 0) {
        puts("✅ faccessat2 supported and call succeeded (read access ok)");
        return 0;
    } else {
        if (errno == ENOSYS) {
            puts("❌ faccessat2 not supported (ENOSYS)");
        } else {
            printf("✅ faccessat2 supported but returned errno = %d (%s)\n",
                   errno, strerror(errno));
        }
        return 0;
    }
}
