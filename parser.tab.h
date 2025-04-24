/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IF = 258,
     ELSE = 259,
     WHILE = 260,
     SWITCH = 261,
     CASE = 262,
     DEFAULT = 263,
     BREAK = 264,
     TYPE = 265,
     EQ = 266,
     LBRACE = 267,
     RBRACE = 268,
     LPAREN = 269,
     RPAREN = 270,
     ASSIGN = 271,
     SEMICOLON = 272,
     COLON = 273,
     LT = 274,
     GT = 275,
     LE = 276,
     GE = 277,
     NE = 278,
     NUMBER = 279,
     IDENTIFIER = 280,
     LOWER_THAN_ELSE = 281
   };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define WHILE 260
#define SWITCH 261
#define CASE 262
#define DEFAULT 263
#define BREAK 264
#define TYPE 265
#define EQ 266
#define LBRACE 267
#define RBRACE 268
#define LPAREN 269
#define RPAREN 270
#define ASSIGN 271
#define SEMICOLON 272
#define COLON 273
#define LT 274
#define GT 275
#define LE 276
#define GE 277
#define NE 278
#define NUMBER 279
#define IDENTIFIER 280
#define LOWER_THAN_ELSE 281




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 42 "parser.y"
{
    int ival;
    char* sval;
    struct ast_node* ast;
}
/* Line 1529 of yacc.c.  */
#line 107 "parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

