#include <iostream>
#include <fstream>
#include <cstring>
#include <iomanip>
#include <vector>
using namespace std;

ofstream file("symbol_table.txt");

struct {
    char *nume;
    char *info;
    char *tip;
    char *valoare;
    char *locatie;
} symbol_table[101];


void print_table(int count)
{
    if(!file.is_open())
    {
        cerr << "Eroare la deschiderea fisierului.\n";
        return;
    }

    int nume_width = 15;
    int info_width = 15;
    int tip_width = 15;
    int valoare_width = 15;
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

char* get_value(char* nume, int count)
{
    for(int i = 0; i < count; i++)
    {
        if(strcmp(nume, symbol_table[i].nume) == 0)
            return symbol_table[i].valoare;
    }
    return nullptr;
}

void value_returned(char* nume, int count, char* value)
{
    for(int i = 0; i < count; i++)
    {
        if(strcmp(nume, symbol_table[i].nume) == 0)
            strcpy(symbol_table[i].valoare, value);
    }

}

bool declarare_multipla(char* nume, int count)
{
    for (int i = 0; i < count; i++)
    {
        if (strcmp(nume, symbol_table[i].nume) == 0)
            return true;
    }
    return false;
}