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
int valid = 1;

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

// struct arrayInfo {
//         char type[15];
//         int size;
//         char name[20];
//         vector <int> values;
//     } arraytype;

// void adaugare_sir(char* name, int size)
// {
//     arrayInfo array;
//     strcpy(array.name,name);
//     strcpy(array.type,"int");
//     array.size=size;
//     array.values.resize(size);
//     arraytype.push_back(array);
// }

// int getArrayElement(char* name, int index)
// {
//     for(auto& array : arraytype)
//         if (strcmp(array.name, name) == 0)
//             return array.values[index];
//     return -1;
// }

// void setArrayElement(char* name, int index, int value)
// {
//     for (auto& array: arraytype)
//         if (strcmp(array.name, name) == 0)
//             array.values[index] = value;
//             return;
// }


char* TypeOf(char* arg)
{
    int OK = 0;
    for(int i=0;i<count;i++)
    {
        if(strcmp(symbol_table[i].nume,arg)==0)
        {
            // printf("%s\n",symbol_table[i].tip);
            // OK = 1;
            return symbol_table[i].tip;
        }
    }
    //if(OK == 0)printf("%s was not declared\n", arg);
    return nullptr;
}

char* Eval(char* arg)
{
    int OK = 0;
    for(int i=0;i<count;i++)
    {
        if(strcmp(symbol_table[i].nume,arg)==0)
        {
            // printf("%s\n",symbol_table[i].tip);
            // OK = 1;
            return symbol_table[i].valoare;
        }
    }
    //if(OK == 0)printf("%s was not declared\n", arg);
    return nullptr;
}

%}


%union {
    int intval;       // pentru tokenii care returnează valori întregi
    float floatval;   // pentru tokenii care returnează valori reale
    char* strval;     // pentru tokenii care returnează șiruri de caractere
    char charval;
}

%token <strval> ID INT FLOAT STR STRING CHARACTER VAL
%token <charval> CHAR
%token PUBLIC PRIVAT FLOAT_VAL BOOL_VAL BOOL CONST VOID RETURN START END EVAL TYPEOF IF ELSE FOR WHILE FUNCTION CLASS STRUCT ASSIGN LT GT LE GE EQ NE ADD SUB MUL DIV AND OR INC DEC
%type <strval> expr value

%left ASSIGN
%left OR
%left AND
%left EQ NE LT GT LE GE
%left ADD SUB
%left MUL DIV
%left INC DEC

%start program

%%

program: cfvs main {if(valid == 1)printf("Programul este corect din punct de vedere sintactic!\n");}
    ;

main: START {strcpy(locatie,"Global"); strcpy(nume,"main");adaugare('F'); strcpy(locatie,"main");} bloc_instr END
    ;

cfvs:  var_glob ';' cfvs 
    | functie cfvs {strcpy(locatie,"Global");}
    | CLASS ID '{' {strcpy(locatie,$2);} PRIVAT bloc_privat PUBLIC bloc_public'}' cfvs {strcpy(locatie,"Global");}
    | STRUCT ID '{' {strcpy(locatie,$2);} bloc_struct'}' cfvs {strcpy(locatie,"Global");} lista_ID';'
    |
    ;

lista_ID: ID ',' lista_ID {strcpy(nume,$1); strcpy(val,"neinit"); adaugare('V');}
        | ID {strcpy(nume,$1); strcpy(val,"neinit"); adaugare('V');}
        | ID '[' value ']' ',' lista_ID {strcpy(nume,yytext-4); strcpy(val,"neinit"); adaugare('V');}
        | ID '[' value ']' {strcpy(nume,yytext-6); nume[strlen(nume)-1]='\0'; strcpy(val,"[...]"); adaugare('V');}
        ;

