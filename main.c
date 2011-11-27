#include <stdio.h>
#include <stdlib.h>

#include "parser.h"


int main(int argc, const char **argv)
{
    FILE *file = fopen("source.st", "r");
    if(!file)
    {
        fprintf(stderr, "could not open file for reading\n");
        return 1;
    }

    fseek(file, 0, SEEK_END);
    size_t length = ftell(file);
    rewind(file);

    char *source = malloc(length);
    fread(source, 1, length, file);

    steady_parse(source, length);

    free(source);

    fclose(file);

    return 0;
}
