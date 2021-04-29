%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <ctype.h>
  int top=-1;
  void yyerror(char *);
  extern FILE *yyin;
  #define YYSTYPE char*
  typedef struct quadruples
  {
    char *op;
    char *arg1;
    char *arg2;
    char *res;
  }quad;


  int quadlen = 0;
  quad q[100];
%}

%start S
%token T_ID T_NUM T_LT T_GT T_lteq T_gteq T_neq T_noteq T_eqeq T_and T_or T_incr T_decr T_not T_EQ WHILE T_INT T_CHAR T_FLOAT T_VOID T_HEADER T_MAIN T_INCLUDE BREAK CONTINUE IF ELSE COUT STRING T_FOR ENDL T_ques T_colon T_LCBKT T_RCBKT T_LRBKT T_RRBKT T_SEMICOLON

%token T_PL T_MIN T_MUL T_DIV
%left T_LT T_GT
%left T_PL T_MIN
%left T_MUL T_DIV

%%
S
      : START {printf("Input accepted.\n");}
      ;

START
      : T_INCLUDE T_LT T_HEADER T_GT MAINFUNC
      ;

MAINFUNC
      : T_VOID T_MAIN BODY
      | T_INT T_MAIN BODY
      ;

BODY
      : T_LCBKT C T_RCBKT
      ;

C
      : C statement T_SEMICOLON
      | C LOOPS
      | statement T_SEMICOLON
      | LOOPS
      ;

LOOPS
      : WHILE {while1();} T_LRBKT COND T_RRBKT{while2();} LOOPBODY{while3();}
      | T_FOR T_LRBKT ASSIGN_EXPR{for1();} T_SEMICOLON COND{for2();} T_SEMICOLON statement{for3();} T_RRBKT LOOPBODY{for4();}
      | IF T_LRBKT COND T_RRBKT {ifelse1();} LOOPBODY{ifelse2();} ELSE LOOPBODY{ifelse3();}
      ;

TERNARY_EXPR
      :  T_LRBKT TERNARY_COND T_RRBKT {ternary1();} T_ques statement{ternary2();} T_colon statement{ternary3();}
      ;

LOOPBODY
  	  : T_LCBKT LOOPC T_RCBKT
  	  | T_SEMICOLON
  	  | statement T_SEMICOLON
  	  ;

LOOPC
      : LOOPC statement T_SEMICOLON
      | LOOPC LOOPS
      | statement T_SEMICOLON
      | LOOPS
      ;

statement
      : ASSIGN_EXPR
      | EXP
      | TERNARY_EXPR
      | PRINT
      ;

TERNARY_COND  : T_B {codegen_assigna();}
              | T_B T_and{codegen_assigna();} TERNARY_COND
              | T_B {codegen_assigna();}T_or TERNARY_COND
              | T_not T_B{codegen_assigna();}
              ;

T_B : T_V T_EQ{push();}T_EQ{push();} LIT
  | T_V T_GT{push();}T_F
  | T_V T_LT{push();}T_F
  | T_V T_not{push();} T_EQ{push();} LIT
  |T_LRBKT T_B T_RRBKT
  | T_V {pushab();}
  ;

T_F :T_EQ{push();}LIT
  |LIT{pusha();}
  ;

COND  : B {codegen_assigna();}
      | B T_and{codegen_assigna();} COND
      | B {codegen_assigna();}T_or COND
      | T_not B{codegen_assigna();}
      ;

B : V T_EQ{push();}T_EQ{push();} LIT
  | V T_GT{push();}F
  | V T_LT{push();}F
  | V T_not{push();} T_EQ{push();} LIT
  |T_LRBKT B T_RRBKT
  | V {pushab();}
  ;

F :T_EQ{push();}LIT
  |LIT{pusha();}
  ;

V : T_ID{push();}

T_V : T_ID{pushx();}

ASSIGN_EXPR
      : LIT {push();} T_EQ {push();} EXP {codegen_assign();}
      | TYPE LIT {push();} T_EQ {push();} EXP {codegen_assign();}
      ;

EXP
	  : ADDSUB 
	  | EXP T_LT {push();} ADDSUB {codegen();}
	  | EXP T_GT {push();} ADDSUB {codegen();}
	  ;

ADDSUB
      : TERM
      | EXP T_PL {push();} TERM {codegen();}
      | EXP T_MIN {push();} TERM {codegen();}
      ;

TERM
	  : FACTOR
      | TERM T_MUL {push();} FACTOR {codegen();}
      | TERM T_DIV {push();} FACTOR {codegen();}
      ;

