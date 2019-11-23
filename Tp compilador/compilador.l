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
Identificador {Letra}({Letra}|{Digito})*
Constante {Digito}({Digito})*
Espacio [[:space:]]

%%

"inicio" {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return INICIO;}

"fin" {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return FIN;}

"leer" {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return LEER;}

"escribir" {printf("-- Lexema: \"%s\",Longitud: %d\n",yytext, yyleng); return ESCRIBIR;}

"+" {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return SUMA;}

"-" {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return RESTA;}

":=" {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return ASIGNACION;}

"," {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return COMA;}

"(" {printf("-- Lexema: \"%s\", Longitud: %d\n",yytext, yyleng); return PARENIZQUIERDO;}

")" {printf("-- Lexema: \"%s\",Longitud: %d\n",yytext, yyleng); return PARENDERECHO;}

";" {printf("-- Lexema: \"%s\",Longitud: %d\n",yytext, yyleng); return PUNTOYCOMA;}

{Identificador} {printf("-- Lexema: \"%s\",Longitud: %d\n",yytext, yyleng); yylval = strdup(yytext); return IDENTIFICADOR;}

{Constante} {printf("-- Lexema: \"%s\",Longitud: %d\n",yytext, yyleng); yylval = strdup(yytext); return CONSTANTE;}

{Espacio}+ /* ignorar espacios */

%%
