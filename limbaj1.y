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

int count=0;

char nume[40];
char tip[40];
char val[40];
char locatie[40];
void adaugare(char c)
{
    if(c=='V')
    {
        symbol_table[count].nume=strdup(nume);
        symbol_table[count].info=strdup("Variabila");
        symbol_table[count].tip=strdup(tip);
        symbol_table[count].valoare=strdup(val);
        symbol_table[count].locatie=strdup(locatie);
        count++;
    }
    else if(c=='F')
    {
        symbol_table[count].nume=strdup(nume);
        symbol_table[count].info=strdup("Functie");
        symbol_table[count].tip=strdup(tip);
        symbol_table[count].valoare=strdup("-");
        symbol_table[count].locatie=strdup(locatie);
        count++;
    }
}
%}

%union {
    int intval;       // pentru tokenii care returnează valori întregi
    float floatval;   // pentru tokenii care returnează valori reale
    char* strval;     // pentru tokenii care returnează șiruri de caractere
}

%token <strval> ID INT FLOAT CHAR STRING
%type <strval> expr value
%token VAL FLOAT_VAL BOOL_VAL BOOL CONST VOID RETURN START END IF ELSE FOR WHILE FUNCTION CLASS ASSIGN LT GT LE GE EQ NE ADD SUB MUL DIV AND OR INC DEC CHARACTER 

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

main: type ID {strcpy(locatie,"Global"); strcpy(nume,yytext);adaugare('F');}
    ;

type: INT { strcpy(tip,"INT");}
    | FLOAT { strcpy(tip,"FLOAT");}
    | CHAR { strcpy(tip,"CHAR");}
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

arg1: type ID ASSIGN value {strcpy(nume,yytext);strcpy(locatie,"Local"); adaugare('V');}
    | ID ASSIGN value
    ;

arg2: conditie;

arg3: ID INC
    | ID DEC
    | INC ID
    | DEC ID
    ;

conditie: value comparatie value
        ;

value: VAL {strcpy(val,yytext);}
     | FLOAT_VAL {strcpy(val,yytext);}
     | ID {strcpy(val, yytext); }
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
    { 
    char* a = get_value($1, count);
    char* b = get_value($3, count);
    int val_a = atoi(a);
    int val_b = atoi(b);
    cout << val_a << " " << val_b << endl;
    int sum = val_a + val_b;
    char temp[40]; // Presupunând că 40 este suficient pentru a stoca rezultatul
    sprintf(temp, "%d", sum); // Convertește suma înapoi în string
    strcpy(val, temp); // Copiază rezultatul în val
    cout << val << endl;
    // cout << "p: " << a << " " << a << endl;
    // cout << "\ntest: " << val << "\n";
    }
    | expr SUB expr
    | expr MUL expr
    | expr DIV expr
    ;

afirmatie: type ID ASSIGN value {strcpy(nume, $2);strcpy(locatie,"Local"); adaugare('V'); }
         | type ID {strcpy(nume,$2);strcpy(locatie,"Local"); adaugare('V');}
         | ID ASSIGN expr
         | ID comparatie expr
         | arg3
         ;


cfv: {strcpy(locatie,"Global");}
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
    print_table(count);
}