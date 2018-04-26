#include "container.h"

struct container *global_container = (void *) 0;

void set_container(struct container *container)
{
	if (container != ((void *) 0))
		global_container = container;
}

struct container *get_container(void)
{
	return global_container;
}
