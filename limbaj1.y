%{
#include <iostream>
#include <vector>
#include <iomanip>
#include <cstring>
#include <fstream>

using namespace std;

ofstream file("symbol_table.txt");

extern FILE* yyin;
extern char* yytext;
extern int yylineno;
void yyerror(const char* s);
extern int yylex();

struct {
    char *nume;
    char *info;
    char *tip;
    char *valoare;
    char *locatie;
} symbol_table[101];

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

afirmatie: type ID ASSIGN value {strcpy(nume,yytext);strcpy(locatie,"Local"); adaugare('V');}
         | type ID {strcpy(nume,yytext);strcpy(locatie,"Local"); adaugare('V');}
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

    if(!file.is_open())
    {
        cerr << "Eroare la deschiderea fisierului.\n";
        return 0;
    }

    int nume_width = 15;
    int info_width = 15;
    int tip_width = 10;
    int valoare_width = 10;
    int locatie_width = 15;

    file << "TABELUL DE SIMBOLURI PENTRU VARIABILE\n\n";
    file << left << setw(nume_width)    << "NUME"
                 << setw(info_width)     << "INFO"
                 << setw(tip_width)     << "TIP"
                 << setw(valoare_width) << "VALOARE" 
                 << setw(locatie_width) << "LOCATIE"
                 << "\n";
    file << "----------------------------------------------------------\n";
    
    for(int i=0;i<count;i++)
    {
        file << left << setw(nume_width)    << symbol_table[i].nume 
                     << setw(info_width)     << symbol_table[i].info
                     << setw(tip_width)     << symbol_table[i].tip
                     << setw(valoare_width) << symbol_table[i].valoare
                     << setw(locatie_width) << symbol_table[i].locatie
                     << "\n";
    }
}