bloc_struct: type ID ';' bloc_struct { strcpy(nume,$2); strcpy(val,"neinit"); adaugare('V');}
           | BOOL ID ';' bloc_struct { strcpy(nume,$2); strcpy(val,"neinit"); adaugare('V');}
           | STRING ID ';' bloc_struct { strcpy(nume,$2); strcpy(val,"neinit"); adaugare('V');}
           | CHAR ID ';' bloc_struct { strcpy(nume,$2); strcpy(val,"neinit"); adaugare('V');}
           | type ID ASSIGN value ';' bloc_privat { strcpy(nume,$2); strcpy(val,$4); adaugare('V');}
           | BOOL ID ASSIGN value ';' bloc_privat { strcpy(nume,$2); strcpy(val,$4); adaugare('V');}
           | STRING ID ASSIGN value ';' bloc_privat { strcpy(nume,$2); strcpy(val,$4); adaugare('V');}
           | CHAR ID ASSIGN value ';' bloc_privat { strcpy(nume,$2); strcpy(val,$4); adaugare('V');}
           |
           ;

bloc_privat: type ID ';' bloc_privat { strcpy(nume,$2); strcpy(val,"neinit"); adaugare('V');}
           | type ID ASSIGN value ';' bloc_privat { strcpy(nume,$2); strcpy(val,$4); adaugare('V');}
           |
           ;

bloc_public: functie bloc_public
          |
          ;

functie: FUNCTION type_f ID '(' ')' ';' { strcpy(nume,$3);adaugare('F');}
       | FUNCTION type_f ID '(' ')' { strcpy(nume,$3);adaugare('F');} '{' {strcpy(locatie,$3);} bloc_instr '}'
       ;

type_f: INT 
      | FLOAT
      | VOID
      ;

var_glob: type ID ASSIGN value {strcpy(val,yytext);strcpy(locatie,"Global"); strcpy(nume,$2);adaugare('V');}
        ;

type: INT { strcpy(tip,"INT");}
    | FLOAT { strcpy(tip,"FLOAT");}
    | CONST INT { strcpy(tip,"CONST INT");}
    | CONST FLOAT { strcpy(tip,"CONST INT");}
    ;

array: type ID '[' VAL ']' {
            //  if (declarare_multipla($2, count) == true)printf("Declarare multipla\n"); 
            //  else 
            //     {
                    // arraytype.size=atoi(yytext);
                    strcpy(nume,yytext-4);
                    // adaugare_sir(nume, arraytype.size);
                    
                    strcpy(val,"[...]");
                    adaugare('V');
            //     }
            }

bloc_instr: if
          | while
          | for
          | afirmatie ';'
          | if bloc_instr
          | while bloc_instr
          | for bloc_instr
          | afirmatie ';' bloc_instr
          | TYPEOF '(' ID ')' ';' { if(valid == 1) printf("TypeOf(%s): %s\n",$3,TypeOf($3));}
          | EVAL '(' ID ')' ';' { if(valid == 1) printf("Eval(%s): %s\n",$3,Eval($3));}
          | TYPEOF '(' ID ')' ';' { if(valid == 1) printf("TypeOf(%s): %s\n",$3,TypeOf($3));} bloc_instr
          | EVAL '(' ID ')' ';' { if(valid == 1) printf("Eval(%s): %s\n",$3,Eval($3));} bloc_instr
          ;

if: IF '(' conditie ')' '{' bloc_instr '}'
  | IF '(' conditie ')' '{' bloc_instr '}' ELSE '{' bloc_instr '}'
  ;

while: WHILE '(' conditie ')' '{' bloc_instr '}';

for: FOR '(' arg1 ';' arg2 ';' arg3 ')' '{' bloc_instr '}';

