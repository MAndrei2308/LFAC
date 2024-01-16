#!/bin/bash

# Execută Flex
flex limbaj1.l

# Execută Bison
bison -d limbaj1.y

# Compilează codul generat și sursa C++ folosind g++
g++ lex.yy.c limbaj1.tab.c -o compiler_output

# Rulează programul compilat cu fișierul de intrare
./compiler_output test2.txt