FACTOR
	  : LIT
	  | T_LRBKT EXP T_RRBKT
  	;

PRINT
      : COUT T_LT T_LT STRING
      | COUT T_LT T_LT STRING T_LT T_LT ENDL
      ;
LIT
      : T_ID {push();}
      | T_NUM {push();}
      ;
TYPE
      : T_INT
      | T_CHAR
      | T_FLOAT
      ;

%%

#include "lex.yy.c"
#include<ctype.h>
char st[100][100];

char i_[2]="0";
int temp_i=0;
char tmp_i[3];
char temp[2]="t";
int label[20];
int lnum=0;
int ltop=0;
int abcd=0;
int l_while=0;
int l_for=0;
int flag_set = 1;

int main(int argc,char *argv[])
{

  yyin = fopen("correct.txt","r");
  if(!yyparse())  //yyparse-> 0 if success
  {
    printf("Parsing Complete\n");
    printf("---------------------Quadruples-------------------------\n\n");
    printf("Operator \t Arg1 \t\t Arg2 \t\t Result \n");
    int i;
    for(i=0;i<quadlen;i++)
    {
        printf("%-8s \t %-8s \t %-8s \t %-6s \n",q[i].op,q[i].arg1,q[i].arg2,q[i].res);
    }
  }
  else
  {
    printf("Parsing failed\n");
  }

  fclose(yyin);
  return 0;
}

void yyerror(char *s)
{
  printf("Error :%s at %d \n",yytext,yylineno);
  return;
}

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

void pushx()
{
  strcpy(st[++top],"x ");

  return;
}
void pushab()
{
  strcpy(st[++top],"  ");
  strcpy(st[++top],"  ");
  strcpy(st[++top],"  ");

  return;
}


void codegen()
{ 
    // stack: i " " = i + 1

    // printing T2 = i + 1
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

    // stack : i " " = T2 

temp_i++;
return ;
}

void codegen_assigna()
{
strcpy(temp,"T");
sprintf(tmp_i, "%d", temp_i);
strcat(temp,tmp_i);
printf("%s = %s %s %s %s\n",temp,st[top-3],st[top-2],st[top-1],st[top]);

if(strlen(st[top])==1)
{
  char t[20];
	strcpy(t,st[top-2]);
	strcat(t,st[top-1]);
  // >" "
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
else // cases like i < 0 "  "
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

// handles assignment expressions like int a = 3;
void codegen_assign()
{
    // stack: i " " = T2
    printf("%s = %s\n",st[top-3],st[top]);
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


void if1()
{
 lnum++;
 strcpy(temp,"T");
 sprintf(tmp_i, "%d", temp_i);
 strcat(temp,tmp_i);
 printf("%s = not %s\n",temp,st[top]);
 q[quadlen].op = (char*)malloc(sizeof(char)*4);
 q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top]));
 q[quadlen].arg2 = NULL;
 q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
 strcpy(q[quadlen].op,"not");
 strcpy(q[quadlen].arg1,st[top]);
 strcpy(q[quadlen].res,temp);
 quadlen++;
 printf("if %s goto L%d\n",temp,lnum);
 q[quadlen].op = (char*)malloc(sizeof(char)*3);
 q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(temp));
 q[quadlen].arg2 = NULL;
 q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
 strcpy(q[quadlen].op,"if");
 strcpy(q[quadlen].arg1,st[top-2]);
 char x[10];
 sprintf(x,"%d",lnum);
 char l[]="L";
 strcpy(q[quadlen].res,strcat(l,x));
 quadlen++;

 temp_i++;
 label[++ltop]=lnum;
 return;
}

void if3()
{
    int y;
    y=label[ltop--];
    printf("L%d: \n",y);
    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(y+2));
    strcpy(q[quadlen].op,"Label");
    char x[10];
    sprintf(x,"%d",y);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;
    return ;
    
}

void ifelse1()
{
    lnum++;
    strcpy(temp,"T");
    sprintf(tmp_i, "%d", temp_i);
    strcat(temp,tmp_i);
    printf("%s = not %s\n",temp,st[top]);
    q[quadlen].op = (char*)malloc(sizeof(char)*4);
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top]));
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,"not");
    strcpy(q[quadlen].arg1,st[top]);
    strcpy(q[quadlen].res,temp);
    quadlen++;
    printf("if %s goto L%d\n",temp,lnum);
    q[quadlen].op = (char*)malloc(sizeof(char)*3);
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(temp));
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"if");
    strcpy(q[quadlen].arg1,temp);
    char x[10];
    sprintf(x,"%d",lnum);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;
    temp_i++;
    label[++ltop]=lnum;
    return ;
}




