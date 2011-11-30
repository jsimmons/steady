CC = clang
CFLAGS = -g -Wall -Wextra -pedantic -std=c99

steady: main.o
	$(CC) main.o parse.o lex.o -o steady

main.o: main.c parse.o lex.o
	$(CC) $(CFLAGS) -c main.c

parse.o: parse.c grammar.c parse.h lex.h
	$(CC) $(CFLAGS) -c parse.c

lex.o: lex.c lex.h
	$(CC) $(CFLAGS) -c lex.c

grammar.c: grammar.y
	lemon -q grammar.y

lex.c: lex.rl
	ragel -C -G2 lex.rl

clean:
	rm *.o steady grammar.h grammar.c lex.c