arg1: type ID ASSIGN value 
    {   if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
        else 
        {
            strcpy(nume,yytext);adaugare('V');
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
    char* a_type;
    char* b_type;
    a_type = TypeOf($1);
    b_type = TypeOf($3);
    if (strcmp(a_type, b_type) == 0)
        {
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
    else {
        printf("Adunarea intre doua tipuri diferite nu este permisa!\n");
        valid = 0;
        }
    }
    | expr SUB expr
    { 
    char* a = get_value($1, count);
    char* b = get_value($3, count);
    char* a_type;
    char* b_type;
    a_type = TypeOf($1);
    b_type = TypeOf($3);
    if (strcmp(a_type, b_type) == 0)
        {
            int val_a = atoi(a);
            int val_b = atoi(b);
            int sum = val_a - val_b;
            char temp[40]; 
            sprintf(temp, "%d", sum);
            strcpy(val, temp);
            value_returned($1, count, val);
            // cout << "p: " << a << " " << a << endl;
            // cout << "\ntest: " << val << "\n";
        }
    else {
        printf("Scaderea intre doua tipuri diferite nu este permisa!\n");
        valid = 0;
        }
    }
    | expr MUL expr
    { 
    char* a = get_value($1, count);
    char* b = get_value($3, count);
    char* a_type;
    char* b_type;
    a_type = TypeOf($1);
    b_type = TypeOf($3);
    if (strcmp(a_type, b_type) == 0)
        {
            int val_a = atoi(a);
            int val_b = atoi(b);
            int sum = val_a * val_b;
            char temp[40]; 
            sprintf(temp, "%d", sum);
            strcpy(val, temp);
            value_returned($1, count, val);
            // cout << "p: " << a << " " << a << endl;
            // cout << "\ntest: " << val << "\n";
        }
    else {
        printf("Inmultirea intre doua tipuri diferite nu este permisa!\n");
        valid = 0;
        }
    }
    | expr DIV expr
    { 
    char* a = get_value($1, count);
    char* b = get_value($3, count);
    char* a_type;
    char* b_type;
    a_type = TypeOf($1);
    b_type = TypeOf($3);
    if (strcmp(a_type, b_type) == 0)
        {
            int val_a = atoi(a);
            int val_b = atoi(b);
            int sum = val_a / val_b;
            char temp[40]; 
            sprintf(temp, "%d", sum);
            strcpy(val, temp);
            value_returned($1, count, val);
            // cout << "p: " << a << " " << a << endl;
            // cout << "\ntest: " << val << "\n";
        }
    else {
        printf("Impartirea intre doua tipuri diferite nu este permisa!\n");
        valid = 0;
        }
    }
    ;

afirmatie: type ID ASSIGN value
            {
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        } 
             else 
                {
                    strcpy(nume,$2);adaugare('V');
                }
            }
         | CHAR ID ASSIGN CHARACTER {
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
            else
            { strcpy(tip,"CHAR"); strcpy(nume, $2); strcpy(val,yytext); adaugare('V');}
         }
         | STR ID ASSIGN STRING {
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
            else
            { strcpy(tip,"STRING"); strcpy(nume, $2); strcpy(val,yytext); adaugare('V');}
         }
         | type ID 
         {
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
             else 
                {
                    {strcpy(val, "neinit"); }strcpy(nume,$2);adaugare('V');
                }
            }
         | CHAR ID {
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
            else
            { strcpy(tip,"CHAR");  strcpy(val, "neinit"); strcpy(nume, $2); adaugare('V');}
            }
         | STR ID {
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
            else
            { strcpy(tip,"STRING");  strcpy(val, "neinit"); strcpy(nume, $2); adaugare('V');}
         }
         | BOOL ID ASSIGN BOOL_VAL{
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
            else{
                strcpy(tip,"BOOL");  strcpy(val,yytext); strcpy(nume, $2); adaugare('V');
            }
         }
         | BOOL ID {
            if (declarare_multipla($2, count) == true)
        {
            printf("Declarare multipla\n"); 
            valid=0;
        }
            else{
                strcpy(tip,"BOOL");  strcpy(nume, $2); adaugare('V');
            }
         }
         | array
         | ID ASSIGN expr
         | ID comparatie expr
         | arg3
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