void ifelse2()
{
    int x;
    lnum++;
    x=label[ltop--];
    printf("goto L%d\n",lnum);
    q[quadlen].op = (char*)malloc(sizeof(char)*5);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"goto");
    char jug[10];
    sprintf(jug,"%d",lnum);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,jug));
    quadlen++;
    printf("L%d: \n",x);
    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(x+2));
    strcpy(q[quadlen].op,"Label");

    char jug1[10];
    sprintf(jug1,"%d",x);
    char l1[]="L";
    strcpy(q[quadlen].res,strcat(l1,jug1));
    quadlen++;
    label[++ltop]=lnum;
    return ;
}

void ifelse3()
{
int y;
y=label[ltop--];
printf("L%d: \n",y);
q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(y+2));
    strcpy(q[quadlen].op,"Label");
    char x[10];
    sprintf(x,"%d",y);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;
lnum++;
return; 
}


void while1()
{

    l_while = lnum;
    printf("L%d: \n",lnum++);
    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"Label");
    char x[10];
    sprintf(x,"%d",lnum-1);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;
    return ;
}

void while2()
{
 strcpy(temp,"T");
 sprintf(tmp_i, "%d", temp_i);
 strcat(temp,tmp_i);
 printf("%s = not %s\n",temp,st[top]);
    q[quadlen].op = (char*)malloc(sizeof(char)*4);
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top]));
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,"not");
    strcpy(q[quadlen].arg1,st[top]);
    strcpy(q[quadlen].res,temp);
    quadlen++;
    printf("if %s goto L%d\n",temp,lnum);
    q[quadlen].op = (char*)malloc(sizeof(char)*3);
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(temp));
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"if");
    strcpy(q[quadlen].arg1,temp);
    char x[10];
    sprintf(x,"%d",lnum);char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;

 temp_i++;
 
 return;
 }

void while3()
{

printf("goto L%d \n",l_while);
q[quadlen].op = (char*)malloc(sizeof(char)*5);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(l_while+2));
    strcpy(q[quadlen].op,"goto");
    char x[10];
    sprintf(x,"%d",l_while);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;
    printf("L%d: \n",lnum++);
    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"Label");
    char x1[10];
    sprintf(x1,"%d",lnum-1);
    char l1[]="L";
    strcpy(q[quadlen].res,strcat(l1,x1));
    quadlen++;

    return;
}


// handles lable befor condition
void for1()
{
    // l_for is later used to refer to this lable
    l_for = lnum;
    printf("L%d: \n",lnum++);
    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"Label");
    char x[10];
    sprintf(x,"%d",lnum-1);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;

    return;
}

void for2()
{
    // doing T1 = not T0
    // stack T0
    strcpy(temp,"T");
    sprintf(tmp_i, "%d", temp_i);
    strcat(temp,tmp_i);
    // temp = T1

    printf("%s = not %s\n",temp,st[top]);
    q[quadlen].op = (char*)malloc(sizeof(char)*4);
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top]));
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,"not");
    strcpy(q[quadlen].arg1,st[top]);
    strcpy(q[quadlen].res,temp);
    quadlen++;


    // if T1 goto L1
    printf("if %s goto L%d\n",temp,lnum);
    q[quadlen].op = (char*)malloc(sizeof(char)*3);
    q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(temp));
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"if");
    strcpy(q[quadlen].arg1,temp);
    char x[10];
    sprintf(x,"%d",lnum);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,x));
    quadlen++;

    // goto L2
    temp_i++;
    label[++ltop]=lnum;
    lnum++;
    printf("goto L%d\n",lnum);
    q[quadlen].op = (char*)malloc(sizeof(char)*5);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"goto");
    char x1[10];
    sprintf(x1,"%d",lnum);
    char l1[]="L";
    strcpy(q[quadlen].res,strcat(l1,x1));
    quadlen++;

    // L3
    label[++ltop]=lnum;
    printf("L%d: \n",++lnum);
    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
    strcpy(q[quadlen].op,"Label");
    char x2[10];
    sprintf(x2,"%d",lnum);
    char l2[]="L";
    strcpy(q[quadlen].res,strcat(l2,x2));
    quadlen++;

    return ;
    
}


