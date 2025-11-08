// compile: gcc -shared -fPIC no_faccessat2_fallback.c -o no_faccessat2_fallback.so -ldl
#define _GNU_SOURCE
#include <dlfcn.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/syscall.h>
#include <stdio.h>

// 部分環境缺少常數與宣告，手動補上
#ifndef AT_FDCWD
#define AT_FDCWD -100
#endif
#ifndef SYS_faccessat2
#define SYS_faccessat2 439  // aarch64/x86_64 通用
#endif

// 定義指向原始 faccessat 的函式指標
typedef int (*orig_faccessat_t)(int, const char*, int, int);

// 攔截 faccessat2 syscall 封裝
int faccessat2(int dirfd, const char *pathname, int mode, int flags) {
printf("  *** Someone calling faccessat2 ***  ");

    int ret = syscall(SYS_faccessat2, dirfd, pathname, mode, flags);
    if (ret == 0) return 0;

    // 若 kernel 不支援 faccessat2，轉用 faccessat
    if (errno == ENOSYS) {
        static orig_faccessat_t real_faccessat = NULL;
        if (!real_faccessat) {
            real_faccessat = dlsym(RTLD_NEXT, "faccessat");
            if (!real_faccessat) {
                // 若無法取到，退到 access()
                return access(pathname, mode);
            }
        }
        return real_faccessat(AT_FDCWD, pathname, mode, 0);
    }

    return ret;
}
