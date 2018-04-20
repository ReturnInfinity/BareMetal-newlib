#include <stdio.h> // fflush()
#include <stdlib.h> // EXIT_FAILURE

#include "container.h"

extern int main(int argc, char *argv[]);

extern char __bss_start, _end; // BSS should be the last thing before _end

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
	for(char *c = &__bss_start; c < &_end; c++)
		*c = 0;
}
