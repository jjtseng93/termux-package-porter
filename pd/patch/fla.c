// compile: clang -shared -fPIC fake_linkat_dup_cp.c -o fake_linkat_dup_cp.so -ldl
#define _GNU_SOURCE
#include <dlfcn.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>

typedef int (*orig_linkat_t)(int, const char *, int, const char *, int);

static int copy_fd_to_path(int srcfd, const char *dstpath) {
    int dstfd = open(dstpath, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (dstfd < 0) return -1;

    char buf[8192];
    ssize_t r;
    while ((r = read(srcfd, buf, sizeof(buf))) > 0) {
        ssize_t w = write(dstfd, buf, r);
        if (w != r) { close(dstfd); return -1; }
    }

    fsync(dstfd);
    close(dstfd);
    return 0;
}

int linkat(int olddirfd, const char *oldpath,
           int newdirfd, const char *newpath, int flags)
{
    static orig_linkat_t real_linkat = NULL;
    if (!real_linkat)
        real_linkat = dlsym(RTLD_NEXT, "linkat");

    // 僅處理 /proc/self/fd/N 這種情況
    if (strncmp(oldpath, "/proc/self/fd/", 14) == 0) {
        int fdnum = atoi(oldpath + 14);
        if (fdnum > 0) {
            int dupfd = dup(fdnum);
            if (dupfd >= 0) {
                int ret = copy_fd_to_path(dupfd, newpath);
                close(dupfd);
                if (ret == 0) {
                    fprintf(stderr, "[fake_linkat_cp] fd %d → %s (copied)\n", fdnum, newpath);
                    return 0;
                } else {
                    fprintf(stderr, "[fake_linkat_cp] copy_fd failed for fd %d → %s: %s\n",
                            fdnum, newpath, strerror(errno));
                }
            }
        }
    }

    // fallback: 假裝成功，避免 Qt 崩潰
    return 0;
}
