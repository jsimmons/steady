%token_prefix TOK_
%token_type {SToken*}

%syntax_error {
    fprintf(stderr, "Houston We Have a Problem over at %d:%d\n", TOKEN->line,
            TOKEN->column);
}

%left OR.
%left AND.
%left LT LE EQ NE GE GT.
%left ADD SUB BOR BXOR.
%left MUL DIV MOD LSHIFT RSHIFT BAND.
%right NOT.
%nonassoc PAREN ASSIGN BASSIGN COLON.

module ::= chunk.

chunk ::= .
chunk ::= chunk expr.
block ::= LBRACE chunk RBRACE.

ident ::= NAME.
tname ::= NAME.

literal ::= INTEGER.
literal ::= FLOAT.
literal ::= OCTET.
literal ::= STRING.
literal ::= NULL.
literal ::= FALSE.
literal ::= TRUE.
literal ::= block.

expr ::= ident COLON tname.
expr ::= ident COLON tname ASSIGN expr.
expr ::= ident ASSIGN expr.
expr ::= ident BASSIGN expr.

expr ::= ident.
expr ::= literal.

expr ::= LPAREN expr RPAREN. [PAREN]

expr ::= expr LT expr.
expr ::= expr LE expr.
expr ::= expr EQ expr.
expr ::= expr NE expr.
expr ::= expr GE expr.
expr ::= expr GT expr.

expr ::= expr OR expr.
expr ::= expr AND expr.
expr ::= expr ADD expr.
expr ::= expr SUB expr.
expr ::= expr BOR expr.
expr ::= expr BXOR expr.
expr ::= expr MUL expr.
expr ::= expr DIV expr.
expr ::= expr MOD expr.
expr ::= expr LSHIFT expr.
expr ::= expr RSHIFT expr.
expr ::= expr BAND expr.
expr ::= NOT expr.

