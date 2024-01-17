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

void TypeOf(char* arg)
{
    for(int i=0;i<count;i++)
    {
        if(strcmp(symbol_table[i].nume,arg)==0)
        {

        }
    }
}

void Eval(char* arg)
{
    for(int i=0;i<count;i++)
    {
        if(strcmp(symbol_table[i].nume,arg)==0)
        {
        }
    }
}

%}

%union {
    int intval;       // pentru tokenii care returnează valori întregi
    float floatval;   // pentru tokenii care returnează valori reale
    char* strval;     // pentru tokenii care returnează șiruri de caractere
    char charval;
}

%token <strval> ID INT FLOAT STR STRING CHARACTER
%type <strval> expr value
%token <charval> CHAR
%token VAL FLOAT_VAL BOOL_VAL BOOL CONST VOID RETURN START END EVAL TYPEOF IF ELSE FOR WHILE FUNCTION CLASS ASSIGN LT GT LE GE EQ NE ADD SUB MUL DIV AND OR INC DEC

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
    ;

bloc_instr: if
          | while
          | for
          | afirmatie ';'
          | if bloc_instr
          | while bloc_instr
          | for bloc_instr
          | afirmatie ';' bloc_instr
          | TYPEOF '(' ID ')' ';' { TypeOf($3);}
          | EVAL '(' ID ')' ';' { Eval($3);}
          | TYPEOF '(' ID ')' ';' { TypeOf($3);} bloc_instr
          | EVAL '(' ID ')' ';' { Eval($3);} bloc_instr
          ;

if: IF '(' conditie ')' '{' bloc_instr '}'
  | IF '(' conditie ')' '{' bloc_instr '}' ELSE '{' bloc_instr '}'
  ;

while: WHILE '(' conditie ')' '{' bloc_instr '}';

for: FOR '(' arg1 ';' arg2 ';' arg3 ')' '{' bloc_instr '}';

arg1: type ID ASSIGN value 
    {   if (declarare_multipla($2, count) == true)printf("Declarare multipla\n"); 
        else 
        {
            strcpy(nume,yytext);strcpy(locatie,"Local"); adaugare('V');
        }
        }
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
    int sum = val_a + val_b;
    char temp[40]; 
    sprintf(temp, "%d", sum);
    strcpy(val, temp);
    value_returned($1, count, val);
    // cout << "p: " << a << " " << a << endl;
    // cout << "\ntest: " << val << "\n";
    }
    | expr SUB expr
    { 
    char* a = get_value($1, count);
    char* b = get_value($3, count);
    int val_a = atoi(a);
    int val_b = atoi(b);
    int sum = val_a - val_b;
    char temp[40]; 
    sprintf(temp, "%d", sum);
    strcpy(val, temp);
    value_returned($1, count, val);
    }
    | expr MUL expr
    { 
    char* a = get_value($1, count);
    char* b = get_value($3, count);
    int val_a = atoi(a);
    int val_b = atoi(b);
    int sum = val_a * val_b;
    char temp[40]; 
    sprintf(temp, "%d", sum);
    strcpy(val, temp);
    value_returned($1, count, val);
    }
    | expr DIV expr
    { 
    char* a = get_value($1, count);
    char* b = get_value($3, count);
    int val_a = atoi(a);
    int val_b = atoi(b);
    int sum = val_a / val_b;
    char temp[40]; 
    sprintf(temp, "%d", sum);
    strcpy(val, temp);
    value_returned($1, count, val);
    }
    ;

afirmatie: type ID ASSIGN value
            {
            if (declarare_multipla($2, count) == true)printf("Declarare multipla\n"); 
             else 
                {
                    strcpy(nume,$2);strcpy(locatie,"Local"); adaugare('V');
                }
            }
         | CHAR ID ASSIGN CHARACTER {
            if (declarare_multipla($2, count) == true)printf("Declarare multipla\n");
            else
            { strcpy(tip,"CHAR"); strcpy(nume, $2); strcpy(val,yytext); strcpy(locatie,"Local"); adaugare('V');}
         }
         | STR ID ASSIGN STRING {
            if (declarare_multipla($2, count) == true)printf("Declarare multipla\n");
            else
            { strcpy(tip,"STRING"); strcpy(nume, $2); strcpy(val,yytext); strcpy(locatie,"Local"); adaugare('V');}
         }
         | type ID 
         {
            if (declarare_multipla($2, count) == true)printf("Declarare multipla\n"); 
             else 
                {
                    {strcpy(val, "neinit"); }strcpy(nume,$2);strcpy(locatie,"Local"); adaugare('V');
                }
            }
         | CHAR ID {
            if (declarare_multipla($2, count) == true)printf("Declarare multipla\n");
            else
            { strcpy(tip,"CHAR");  strcpy(val, "neinit"); strcpy(nume, $2); strcpy(locatie,"Local"); adaugare('V');}
            }
         | STR ID {
            if (declarare_multipla($2, count) == true)printf("Declarare multipla\n");
            else
            { strcpy(tip,"STRING");  strcpy(val, "neinit"); strcpy(nume, $2); strcpy(locatie,"Local"); adaugare('V');}
         }
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