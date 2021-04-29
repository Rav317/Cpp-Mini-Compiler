%{
#include <stdlib.h>
#include <stdio.h>]
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
%x CMNT

%%

int          {return T_INT;}
float        {return T_FLOAT;}
char         {return T_CHAR;}
if           {return T_IF; }
else         {return T_ELSE; }
while        {return T_WHILE; }
for          {return T_FOR; }

"<"          {return T_LT;}
">"          {return T_GT;}
"="          {return T_EQ;}
"!"          {return T_NOT;}
"cout"       {return T_COUT;}
"endl"       {return T_ENDL;}
"void"       {return T_VOID;}
"#include"   {return T_INCLUDE;}
"main()"     {return T_MAIN;}


{id}  {/*yylval.entry = insert(symbol_table, yytext,d_type,INT_MAX, yylineno); */ return  T_ID;}
{letter}({letter}|{digit})*"\.h"?  { return T_HEADER;}


"||"        { return T_OR;}
"&&"        { return T_AND;}


"+"       {   return T_PL; }
"-"       {   return T_MIN; }
"/"       {   return T_DIV; }
"*"       {   return T_MUL; }
"{"       {   return T_LCBKT; }
"}"       {   return T_RCBKT; }
"("       {   return T_RLBKT; }
")"       {   return T_RRBKT; }
";"       {   return T_SEMICOLON; }

{number}  {return  T_NUM;}
\".*\"    {  return T_STRING;}

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

