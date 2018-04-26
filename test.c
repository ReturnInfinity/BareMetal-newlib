#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[])
{
	struct tm *local;
	time_t t;
	int i=0;

	printf("NewLib Test Application\n=======================\n");

	// Test argument parsing
	printf("argc: %d\n", argc);
	for (i=0; i < argc; i++)
		printf("argv[%d]: %s\n", i, argv[i]);
	printf("\n");

	// Test time
	t = time(NULL);
	local = localtime(&t);
	printf("Local time and date: %s\n", asctime(local));

	printf("%s %d\n", "printf-example:", 1234);

	return 0;
}
