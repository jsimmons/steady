STEADY
======

A programming language for me.

BUILDING
========

You probably shouldn't, but if you really want to.

    lemon grammar.y
    ragel -C -G2 parser.rl
    gcc -Wall -Wextra -pedantic -std=c99 -g parser.c main.c -o steady
