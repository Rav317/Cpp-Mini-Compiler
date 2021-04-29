%{
    #include<string.h>
    #include<stdio.h>
    int line = 0;
    #define YYSTYPE char *
%}

alpha [A-Za-z_]
digit [0-9]
%option yylineno
%%
[ \t\n] {yylval = strdup(yytext);}
":" {yylval = strdup(yytext);return T_colon;}
"?" {yylval = strdup(yytext);return T_ques;}
"while" {yylval = strdup(yytext);return WHILE;}
"for" {yylval = strdup(yytext);return T_FOR;}
"if" {yylval = strdup(yytext);return IF;}
"else" {yylval = strdup(yytext);return ELSE;}
"cout" {yylval = strdup(yytext);return COUT;}
"endl" {yylval = strdup(yytext);return ENDL;}
"break" {yylval = strdup(yytext);return BREAK;}
"continue" {yylval = strdup(yytext);return CONTINUE;}
"int" {yylval = strdup(yytext);return T_INT;}
"float" {yylval = strdup(yytext);return T_FLOAT;}
"char" {yylval = strdup(yytext);return T_CHAR;}
"void" {yylval = strdup(yytext);return T_VOID;}
"#include" {yylval = strdup(yytext);return T_INCLUDE;}
"main()" {yylval = strdup(yytext);return T_MAINTOK;}
{digit}+    {yylval = strdup(yytext);return T_NUM;}
{digit}+.{digit}+ {yylval = strdup(yytext);return T_FLOAT;}
{alpha}({alpha}|{digit})* {yylval = strdup(yytext);return T_ID;}
{alpha}({alpha}|{digit})*"\.h"?  {yylval = strdup(yytext);return T_HEADER;}
\".*\" {yylval = strdup(yytext);return STRING;}
"<" {yylval = strdup(yytext);return T_LT;}
">"     {yylval = strdup(yytext);return T_GT;}
"="     {yylval = strdup(yytext);return T_EQ;}
"<="    {yylval = strdup(yytext);return T_lteq;}
">="    {yylval = strdup(yytext);return T_gteq;}
"=="    {yylval = strdup(yytext);return T_eqeq;}
"!="    {yylval = strdup(yytext);return T_neq;}
"+"     {yylval = strdup(yytext);return T_PL;}
"-"     {yylval = strdup(yytext);return T_MIN;}
"*"     {yylval = strdup(yytext);return T_MUL;}
"/"     {yylval = strdup(yytext);return T_DIV;}
"++"    {yylval = strdup(yytext);return T_incr;}
"--"    {yylval = strdup(yytext);return T_decr;}
"!"     {yylval = strdup(yytext);return T_neq;}
"||"    {yylval = strdup(yytext);return T_or;}
"&&"    {yylval = strdup(yytext);return T_and;}

"{"    {yylval = strdup(yytext);return T_LCBKT;}
"}"    {yylval = strdup(yytext);return T_RCBKT;}
"("    {yylval = strdup(yytext);return T_LRBKT;}
")"    {yylval = strdup(yytext);return T_RRBKT;}
";"    {yylval = strdup(yytext);return T_SEMICOLON;}

.    return yytext[0];

%%
