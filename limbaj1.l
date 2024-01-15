%{
#include <iostream>
#include "limbaj1.tab.h"

using namespace std;
%}
%option noyywrap
%%
([-]?[1-9][0-9]*|0) {return VAL;}
([-]?[0]\.[0-9]+|[1-9][0-9]*\.[0-9]+) {return FLOAT_VAL;}
"adevarat"|"fals" {return BOOL_VAL;}
"intreg" {return INT;}
"real" {return FLOAT;}
"bolean" {return BOOL;}
"caracter" {return CHAR;}
"sir" {return STRING;}
"constanta" {return CONST;}
"void" {return VOID;}
"return" {return RETURN;}
"incepe_program:" {return START;}
"termina_program" {return END;}
"daca" {return IF;}
"altfel" {return ELSE;}
"pentru" {return FOR;}
"cat_timp" {return WHILE;}
"functie" {return FUNCTION;}
"clasa" {return CLASS;}
[a-zA-Z][a-zA-Z0-9]* {return ID;}
"++" {return INC;}
"--" {return DEC;}
"<=" {return LE;}
">=" {return GE;}
"==" {return EQ;}
":=" {return ASSIGN;}
"<" {return LT;}
">" {return GT;}
"!=" {return NE;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"&&" {return AND;}
"||" {return OR;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
["].*["] {return STRING;}
['].['] {return CHARACTER;}



 