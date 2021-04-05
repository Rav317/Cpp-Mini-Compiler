#! /bin/bash
lex project.l
yacc -d project.y -v
gcc -w -g y.tab.c -ll 
./a.out incorrect.txt

