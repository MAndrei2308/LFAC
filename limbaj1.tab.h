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

#ifndef YY_YY_LIMBAJ1_TAB_H_INCLUDED
# define YY_YY_LIMBAJ1_TAB_H_INCLUDED
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
    ID = 258,
    INT = 259,
    FLOAT = 260,
    STR = 261,
    STRING = 262,
    CHARACTER = 263,
    VAL = 264,
    CHAR = 265,
    PUBLIC = 266,
    PRIVAT = 267,
    FLOAT_VAL = 268,
    BOOL_VAL = 269,
    BOOL = 270,
    CONST = 271,
    VOID = 272,
    RETURN = 273,
    START = 274,
    END = 275,
    EVAL = 276,
    TYPEOF = 277,
    IF = 278,
    ELSE = 279,
    FOR = 280,
    WHILE = 281,
    FUNCTION = 282,
    CLASS = 283,
    STRUCT = 284,
    ASSIGN = 285,
    LT = 286,
    GT = 287,
    LE = 288,
    GE = 289,
    EQ = 290,
    NE = 291,
    ADD = 292,
    SUB = 293,
    MUL = 294,
    DIV = 295,
    AND = 296,
    OR = 297,
    INC = 298,
    DEC = 299
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 115 "limbaj1.y"

    int intval;       // pentru tokenii care returnează valori întregi
    float floatval;   // pentru tokenii care returnează valori reale
    char* strval;     // pentru tokenii care returnează șiruri de caractere
    char charval;

#line 109 "limbaj1.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_LIMBAJ1_TAB_H_INCLUDED  */
