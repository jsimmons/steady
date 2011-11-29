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
%nonassoc LPAREN ASSIGN BASSIGN COLON.

module ::= chunk.

chunk ::= .
chunk ::= chunk stat.
chunk ::= chunk expr SEMICOLON.

block ::= LBRACE chunk endstat RBRACE.

ident ::= NAME.

brackets ::= .
brackets ::= brackets LBRACKET RBRACKET.

funcsig ::= tname LPAREN bindlist RPAREN.

tname ::= NAME brackets.
tname ::= funcsig.

literal ::= INTEGER.
literal ::= FLOAT.
literal ::= OCTET.
literal ::= STRING.
literal ::= NULL.
literal ::= FALSE.
literal ::= TRUE.
literal ::= block.

bindlist ::= .
bindlist ::= bind.
bindlist ::= bindlist COMMA bind.

bind ::= ident COLON tname.

stat ::= bind.
stat ::= bind ASSIGN expr.
stat ::= expr LPAREN exprlist RPAREN.
stat ::= IF LPAREN expr RPAREN BLOCK.
stat ::= IF LPAREN expr RPAREN block ELSE block.
stat ::= FOR LPAREN exprlist SEMICOLON expr SEMICOLON exprlist RPAREN block.
stat ::= WHILE LPAREN expr RPAREN block.
stat ::= DO block WHILE LPAREN expr RPAREN.

endstat ::= .
endstat ::= RETURN expr.
endstat ::= BREAK.
endstat ::= CONTINUE.

exprlist ::= .
exprlist ::= expr.
exprlist ::= exprlist COMMA expr.

expr ::= ident.
expr ::= literal.

expr ::= ident ASSIGN expr.
expr ::= ident BASSIGN expr.

expr ::= LPAREN expr RPAREN.

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

