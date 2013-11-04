#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int exit_error(char **argv)
{
   printf("%s <from> <to> [string]\n", argv[0]);
   printf("Example:\n");
   printf("%s 127.0.0. 1 20\n", argv[0]);
   fflush(stdout);
   exit(1);
}

int main(int argc, char **argv)
{
   if ((argc != 4) && (argc != 3))
   {
      exit_error(argv);
   } else if (atoi(argv[1]) > atoi(argv[2]))
   {
      exit_error(argv);
   }

   int num_from = atoi(argv[1]);
   int num_to = atoi(argv[2]);

   int i = num_from;

   if (argc == 4)
   {
      for(;i<=num_to;i++)
      {
         printf("%s%d\n", argv[3], i);
      }
   } else {
      for(;i<=num_to;i++)
      {
         printf("%d\n", i);
      }
   }

   return 0;
}
