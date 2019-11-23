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
        int atributo; //'P' si es PR, 'I' si es I
        int valor;
    };

    struct registroTS TS[32];
    int pointerTS = 0;
    int contadorLineas = 1;

//funciones:
    void initializeTS();
    void addToTS(char [], int ,int);
    int isInTS(char []);
    void printTS();
    int buscarEnTabla(char []);
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
IDENTIFICADOR ASIGNACION expresion {contadorLineas++;$$=$1; addToTS($$,'I',$3);}
|LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO {contadorLineas++;int num=0;printf("Ingrese la variable:");scanf("%d",&num);actualizarTS($3,'I',num);}
| ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO {contadorLineas++;printf("VALOR IMPRESO EN PANTALLA: %d\n",$3);}
;
listaIdentificadores :
IDENTIFICADOR {addToTS($$,'I',0);}
| listaIdentificadores COMA IDENTIFICADOR {addToTS($3,'I',0);}
;
listaExpresiones :
expresion
| listaExpresiones COMA expresion
;
expresion :
primaria {$$=$1;}
| expresion SUMA primaria {$$=$1 + $3;}
| expresion RESTA primaria {$$=$1 - $3;}
;
primaria :
IDENTIFICADOR {$$=buscarEnTabla($1);addToTS($1,'I',$$);}
| CONSTANTE {$$=atoi($1);}
| PARENIZQUIERDO expresion PARENDERECHO {$$=$2;}
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
    for(int i=0;i<32;i++){
        strcpy(TS[i].cadena,"");
        TS[i].atributo = 0;
        TS[i].valor = 0;
    }
    addToTS("inicio",'P',0);
    addToTS("fin",'P',0);
    addToTS("leer",'P',0);
    addToTS("escribir",'P',0);
}
void addToTS(char cadena[TAM_CADENA], int atributo, int valor)
{
    if(!isInTS(cadena))
    {
        strcpy(TS[pointerTS].cadena,cadena);
        TS[pointerTS].atributo = atributo;
        TS[pointerTS].valor = valor;
        pointerTS++;
    }
}

void actualizarTS(char cadena[TAM_CADENA], int atributo, int valor){
    for(int i=0;i<pointerTS;i++){
        if(strcmp(TS[i].cadena, cadena)==0){
            TS[i].valor=valor;
        }
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

int buscarEnTabla(char* cadena){
    for(int counter = 0;counter<32;counter++)
    {
        if(strcmp(TS[counter].cadena,"")!=0){
            if(strcmp(TS[counter].cadena, cadena)==0){
                return TS[counter].valor;
            }
        }
    }
    return 0; //not in table
}
void printTS()
{
    printf("\n\n -------------- TS -----------------\n");
    int counter = 0;
    for(int counter = 0;counter<32;counter++)
    {
        printf("Cadena: %s, Atributo: %c, Valor: %d \n",TS[counter].cadena,TS[counter].atributo,TS[counter].valor);
    }
    printf("\n\n -----------------------------------");
}
void yyerror(char* s)
{
    printf("%s en la linea %d\n", s, contadorLineas);
}
int yywrap()
{
    return 1;
}
