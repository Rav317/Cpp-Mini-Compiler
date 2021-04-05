%{
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include "y.tab.h"

//void yyerror(char *s);
int cmnt_strt = 0;

int d_type;

%}

digit [0-9]
letter [a-zA-Z]
ws  [ \t\r\f\v]+
id {letter}({digit}|{letter})*
digits {digit}+
opFraction (\.{digits})?
opExponent ([Ee][+-]?{digit})?
number {digits}{opFraction}{opExponent}
equals (=)
relop	(<=?|>=?|==|!=)
%x CMNT

%%

int {d_type= 4 ; printf("T_INT\n"); return T_INT;}
float {d_type=8 ; printf("T_FLOAT\n"); return T_FLOAT;}
char {d_type = 1; printf("T_CHAR\n"); return T_CHAR;}
{equals}  { printf("T_EQUALS : %d\n", yylineno);  return T_EQUALS; }
{relop}   { printf("T_RELOP : %d\n", yylineno);  return T_RELOP; }
if        { printf("T_IF : %d\n", yylineno);  return T_IF; }
else      { printf("T_ELSE : %d\n", yylineno);  return T_ELSE; }
while     { printf("T_WHILE : %d\n", yylineno);  return T_WHILE; }
for       { printf("T_FOR : %d\n", yylineno);  return T_FOR; }
"+="      { printf("T_PLUSASSIGN : %d\n", yylineno);  return T_PLUSASSIGN; }
"+"       { printf("T_PLUS : %d\n", yylineno);  return T_PLUS; }
"-"       { printf("T_MINUS : %d\n", yylineno);  return T_MINUS; }
"-="      { printf("T_MINUSASSIGN : %d\n", yylineno);  return T_MINUSASSIGN; }
"/="      { printf("T_DIVASSIGN : %d\n", yylineno);  return T_DIVASSIGN; }
"/"       { printf("T_DIVIDE : %d\n", yylineno);  return T_DIVIDE; }
"*="      { printf("T_MULASSIGN : %d\n", yylineno);  return T_MULASSIGN; }
"*"       { printf("T_MUL : %d\n", yylineno);  return T_MUL; }
"{"       { printf("T_LCBKT : %d\n", yylineno);  return T_LCBKT; }
"}"       { printf("T_RCBKT : %d\n", yylineno);  return T_RCBKT; }
"("       { printf("T_RLBKT : %d\n", yylineno);  return T_RLBKT; }
")"       { printf("T_RRBKT : %d\n", yylineno);  return T_RRBKT; }
";"       { printf("T_SEMICOLON : %d\n", yylineno);  return T_SEMICOLON; }
","       { printf("T_COMMA : %d\n", yylineno);  return T_COMMA; }


{id}  {yylval.entry = insert(symbol_table, yytext,d_type,INT_MAX, yylineno); return  T_ID;}
{number}  {return  T_NUM;}

"/*"                              {cmnt_strt = yylineno; BEGIN CMNT;}
<CMNT>.|{ws}                    ;
<CMNT>\n                          {yylineno++;}
<CMNT>"*/"                        {BEGIN INITIAL;}
<CMNT>"/*"                        {printf("Line %3d: Nested comments are not valid!\n",yylineno);}
<CMNT><<EOF>>                     {printf("Line %3d: Unterminated comment\n", cmnt_strt); yyterminate();}
"//".* ;
[\n]  {yylineno++;}
['\t' | ' ' ] ;
. return *yytext;


%%

