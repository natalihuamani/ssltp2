%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "compilador.tab.h"
%}

%option yylineno
%option noinput
%option nounput

Letra [[:alpha:]]
Digito [0-9]
s
Identificador {Letra}({Letra}|{Digito})*
Constante {Digito}({Digito})*
Espacio [[:space:]]

%%

"inicio" {printf("-- Lexema: \"%s\", Token: PR, Longitud: %d\n",yytext, yyleng); return INICIO;}

"fin" {printf("-- Lexema: \"%s\", Token: PR, Longitud: %d\n",yytext, yyleng); return FIN;}

"leer" {printf("-- Lexema: \"%s\", Token: PR, Longitud: %d\n",yytext, yyleng); return LEER;}

"escribir" {printf("-- Lexema: \"%s\", Token: PR, Longitud: %d\n",yytext, yyleng); return ESCRIBIR;}

"+" {printf("-- Lexema: \"%s\", Token: Suma, Longitud: %d\n",yytext, yyleng); return SUMA;}

"-" {printf("-- Lexema: \"%s\", Token: Resta, Longitud: %d\n",yytext, yyleng); return RESTA;}

":=" {printf("-- Lexema: \"%s\", Token: Asignacion, Longitud: %d\n",yytext, yyleng); return ASIGNACION;}

"," {printf("-- Lexema: \"%s\", Token: Coma, Longitud: %d\n",yytext, yyleng); return COMA;}

"(" {printf("-- Lexema: \"%s\", Token: Parentesis Izq, Longitud: %d\n",yytext, yyleng); return PARENIZQUIERDO;}

")" {printf("-- Lexema: \"%s\", Token: Parentesis Derecho, Longitud: %d\n",yytext, yyleng); return PARENDERECHO;}

";" {printf("-- Lexema: \"%s\", Token: Punto y Coma, Longitud: %d\n",yytext, yyleng); return PUNTOYCOMA;}

{Identificador} {printf("-- Lexema: \"%s\", Token: Identificador, Longitud: %d\n",yytext, yyleng); yylval = strdup(yytext); return IDENTIFICADOR;}

{Constante} {printf("-- Lexema: \"%s\", Token: Constante, Longitud: %d\n",yytext, yyleng); yylval = strdup(yytext); return CONSTANTE;}

{Espacio}+ /* ignorar espacios */

"//"(.*)\n /* ignorar comentarios */

"." {yyerror("Error lexico: caracter invalido");}

%%