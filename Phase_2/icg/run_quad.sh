lex icg_quad.l
yacc -d icg_quad.y -v
gcc -w -g y.tab.c -ll
./a.out