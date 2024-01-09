%{
#include <iostream>

using namespace std;
%}
%option noyywrap
%%
([-]?[1-9][0-9]*|0) {return VAL;}
([-]?[0]\.[0-9]+|[1-9][0-9]*\.[0-9]+) {return FLOAT_VAL;}
"adevarat"|"fals" {return BOOL_VAL;}
"intreg"|"real"|"bolean"|"caracter"|"sir" {return TYPE;}
"constanta" {return CONST;}
"void" {return VOID;}
"return" {return RETURN;}
"incepe_program:" {return START;}
"termina_program" {return END;}
"daca" {return IF;}
"altfel" {return ELSE;}
"pentru" {return FOR;}
"cat_timp" {return WHILE;}
"functie" {return FUNCION;}
"clasa" {return CLASS;}
[a-zA-Z][a-zA-Z0-9]* {return ID;}
":=" {return ASSIGN;}
"<" {return LT;}
">" {return GT;}
"<=" {return LE;}
">=" {return GE;}
"==" {return EQ;}
"!=" {return NE;}
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"&&" {return AND;}
"||" {return OR;}
"++" {return INC;}
"--" {return DEC;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 