#include "grammar.h"
#include "lex.h"

#define COL() (ts - last_newline)

#define BASIC_INFO() do { \
        token.line = line; \
        token.column = COL(); \
    } while (0)

#define SIMPLE_TOKEN(Name) do { \
        BASIC_INFO(); \
        parse((Name), &token); \
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
        ','  => { SIMPLE_TOKEN(TOK_COMMA); };
        ':'  => { SIMPLE_TOKEN(TOK_COLON); };
        ';'  => { SIMPLE_TOKEN(TOK_SEMICOLON); };
        '='  => { SIMPLE_TOKEN(TOK_ASSIGN); };
        ':=' => { SIMPLE_TOKEN(TOK_BASSIGN); };
        '<-' => { SIMPLE_TOKEN(TOK_FSIG); };

        'if' => { SIMPLE_TOKEN(TOK_IF); };
        'else' => { SIMPLE_TOKEN(TOK_ELSE); };
        'for' => { SIMPLE_TOKEN(TOK_FOR); };
        'while' => { SIMPLE_TOKEN(TOK_WHILE); };
        'do' => { SIMPLE_TOKEN(TOK_DO); };

        'return' => { SIMPLE_TOKEN(TOK_RETURN); };
        'break' => { SIMPLE_TOKEN(TOK_BREAK); };
        'continue' => { SIMPLE_TOKEN(TOK_CONTINUE); };

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
        '['  => { SIMPLE_TOKEN(TOK_LBRACKET); };
        ']'  => { SIMPLE_TOKEN(TOK_RBRACKET); };
        '{'  => { SIMPLE_TOKEN(TOK_LBRACE); };
        '}'  => { SIMPLE_TOKEN(TOK_RBRACE); };

        'null'  => { SIMPLE_TOKEN(TOK_NULL); };
        'false'  => { SIMPLE_TOKEN(TOK_FALSE); };
        'true'  => { SIMPLE_TOKEN(TOK_TRUE); };

        name => {
            BASIC_INFO();
            token.data.str.len = te - ts;
            token.data.str.ptr = ts;
            parse(TOK_NAME, &token);
        };

        int_literal => {
            BASIC_INFO();
            parse(TOK_INTEGER, &token);
        };

        hex_literal => {
            BASIC_INFO();
            parse(TOK_INTEGER, &token);
        };

        float_literal => {
            BASIC_INFO();
            parse(TOK_FLOAT, &token);
        };

        octet_literal => {
            BASIC_INFO();
            parse(TOK_OCTET, &token);
        };

        string_literal => {
            BASIC_INFO();
            token.data.str.len = (te - 1) - ts + 1;
            token.data.str.ptr = ts + 1;
            parse(TOK_STRING, &token);
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

void steady_lex(const char *source, size_t length, SParseFunc parse)
{
    int cs, act, line = 1;
    const char *p = source, *pe = source + length, *eof = pe, *ts = 0, *te;

    // Imaginary new line right before the first line in the source file.
    const char *last_newline = p - 1;

    SToken token;

    %% write init;
    %% write exec;

    parse(0, &token);
}
