#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "parser.h"

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

// Muhahaha
#include "grammar.h"
#include "grammar.c"

#define COL() (ts - last_newline)

#define BASIC_INFO() do { \
        token.line = line; \
        token.column = COL(); \
    } while (0)

#define SIMPLE_TOKEN(Name) do { \
        BASIC_INFO(); \
        Parse(parser, (Name), &token); \
    } while(0)

%%{
    machine steady_lexer;

    newline = '\r\n' | '\r' | '\n';
    any_safe = any -- newline;

    name_safe = alpha | '_';
    name = name_safe (name_safe | digit)*;

    int_literal = digit+;
    hex_literal = '0x' xdigit+;
    float_literal = digit+ '.' digit*;
    octet_literal = '\'' any_safe '\'';
    string_literal = '"' any_safe* '"';

    comment = '//' any_safe*;

    main := |*
        ':'  => { SIMPLE_TOKEN(TOK_COLON); };
        '='  => { SIMPLE_TOKEN(TOK_ASSIGN); };
        ':=' => { SIMPLE_TOKEN(TOK_BASSIGN); };
        '~'  => { SIMPLE_TOKEN(TOK_NOT); };
        '+'  => { SIMPLE_TOKEN(TOK_ADD); };
        '-'  => { SIMPLE_TOKEN(TOK_SUB); };
        '*'  => { SIMPLE_TOKEN(TOK_MUL); };
        '/'  => { SIMPLE_TOKEN(TOK_DIV); };
        '%'  => { SIMPLE_TOKEN(TOK_MOD); };
        '&'  => { SIMPLE_TOKEN(TOK_BAND); };
        '|'  => { SIMPLE_TOKEN(TOK_BOR); };
        '^'  => { SIMPLE_TOKEN(TOK_BXOR); };
        '<<' => { SIMPLE_TOKEN(TOK_LSHIFT); };
        '>>' => { SIMPLE_TOKEN(TOK_RSHIFT); };
        '&&' => { SIMPLE_TOKEN(TOK_AND); };
        '||' => { SIMPLE_TOKEN(TOK_OR); };
        '<'  => { SIMPLE_TOKEN(TOK_LT); };
        '<=' => { SIMPLE_TOKEN(TOK_LE); };
        '==' => { SIMPLE_TOKEN(TOK_EQ); };
        '~=' => { SIMPLE_TOKEN(TOK_NE); };
        '>=' => { SIMPLE_TOKEN(TOK_GE); };
        '>'  => { SIMPLE_TOKEN(TOK_GT); };
        '('  => { SIMPLE_TOKEN(TOK_LPAREN); };
        ')'  => { SIMPLE_TOKEN(TOK_RPAREN); };
        '{'  => { SIMPLE_TOKEN(TOK_LBRACE); };
        '}'  => { SIMPLE_TOKEN(TOK_RBRACE); };
        'null'  => { SIMPLE_TOKEN(TOK_NULL); };
        'false'  => { SIMPLE_TOKEN(TOK_FALSE); };
        'true'  => { SIMPLE_TOKEN(TOK_TRUE); };

        name => {
            BASIC_INFO();
            token.data.str.len = te - ts;
            token.data.str.ptr = ts;
            Parse(parser, TOK_NAME, &token);
        };

        int_literal => {
            BASIC_INFO();
            Parse(parser, TOK_INTEGER, &token);
        };

        hex_literal => {
            BASIC_INFO();
            Parse(parser, TOK_INTEGER, &token);
        };

        float_literal => {
            BASIC_INFO();
            Parse(parser, TOK_FLOAT, &token);
        };

        octet_literal => {
            BASIC_INFO();
            Parse(parser, TOK_OCTET, &token);
        };

        string_literal => {
            BASIC_INFO();
            token.data.str.len = (te - 1) - ts + 1;
            token.data.str.ptr = ts + 1;
            Parse(parser, TOK_STRING, &token);
        };

        space -- newline;
        comment;

        newline => {
            line++;
            last_newline = fpc;
        };
    *|;
}%%

%% write data;

void steady_parse(const char *source, size_t length)
{
    int cs, act, line = 1;
    const char *p = source, *pe = source + length, *eof = pe, *ts = 0, *te;

    // Imaginary new line right before the first line in the source file.
    const char *last_newline = p - 1;

    SToken token;
    void *parser = ParseAlloc(malloc);
    ParseTrace(stdout, "TRACE ");

    %% write init;
    %% write exec;

    Parse(parser, 0, &token);

    ParseFree(parser, free);
}
