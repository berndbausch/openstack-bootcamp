#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int main(int argc, char *argv[])
{
  struct timeval old, new;
  int counter;
  int npages=1024*1024;
  char *mem;

    old.tv_sec = 0;
    if (argc>1)
        npages=atoi(argv[1]);

    printf( "Allocating %d pages ...", npages );
    fflush(stdout);
    mem = malloc(npages*4*1024);
    if (mem==NULL)
    {
        printf( "failed\n" );
	exit(1);
    }
    else
        printf ("Success!\n" );

	counter = 0;
    while (1)
	{
	    int index = drand48()*npages;
		mem[index] = 123;

		counter++;
		if (counter>10000)
		{
			counter = 0;
		    gettimeofday(&new,NULL);
			if (new.tv_sec!=old.tv_sec)
			{
			    printf( "still alive at %d\n",new.tv_sec );
				old.tv_sec = new.tv_sec;
			}
		}
	}
}

    
