#include <stdio.h>
#include <stdlib.h>

// Copy a string using pointer.
void
mystrcpy_p(char *a, char *b)
{
    while (*b != '\0') {
        *a = *b;
        a++;
        b++;
    }
    *a = '\0';
}

// Copy a string using array.
void
mystrcpy_a(char a[], char b[])
{
    int i;
    for (i = 0; b[i] != '\0'; i++) {
        a[i] = b[i];
    }
    a[i] = '\0';
}

int
main(int argc, char *argv[])
{
    // The array without initial capacity needs an explicit size or initial value.
    char b[] = "source string";

    char *a = (char *)malloc(sizeof(b));
    mystrcpy_p(a, b);
    printf("a = %s\n", a);

    a = (char *)malloc(sizeof(b));
    mystrcpy_a(a, b);
    printf("a = %s\n", a);
}
