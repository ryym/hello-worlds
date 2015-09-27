#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <string.h>

static int is_dot_dir(char *d_name);
static int is_normal_dir(char *path);
static char* to_relative_path(char *path, char *d_name);
static void do_ls(char *path);

int
main(int argc, char *argv[])
{
    int i;

    if (argc < 2) {
        fprintf(stderr, "%s: no arguments\n", argv[0]);
        exit(1);
    }
    for (i = 1; i < argc; i++) {
        do_ls(argv[i]);
    }
    exit(0);
}

static int
is_dot_dir(char *d_name)
{
    return strcmp(d_name, ".") == 0 || strcmp(d_name, "..") == 0;
}

static int
is_normal_dir(char *path)
{
    struct stat st;
    mode_t mode;

    if (lstat(path, &st) < 0) {
        perror(path);
        exit(1);
    }
    mode = st.st_mode;
    return S_ISDIR(mode) && ! S_ISLNK(mode);
}

static char*
to_relative_path(char *path, char *d_name)
{
    size_t path_len;
    size_t name_len;
    char *result;

    path_len = strlen(path);
    name_len = strlen(d_name);

    if (is_dot_dir(path)) {
        result = malloc(name_len + 1);
        if (! result) {
            perror(path);
            exit(1);
        }
        memcpy(result, d_name, name_len + 1);
        return result;
    }

    result = malloc(path_len + 1 + name_len + 1); // '/', zero-terminator
    if (! result) {
        perror(path);
        exit(1);
    }
    memcpy(result, path, path_len);
    memcpy(result + path_len, "/", 1);
    memcpy(result + path_len + 1, d_name, name_len + 1);
    return result;
}

static void
do_ls(char *path)
{
    DIR *d;
    struct dirent *ent;
    char *relpath;

    d = opendir(path);
    if (!d) {
        perror(path);
        exit(1);
    }
    printf("%s\n", path);
    while ((ent = readdir(d))) {
        if ( is_dot_dir(ent->d_name) ) {
            continue;
        }
        relpath = to_relative_path(path, ent->d_name);

        if ( is_normal_dir(relpath) ) {
            do_ls(relpath);
        } else {
            printf("%s\n", relpath);
        }
        free(relpath);
    }
    closedir(d);
}
