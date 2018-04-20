#ifndef BAREMETAL_NEWLIB_CONTAINER_H
#define BAREMETAL_NEWLIB_CONTAINER_H

#ifdef __cplusplus
extern "C"
{
#endif

struct container_host;

/** Passed by the caller of the program
 * to implement the various functions required
 * for basic operation.
 * */

struct container
{
	/** A pointer to the application host data. */
	struct container_host *container_host;
	/** The number of arguments passed to the program. */
	int argc;
	/** The argument array. */
	char **argv;
	/** The environment variables. */
	char **env;
	/** Writes to file. */
	int (*write)(int fd, const void *buf, unsigned int size, struct container_host *container_host);
	/** Reads from a file. */
	int (*read)(int fd, void *buf, unsigned int size, struct container_host *container_host);
	/** Opens a file. */
	int (*open)(const char *path, int mode, struct container_host *container_host);
	/** Closes a file. */
	int (*close)(int fd, struct container_host *container_host);
	/** Allocates memory. */
	void *(*malloc)(unsigned long int size, struct container_host *container_host);
	/** Resizes allocated memory. */
	void *(*realloc)(void *addr, unsigned long int size, struct container_host *container_host);
	/** Releases memory. */
	void (*free)(void *addr, struct container_host *container_host);
};

/** Sets the global container pointer.
 * @param container A non-null container structure.
 * If this parameter is null then the global container
 * pointer will not be assigned.
 * */

void set_container(struct container *container);

/** Gets a pointer to the global container pointer.
 * If the container has not been set yet, then NULL
 * is returned instead.
 * @returns A pointer to the global container pointer.
 * */

struct container *get_container(void);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* BAREMETAL_NEWLIB_CONTAINER_H */
