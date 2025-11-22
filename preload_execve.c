// compile: gcc -shared -fPIC -o preload_execve.so preload_execve.c -ldl
#define _GNU_SOURCE
#include <dlfcn.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int (*real_execve)(const char *, char *const[], char *const[]) = NULL;

// 判斷字串是否以 .sh 結尾
static int ends_with_sh(const char *path) {
    size_t len = strlen(path);
    if (len < 3) return 0;
    return strcmp(path + len - 3, ".sh") == 0;
}

static int is_from_system(const char *path) {
    size_t len = strlen(path);
    if (!path) return 0;
    if (len < 8) return 0;
    return ( strcmp(path + len - 8, "linker64") == 0 ||
             strncmp(path,"/system/bin/",12) == 0 );
}


int execve(const char *filename, char *const argv[], char *const envp[]) {
    if (!real_execve)
        real_execve = dlsym(RTLD_NEXT, "execve");

    if(is_from_system(filename))
      return real_execve(filename,argv,envp);

    // 確保 filename 是絕對路徑
    char resolved[4096];
    const char *abs_path = filename;

        if (!realpath(filename, resolved)) {
            // fallback: 使用原始 path
            abs_path = filename;
        } else {
            abs_path = resolved;
        }

    // 重新組裝新的 argv：linker64 + original filename + original args
    int count = 0;
    while (argv[count]) count++;

    // +2: linker64 and abs_path, +1 null terminator
    char **new_argv = malloc(sizeof(char*) * (count + 2));
    if (!new_argv)
        return -1;

    // 決定要用的 loader
    const char *loader;
    if (ends_with_sh(abs_path)) {
        loader = "/system/bin/sh";
        new_argv[1] = (char *)filename;
    } else {
        loader = "/system/bin/linker64";
        new_argv[1] = (char *)abs_path;
    }

    new_argv[0] = (char *)loader;

    for (int i = 1; i < count; i++)
        new_argv[i + 1] = argv[i];

    new_argv[count + 1] = NULL;

    fprintf(stderr, "[execve intercepted]\n");
    fprintf(stderr, "  original: %s\n", filename);
    fprintf(stderr, "  using: %s %s ...\n", loader, new_argv[1]);

    return real_execve(loader, new_argv, envp);
}
