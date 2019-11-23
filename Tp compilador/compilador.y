%{
#include <string.h> //para strcpy
#include <stdio.h> //lib estandard
#include <stdlib.h> //atoi y otros
    extern int yylex(void);
    extern void yyerror(char*);
    extern int yyin;

#define TAM_CADENA 32+1
#define TAM_NOMBRE 38+1


    struct registroTS{
        char cadena[TAM_CADENA];
        int atributo; //'P' si es PR, 'I' si es ID
    };

    struct registroTS TS[32];
    int pointerTS = 0;

//funciones:
    void initializeTS();
    void addToTS(char [], int );
    int isInTS(char []);
    void printTS();
    %}

%token INICIO FIN LEER ESCRIBIR IDENTIFICADOR CONSTANTE SUMA RESTA ASIGNACION COMA PARENIZQUIERDO PARENDERECHO PUNTOYCOMA
%right ASIGNACION
%left SUMA RESTA

%%

programa :
INICIO listaSentencias FIN {return 1;}
| INICIO FIN {return 1;}
;
listaSentencias :
sentencia PUNTOYCOMA
| sentencia PUNTOYCOMA listaSentencias
;
sentencia :
LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO
| ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO
| IDENTIFICADOR ASIGNACION expresion {$$=$1; addToTS($$,'I');}
;
listaIdentificadores :
IDENTIFICADOR {addToTS($$,'I');}
| listaIdentificadores COMA IDENTIFICADOR {addToTS($3,'I');}
;
listaExpresiones :
expresion
| listaExpresiones COMA expresion
;
expresion :
primaria
| expresion SUMA primaria
| expresion RESTA primaria
;
primaria :
IDENTIFICADOR {addToTS($$,'I');}
| CONSTANTE
| PARENIZQUIERDO expresion PARENDERECHO
;

%%

int main(int argc, char * argv[])
{
// -------- Declaracion ---------
    FILE *fileIn;
    char nomArchi[TAM_NOMBRE];
// ------ Prep Phase ----------
    initializeTS();
    if ( argc == 2 )  //Hay input file por linea de comandos
    {
        printf("ene");
        strcpy(nomArchi, argv[1]);
        int l = strlen(nomArchi);
        if ( l > TAM_NOMBRE )
        {
            printf("Nombre incorrecto del Archivo Fuente\n");
            return -1;
        }
        if ( (fileIn = fopen(nomArchi, "rb") ) == NULL )
        {
            printf("No se pudo abrir archivo fuente\n");
            return -1;
        }
        yyin=fileIn;
    }
// ------ Work Phase ----------
    yyparse();
// ------ Close Phase ----------
    printTS();
    printf("\n\nEvaluacion Finalizada \n -------- \n ");
    if ( argc == 2 )
        fclose(fileIn);
}
void initializeTS()  //Agregar Palabras Reservadas
{
    addToTS("inicio",'P');
    addToTS("fin",'P');
    addToTS("leer",'P');
    addToTS("escribir",'P');
}
void addToTS(char cadena[TAM_CADENA], int atributo)
{
    if(!isInTS(cadena))
    {
        strcpy(TS[pointerTS].cadena,cadena);
        TS[pointerTS].atributo = atributo;
        pointerTS++;
    }
}
int isInTS(char cadena[TAM_CADENA])
{
    int counter = 0;
    while(TS[counter].atributo == 'P' ||TS[counter].atributo == 'I')
    {
        if(strcmp(TS[counter].cadena, cadena)==0)
            return 1;
        counter++;
    }
    return 0; //not in table
}
void printTS()
{
    printf("\n\n -------------- TS -----------------\n");
    int counter = 0;
    while(TS[counter].atributo == 'P' ||TS[counter].atributo == 'I')
    {
        printf("Cadena: %s, Atributo: %c \n",TS[counter].cadena,TS[counter].atributo);
        counter++;
    }
    printf("\n\n -----------------------------------");
}
void yyerror(char* s)
{
    printf("%s\n", s);
}
int yywrap()
{
    return 1;
}
