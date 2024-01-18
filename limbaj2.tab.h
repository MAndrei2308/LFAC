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

#ifndef YY_YY_LIMBAJ2_TAB_H_INCLUDED
# define YY_YY_LIMBAJ2_TAB_H_INCLUDED
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
    MAIN = 258,
    FLOAT_VAL = 259,
    BOOL_VAL = 260,
    BOOL = 261,
    CONST = 262,
    ID = 263,
    INT = 264,
    FLOAT = 265,
    STR = 266,
    STRING = 267,
    CHARACTER = 268,
    VAL = 269,
    CHAR = 270,
    VOID = 271,
    RETURN = 272,
    START = 273,
    END = 274,
    EVAL = 275,
    TYPEOF = 276,
    IF = 277,
    ELSE = 278,
    FOR = 279,
    WHILE = 280,
    FUNCTION = 281,
    CLASS = 282,
    ASSIGN = 283,
    LT = 284,
    GT = 285,
    LE = 286,
    GE = 287,
    EQ = 288,
    NE = 289,
    ADD = 290,
    SUB = 291,
    MUL = 292,
    DIV = 293,
    AND = 294,
    OR = 295,
    INC = 296,
    DEC = 297
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_LIMBAJ2_TAB_H_INCLUDED  */
