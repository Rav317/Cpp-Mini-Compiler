%{
#include<stdio.h>
#include <stdlib.h>
// #include "symboltable.h"

//int yylex();
void yyerror(char *s);




  sym_t** symbol_table;
  sym_t** constant_table;

	int current_dtype;

typedef struct quadruples
{
	char *op;
	char *arg1;
	char *arg2;
	char *res;
}quad;

quad q[1005];

int quadlen=0;



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
	| E T_RELOP {push();} T {codegen();}	 
	;

T	: TERM
	| E T_PLUS {push();} TERM {codegen();}
	| E T_MINUS {push();} TERM {codegen();}
	;

TERM : FACTOR
	 | TERM T_MUL {push();} FACTOR {codegen();}
	 | TERM T_DIVIDE {push();} FACTOR {codegen();}
	 ;


FACTOR : LIT
	   | T_RLBKT E T_RRBKT
	   ;

PRINT : T_COUT T_

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
char st[100][100];

int temp_i =0;
char tmp_i[3];
char temp[2]="t";
int lnum=0;
int l_while=0;

void push()
{
	strcpy(st[++top],yytext);
	return;
}

void pusha()
{
	strcpy(st[++top],"  ");
	return;
}


// 
void codegen()
{
    strcpy(temp,"T");
    sprintf(tmp_i, "%d", temp_i);
    strcat(temp,tmp_i);
	
    printf("%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
	
    q[quadlen].op = (char*)malloc(sizeof(char)*strlen(st[top-1]));
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top-2]));
    q[quadlen].arg2 = (char*)malloc(sizeof(char)*strlen(st[top]));
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,st[top-1]);
    strcpy(q[quadlen].arg1,st[top-2]);
    strcpy(q[quadlen].arg2,st[top]);
    strcpy(q[quadlen].res,temp);
    quadlen++;
    top-=2;
    strcpy(st[top],temp);
	temp_i++;
	return ;
}

void codegen_assigna()
{
	strcpy(temp,"T");
	sprintf(tmp_i, "%d", temp_i);
	strcat(temp,tmp_i);
	//printf("%s = %s %s %s %s\n",temp,st[top-3],st[top-2],st[top-1],st[top]);
	////printf("%d\n",strlen(st[top]));
	if(strlen(st[top])==1)
{
	////printf("hello");
	
    char t[20];
	////printf("hello");
	strcpy(t,st[top-2]);
	strcat(t,st[top-1]);
	q[quadlen].op = (char*)malloc(sizeof(char)*strlen(t));
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top-3]));
    q[quadlen].arg2 = (char*)malloc(sizeof(char)*strlen(st[top]));
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,t);
    strcpy(q[quadlen].arg1,st[top-3]);
    strcpy(q[quadlen].arg2,st[top]);
    strcpy(q[quadlen].res,temp);
    quadlen++;
    
}
else
{
	q[quadlen].op = (char*)malloc(sizeof(char)*strlen(st[top-2]));
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top-3]));
    q[quadlen].arg2 = (char*)malloc(sizeof(char)*strlen(st[top-1]));
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,st[top-2]);
    strcpy(q[quadlen].arg1,st[top-3]);
    strcpy(q[quadlen].arg2,st[top-1]);
    strcpy(q[quadlen].res,temp);
    quadlen++;
}
	top-=4;

	temp_i++;
	strcpy(st[++top],temp);
	return ;

}


void codegen_assign()
{
    //printf("%s = %s\n",st[top-3],st[top]);
    q[quadlen].op = (char*)malloc(sizeof(char));
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top]));
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(st[top-3]));
    strcpy(q[quadlen].op,"=");
    strcpy(q[quadlen].arg1,st[top]);
    strcpy(q[quadlen].res,st[top-3]);
    quadlen++;
    top-=2;
	return ;
}


int main(int argc,char *argv[]){

	// symbol_table = create_table();
	// constant_table = create_table();
	
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


	// printf("\n\tSymbol table\n\t-----------");
	// display(symbol_table);


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


	//printf("\n\tSymbol table\n\t-----------");
	//display(symbol_table);


	

	}
	return 0;

}



void yyerror(char *s){

printf("Error :  Line no: --> %d message: %s Token: %s\n",yylineno,s,yytext);

}