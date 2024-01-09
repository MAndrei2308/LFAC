%{
#include <iostream>

using namespace std;
%}
%option noyywrap
%%
([-]?[1-9][0-9]*|0) {yylval=atoi(yytext); return VAL;}
([-]?[0]\.[0-9]+|[1-9][0-9]*\.[0-9]+) {yylval=atoi(yytext); return FLOAT_VAL;}
"adevarat"|"fals" {return BOOL_VAL;}
"intreg"|"real"|"bolean"|"caracter"|"sir" {yylval.string = strdup(yytext);return TYPE;}
"incepe_program:" {return START;}
"termina_program" {return END;}
"daca" {return IF;}
"altfel" {return ELSE;}
"pentru" {return FOR;}
"cat_timp" {return WHILE;}
"functie" {return FUNCION;}
"clasa" {return CLASS;}
[a-zA-Z][a-zA-Z0-9]* {yylval.string = strdup(yytext); return ID;}
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
[0-9]+ {return NR;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

 