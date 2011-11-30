#ifndef STEADY_LEXER_H
#define STEADY_LEXER_H

#include <stddef.h>
#include <stdint.h>

typedef struct
{
    size_t len;
    const char *ptr;
} STokenStringData;

typedef union
{
    STokenStringData str;
    uint64_t integer;
    double number;
} STokenData;

typedef struct
{
    STokenData data;
    int line;
    int column;
} SToken;

typedef void (*SParseFunc)(int, SToken *);

void steady_lex(const char *source, size_t length, SParseFunc parse);

#endif
