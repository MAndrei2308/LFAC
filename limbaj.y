%{
#include <iostream>
#include <vector>

using namespace std;

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
void yyerror(const char* s);
extern int yylex();
%}

%token VAL FLOAT_VAL BOOL_VAL TYPE CONST VOID RETURN START END IF ELSE FOR WHILE FUNCTION CLASS ID ASSIGN LT GT LE GE EQ NE ADD SUB MUL DIV AND OR INC DEC

%left ASSIGN
%left OR
%left AND
%left EQ NE LT GT LE GE
%left ADD SUB
%left MUL DIV
%left INC DEC

%start program

%%
program: cfv START bloc_instr END {printf("Programul este corect din punct de vedere sintactic!\n");}
    ;

cfv: clasa cfv 
   | functie_nume cfv
   | variabila_TYPE cfv
   |
   ;

bloc_instr: expr ';' bloc_instr
          | variabila_TYPE bloc_instr
          | variabila ';' bloc_instr
          | if bloc_instr
          | while bloc_instr
          | for bloc_instr
          | 
          ;

if: IF '(' expr ')' '{' bloc_instr '}'
  | IF '(' expr ')' '{' bloc_instr '}' ELSE '{' bloc_instr '}';

while: WHILE '(' expr ')' '{' bloc_instr '}';

for: FOR '(' arg1 ';' arg2 ';' arg3 ')' '{' bloc_instr '}';

arg1: TYPE ID ASSIGN expr;

arg2: expr;

arg3: ID ASSIGN expr;

expr: expr ADD expr {$$=$1+$3;}
     | expr SUB expr {$$=$1-$3;}
     | expr MUL expr {$$=$1*$3;}
     | expr DIV expr {$$=$1/$3;}
     | expr LT expr {if($1<$3)$$=1; else $$=0;}
     | expr GT expr {if($1>$3)$$=1; else $$=0;}
     | expr LE expr {if($1<=$3)$$=1; else $$=0;}
     | expr GE expr {if($1>=$3)$$=1; else $$=0;}
     | expr EQ expr {if($1==$3)$$=1; else $$=0;}
     | expr NE expr {if($1!=$3)$$=1; else $$=0;}
     | VAL
     | FLOAT_VAL
     | BOOL_VAL
     | variabila_sir
     | '(' expr ')'
     | '(' '-' ID ')'
     | '(' '-' VAL ')'
     | '(' '-' FLOAT_VAL ')'
     | TYPE
     | functie
     ;

variabila_sir: ID
             | ID '[' VAL ']'
             ;

clasa: CLASS ID '{' bloc_instr_clasa '}'
     ;

bloc_instr_clasa: variabila_TYPE
                | variabila_TYPE bloc_instr_clasa
                | functie_nume
                | functie_nume bloc_instr_clasa 
                ;

variabila_TYPE: TYPE variabila ';'
             | CONST TYPE ID ASSIGN expr ';'
             | TYPE variabila_sir ';'
             ;

variabila: ID ',' variabila
         | ID ',' variabila_sir
         | ID '[' VAL ']' variabila
         | ID '[' VAL ']' variabila_sir
         | ID ASSIGN expr
         | ID ASSIGN expr ',' variabila
         | ID ASSIGN expr ',' variabila_sir
         ;

functie_nume: FUNCTION TYPE ID '(' ')' '{' bloc_instr '}'
            | FUNCTION TYPE ID '(' param_functie ')' '{' bloc_instr '}'
            | FUNCTION VOID ID '(' ')' '{' bloc_instr '}'
            | FUNCTION VOID ID '(' param_functie ')' '{' bloc_instr '}'
            | FUNCTION TYPE ID '(' ')' ';'
            | FUNCTION TYPE ID '(' param_functie ')' ';'
            | FUNCTION VOID ID '(' ')' ';'
            | FUNCTION VOID ID '(' param_functie ')' ';'
            ;

param_functie: TYPE ID
             | param_functie ',' TYPE ID
             ;

functie: ID '(' ')'
       | ID '(' param_functie')'

%%
void yyerror(const char* s)
{
     printf("Eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv)
{
     yyin=fopen(argv[1],"r");
     yyparse();

}