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

%token VAL FLOAT_VAL BOOL_VAL INT FLOAT BOOL CHAR CONST VOID RETURN START END IF ELSE FOR WHILE FUNCTION CLASS ID ASSIGN LT GT LE GE EQ NE ADD SUB MUL DIV AND OR INC DEC CHARACTER STRING

%left ASSIGN
%left OR
%left AND
%left EQ NE LT GT LE GE
%left ADD SUB
%left MUL DIV
%left INC DEC

%start program

%%
program: cfv main '(' ')' '{' bloc_instr '}' {printf("Programul este corect din punct de vedere sintactic!\n");}
    ;

main: type ID
    ;

type: INT
    | FLOAT
    | CHAR
    ;

bloc_instr: if
          | while
          | for
          | afirmatie ';'
          | if bloc_instr
          | while bloc_instr
          | for bloc_instr
          | afirmatie ';' bloc_instr
          ;

if: IF '(' conditie ')' '{' bloc_instr '}'
  | IF '(' conditie ')' '{' bloc_instr '}' ELSE '{' bloc_instr '}'
  ;

while: WHILE '(' conditie ')' '{' bloc_instr '}';

for: FOR '(' arg1 ';' arg2 ';' arg3 ')' '{' bloc_instr '}';

arg1: type ID ASSIGN value
    | ID ASSIGN value;

arg2: conditie;

arg3: ID INC
    | ID DEC
    | INC ID
    | DEC ID
    ;

conditie: value comparatie value
        ;

value: VAL
     | FLOAT_VAL
     | ID
     ;

comparatie: LT
          | GT
          | LE
          | GE
          | EQ
          | NE
          ;

expr: value
    | expr ADD expr
    | expr SUB expr
    | expr MUL expr
    | expr DIV expr
    ;

afirmatie: type ID ASSIGN value
         | type ID
         | ID ASSIGN expr
         | ID comparatie expr
         | arg3
         ;


cfv:
   ;
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