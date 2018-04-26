#include <stdio.h> // fflush()
#include <stdlib.h> // EXIT_FAILURE

#include "container.h"

extern int main(int argc, char *argv[]);

extern char __bss_start;
extern char __bss_stop;

static void zero_bss(void);

int _start(struct container *container)
{
	if (container == NULL)
		return EXIT_FAILURE;

	zero_bss();

	set_container(container);

	int retval = main(container->argc, container->argv);
	
	fflush(stdout);

	return retval;
}

static void zero_bss(void)
{
	for(char *c = &__bss_start; c < &__bss_stop; c++)
		*c = 0;
}
