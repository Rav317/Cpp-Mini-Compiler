/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_ID = 258,
    T_NUM = 259,
    T_LT = 260,
    T_GT = 261,
    T_AND = 262,
    T_OR = 263,
    T_NOT = 264,
    T_EQ = 265,
    T_WHILE = 266,
    T_INT = 267,
    T_CHAR = 268,
    T_FLOAT = 269,
    T_VOID = 270,
    T_HEADER = 271,
    T_MAIN = 272,
    T_INCLUDE = 273,
    T_IF = 274,
    T_ELSE = 275,
    T_COUT = 276,
    T_STRING = 277,
    T_FOR = 278,
    T_ENDL = 279,
    T_LCBKT = 280,
    T_RCBKT = 281,
    T_RLBKT = 282,
    T_RRBKT = 283,
    T_SEMICOLON = 284,
    T_PL = 285,
    T_MIN = 286,
    T_MUL = 287,
    T_DIV = 288
  };
#endif
/* Tokens.  */
#define T_ID 258
#define T_NUM 259
#define T_LT 260
#define T_GT 261
#define T_AND 262
#define T_OR 263
#define T_NOT 264
#define T_EQ 265
#define T_WHILE 266
#define T_INT 267
#define T_CHAR 268
#define T_FLOAT 269
#define T_VOID 270
#define T_HEADER 271
#define T_MAIN 272
#define T_INCLUDE 273
#define T_IF 274
#define T_ELSE 275
#define T_COUT 276
#define T_STRING 277
#define T_FOR 278
#define T_ENDL 279
#define T_LCBKT 280
#define T_RCBKT 281
#define T_RLBKT 282
#define T_RRBKT 283
#define T_SEMICOLON 284
#define T_PL 285
#define T_MIN 286
#define T_MUL 287
#define T_DIV 288

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
