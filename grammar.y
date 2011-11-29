%token_prefix TOK_
%token_type {SToken*}

%syntax_error {
    fprintf(stderr, "===============\n ERROR @ %d:%d\n===============\n",
            TOKEN->line, TOKEN->column);
}

%left OR.
%left AND.
%left LT LE EQ NE GE GT.
%left ADD SUB BOR BXOR.
%left MUL DIV MOD LSHIFT RSHIFT BAND.
%right NOT.
%nonassoc LPAREN LBRACKET ASSIGN BASSIGN COLON.

module ::= chunk.

chunk ::= .
chunk ::= chunk stat.
chunk ::= chunk call SEMICOLON.
chunk ::= chunk expr SEMICOLON.

block ::= LBRACE chunk endstat RBRACE.

ident ::= NAME.

type ::= NAME.
type ::= type index.
type ::= type FSIG LPAREN bindlist RPAREN.

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

bind ::= ident COLON type.

call ::= expr LPAREN exprlist RPAREN.

stat ::= IF LPAREN expr RPAREN block.
stat ::= IF LPAREN expr RPAREN block ELSE block.
stat ::= FOR LPAREN exprlist SEMICOLON expr SEMICOLON exprlist RPAREN block.
stat ::= WHILE LPAREN expr RPAREN block.
stat ::= DO block WHILE LPAREN expr RPAREN.

// TODO: Fix explicit semi-coloning.
stat ::= bind SEMICOLON.
stat ::= bind ASSIGN expr SEMICOLON.
stat ::= bind ASSIGN call SEMICOLON.
stat ::= ident ASSIGN expr SEMICOLON.
stat ::= ident ASSIGN call SEMICOLON.
stat ::= ident BASSIGN expr SEMICOLON.
stat ::= ident BASSIGN call SEMICOLON.

endstat ::= .
endstat ::= RETURN expr SEMICOLON.
endstat ::= BREAK SEMICOLON.
endstat ::= CONTINUE SEMICOLON.

index ::= LBRACKET RBRACKET.
index ::= LBRACKET expr RBRACKET.

exprlist ::= .
exprlist ::= expr.
exprlist ::= exprlist COMMA expr.

expr ::= expr index.

expr ::= literal.
expr ::= ident.

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