void for3()
{ 
    // goto to first lable in for loop
    int x;
    x=label[ltop--];
    printf("goto L%d \n",l_for);
    q[quadlen].op = (char*)malloc(sizeof(char)*5);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,"goto");
    char jug[10];
    sprintf(jug,"%d",l_for);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,jug));
    quadlen++;

    // goto L2
    printf("L%d: \n",x);    
    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(x+2));
    strcpy(q[quadlen].op,"Label");
    char jug1[10];
    sprintf(jug1,"%d",x);
    char l1[]="L";
    strcpy(q[quadlen].res,strcat(l1,jug1));
    quadlen++;
    
    return ;

}

void for4()
{
    // goto L3
    int x;
    x=label[ltop--];
    printf("goto L%d \n",lnum);

    q[quadlen].op = (char*)malloc(sizeof(char)*5);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
    strcpy(q[quadlen].op,"goto");
    char jug[10];
    sprintf(jug,"%d",lnum);
    char l[]="L";
    strcpy(q[quadlen].res,strcat(l,jug));
    quadlen++;


    // L1:
    printf("L%d: \n",x);

    q[quadlen].op = (char*)malloc(sizeof(char)*6);
    q[quadlen].arg1 = NULL;
    q[quadlen].arg2 = NULL;
    q[quadlen].res = (char*)malloc(sizeof(char)*(x+2));
    strcpy(q[quadlen].op,"Label");
    char jug1[10];
    sprintf(jug1,"%d",x);
    char l1[]="L";
    strcpy(q[quadlen].res,strcat(l1,jug1));
    quadlen++;

    return;
}

void ternary1()
{
   lnum++;
   strcpy(temp,"T");
   sprintf(tmp_i, "%d", temp_i);
   strcat(temp,tmp_i);
   //printf("%s = not %s\n",temp,st[top]);
   q[quadlen].op = (char*)malloc(sizeof(char)*4);
      q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(st[top]));
      q[quadlen].arg2 = NULL;
      q[quadlen].res = (char*)malloc(sizeof(char)*strlen(temp));
      strcpy(q[quadlen].op,"not");
      strcpy(q[quadlen].arg1,st[top]);
      strcpy(q[quadlen].res,temp);
      quadlen++;
   //printf("if %s goto L%d\n",temp,lnum);
   q[quadlen].op = (char*)malloc(sizeof(char)*3);
      q[quadlen].arg1 = (char*)malloc(sizeof(char)*strlen(temp));
      q[quadlen].arg2 = NULL;
      q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
      strcpy(q[quadlen].op,"if");
      strcpy(q[quadlen].arg1,temp);
      char x[10];
      sprintf(x,"%d",lnum);
      char l[]="L";
      strcpy(q[quadlen].res,strcat(l,x));
      quadlen++;

   temp_i++;
   label[++ltop]=lnum;

   return;
}

void ternary2()
{
  int x;
  lnum++;
  x=label[ltop--];
  //printf("goto L%d\n",lnum);
  q[quadlen].op = (char*)malloc(sizeof(char)*5);
      q[quadlen].arg1 = NULL;
      q[quadlen].arg2 = NULL;
      q[quadlen].res = (char*)malloc(sizeof(char)*(lnum+2));
      strcpy(q[quadlen].op,"goto");
      char jug[10];
      sprintf(jug,"%d",lnum);
      char l[]="L";
      strcpy(q[quadlen].res,strcat(l,jug));
      quadlen++;
  //printf("L%d: \n",x);
  q[quadlen].op = (char*)malloc(sizeof(char)*6);
      q[quadlen].arg1 = NULL;
      q[quadlen].arg2 = NULL;
      q[quadlen].res = (char*)malloc(sizeof(char)*(x+2));
      strcpy(q[quadlen].op,"Label");
      char jug1[10];
      sprintf(jug1,"%d",x);
      char l1[]="L";
      strcpy(q[quadlen].res,strcat(l1,jug1));
      quadlen++;
      label[++ltop]=lnum;
  return;
}

void ternary3()
{
  int y;
  y=label[ltop--];
  //printf("L%d: \n",y);
  q[quadlen].op = (char*)malloc(sizeof(char)*6);
      q[quadlen].arg1 = NULL;
      q[quadlen].arg2 = NULL;
      q[quadlen].res = (char*)malloc(sizeof(char)*(y+2));
      strcpy(q[quadlen].op,"Label");
      char x[10];
      sprintf(x,"%d",y);
      char l[]="L";
      strcpy(q[quadlen].res,strcat(l,x));
      quadlen++;
  lnum++;

  return;
}