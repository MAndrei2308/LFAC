#include <iostream>
#include <cstring>
#include <fstream>
#include <iomanip> // pentru stilizarea tabelului
using namespace std;

const int SIZE = 100; // dimensiunea pentru char*

struct var
{
    char nume[SIZE];
    char tip[SIZE];
    char valoare[SIZE];
    char locatie[SIZE];
};

struct fct
{
    char nume[SIZE];
    char tip_return[SIZE];
    char parametri[SIZE];
    char locatie[SIZE];
};

const int TABLE_SIZE = 100; // dimensiunea tabelului

var tabel_variabile[TABLE_SIZE];
fct tabel_functii[TABLE_SIZE];

int index_var = 0; // index pentru tabel
int index_fct = 0;

void add_var(const char* nume, const char* tip, const char* valoare, const char* locatie)
{
    if (index_var < TABLE_SIZE)
    {
        strncpy(tabel_variabile[index_var].nume, nume, SIZE);
        strncpy(tabel_variabile[index_var].tip, tip, SIZE);
        strncpy(tabel_variabile[index_var].valoare, valoare, SIZE);
        strncpy(tabel_variabile[index_var].locatie, locatie, SIZE);
        index_var++;
    }
}

void add_fct(const char* nume, const char* tip_return, const char* parametri, const char* locatie)
{
    if (index_fct < TABLE_SIZE)
    {
        strncpy(tabel_functii[index_fct].nume, nume, SIZE);
        strncpy(tabel_functii[index_fct].tip_return, tip_return, SIZE);
        strncpy(tabel_functii[index_fct].parametri, parametri, SIZE);
        strncpy(tabel_functii[index_fct].locatie, locatie, SIZE);
        index_fct++;
    }
}

void print_table()
{
    ofstream file("symbol_table.txt");

    if(!file.is_open())
    {
        cerr << "Eroare la deschiderea fisierului.\n";
        return;
    }

    int nume_width = 15;
    int tip_width = 10;
    int valoare_width = 10;
    int locatie_width = 15;

    file << "TABELUL DE SIMBOLURI PENTRU VARIABILE\n\n";
    file << left << setw(nume_width)    << "NUME" 
                 << setw(tip_width)     << "TIP"
                 << setw(valoare_width) << "VALOARE" 
                 << setw(locatie_width) << "LOCATIE"
                 << "\n";
    file << "-------------------------------------------\n";
    for (int i = 0; i < index_var; i++)
    {
        file  << left << setw(nume_width)    << tabel_variabile[i].nume
                      << setw(tip_width)     << tabel_variabile[i].tip
                      << setw(valoare_width) << tabel_variabile[i].valoare
                      << setw(locatie_width) << tabel_variabile[i].locatie  << "\n";
    }

    file << "\n\n\n\n\n";

    int tip_return_width = 20;
    int parametri_width = 20;

    file << "TABELUL DE SIMBOLURI PENTRU FUNCTII\n\n";
    file << left << setw(nume_width)    << "NUME" 
                 << setw(tip_return_width)     << "TIP_RETURN"
                 << setw(parametri_width) << "PARAMETRI" 
                 << setw(locatie_width) << "LOCATIE"
                 << "\n";
    file << "---------------------------------------------------------------\n";
    for (int i = 0; i < index_var; i++)
    {
        file  << left << setw(nume_width)       << tabel_functii[i].nume
                      << setw(tip_return_width) << tabel_functii[i].tip_return
                      << setw(parametri_width)  << tabel_functii[i].parametri
                      << setw(locatie_width)    << tabel_functii[i].locatie  << "\n";
    }


    file.close();
    cout << "Realizat\n";
}

int main()
{
    add_var("test1", "int", "0", "global");
    add_fct("fct1", "void", "int", "global");
    print_table();
}