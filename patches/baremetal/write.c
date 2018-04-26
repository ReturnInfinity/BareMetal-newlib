#include "container.h"

#include <stdlib.h>

int write(int fd, const void *buf, size_t len)
{
	struct container *container = get_container();
	if (container == NULL)
		return -1;
	else if (container->write == NULL)
		return -1;
	else
		return container->write(fd, buf, len, container->container_host);
}
