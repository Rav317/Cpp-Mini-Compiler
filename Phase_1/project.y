%{
#include<stdio.h>
#include <stdlib.h>
#include "symboltable.h"

int yylex();
void yyerror(char *s);




  sym_t** symbol_table;
  sym_t** constant_table;

	int current_dtype;

%}


%union
{
	double dval;
	sym_t* entry;
}

%token T_INT T_IF T_ELSE T_CHAR T_ID T_FLOAT T_RELOP T_LOGOP T_NUM T_WHILE T_FOR T_EQUALS T_PLUSASSIGN T_PLUS T_MINUS T_MINUSASSIGN T_DIVASSIGN T_DIVIDE T_MULASSIGN T_MUL T_LCBKT T_RCBKT T_RLBKT T_RRBKT T_SEMICOLON T_COMMA



 
%%

Prog	: Stmts {printf("Valid\n"); YYACCEPT;}
		;

Stmts	: T_IF  T_RLBKT Expr T_RRBKT T_LCBKT Stmts Stmts
		| T_IF  T_RLBKT Expr T_RRBKT T_LCBKT Stmts  T_ELSE T_LCBKT Stmts  Stmts
		| T_FOR T_RLBKT Decl RelExpr T_SEMICOLON SynSugar T_RRBKT T_LCBKT Stmts  Stmts
		| T_WHILE T_RLBKT Expr T_RRBKT T_LCBKT Stmts  Stmts
		| AsignExpr Stmts
		| Decl Stmts
		| Expr Stmts
		| T_RCBKT
		| error '\n'  {yyerror("Reenter");yyerrok;}
		;



Decl	: Type ListVar T_SEMICOLON
		| ListVar T_SEMICOLON
		;

Type	: T_INT 
		| T_FLOAT
		| T_CHAR
		;

ListVar : T_ID
		| ListVar T_COMMA T_ID
		| ListVar T_COMMA AsignExpr
		| AsignExpr
		;

Expr	: E
		| RelExpr
		| SynSugar T_SEMICOLON
		;

AsignExpr : T_ID T_EQUALS E 
	  	  ;

RelExpr	: E T_RELOP E
	    ;  

SynSugar : T_ID T_PLUSASSIGN E
	 	 | T_ID T_MINUSASSIGN E
	 	 | T_ID T_MULASSIGN E
	 	 | T_ID T_DIVASSIGN E
	 	 ;


E	: T 
	| E T_PLUS T
	| E T_MINUS T
	;

T	: F
	| T T_MUL F
	| T T_DIVIDE F
	;

F	: T_ID
	| T_NUM
	| T_RLBKT E T_RRBKT
	;

%%

#include "lex.yy.c"
#include <ctype.h>



int main(int argc,char *argv[]){

	symbol_table = create_table();
	constant_table = create_table();
	
	if(argc == 2){
	yyin = fopen(argv[1], "r");

	if(!yyparse())
	{
		printf("\nParsing complete\n");
	}
	else
	{
			printf("\nParsing failed\n");
	}


	printf("\n\tSymbol table\n\t-----------");
	display(symbol_table);


	fclose(yyin);
	}
	else{

	if(!yyparse())
	{
		printf("\nParsing complete\n");
	}
	else
	{
			printf("\nParsing failed\n");
	}


	printf("\n\tSymbol table\n\t-----------");
	display(symbol_table);


	

	}
	return 0;

}



void yyerror(char *s){

printf("Error :  Line no: --> %d message: %s Token: %s\n",yylineno,s,yytext);

}