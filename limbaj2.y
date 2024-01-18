%{
#include <iostream>
#include <vector>
#include <iomanip>
#include <cstring>
#include <fstream>
#include "symbol_table.cpp"

using namespace std;

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
void yyerror(const char* s);
extern int yylex();

%}

%token MAIN FLOAT_VAL BOOL_VAL BOOL CONST ID INT FLOAT STR STRING CHARACTER VAL CHAR VOID RETURN START END EVAL TYPEOF IF ELSE FOR WHILE FUNCTION CLASS ASSIGN LT GT LE GE EQ NE ADD SUB MUL DIV AND OR INC DEC


%left ASSIGN
%left OR
%left AND
%left EQ NE LT GT LE GE
%left ADD SUB
%left MUL DIV
%left INC DEC

%start program

%%

program: main {printf("Programul este corect din punct de vedere sintactic!\n");}
;

main: type MAIN '(' ')' { bloc_instr }
;

type: INT
| FLOAT
;