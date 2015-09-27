#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

typedef void (*sighandler_t)(int);

sighandler_t trap_signal(int sig, sighandler_t handler);
void exit_with_message(int sig);

int
main(int argc, char *argv[])
{
    trap_signal(SIGINT, exit_with_message);
    pause();
    exit(0);
}

void
exit_with_message(int sig)
{
    printf("The program has interrupted!\n");
    exit(0);
}

sighandler_t
trap_signal(int sig, sighandler_t handler)
{
    struct sigaction act, old;

    act.sa_handler = handler;
    sigemptyset(&act.sa_mask);
    act.sa_flags = SA_RESTART;

    if (sigaction(sig, &act, &old) < 0) {
        return NULL;
    }
    return old.sa_handler;
}
