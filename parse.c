#include "parse.h"

#include <stdlib.h>

#include "lex.h"
#include "grammar.c"

static void *parser = NULL;

static void parse(int tok, SToken *tok_data)
{
    Parse(parser, tok, tok_data);
}

int steady_parse_file(const char *filename)
{
    FILE *file = fopen(filename, "r");
    if(!file)
    {
        fprintf(stderr, "could not open file for reading\n");
        return 0;
    }

    fseek(file, 0, SEEK_END);
    size_t length = ftell(file);
    rewind(file);

    char *source = malloc(length);
    fread(source, 1, length, file);

    parser = ParseAlloc(malloc);

    steady_lex(source, length, parse);

    ParseFree(parser, free);

    free(source);

    fclose(file);

    return 1;
}
