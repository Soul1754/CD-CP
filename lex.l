%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

#define MAX_SYMBOLS 100
#define INIT 9999999

// Symbol Table Structure
struct sym_table {
    char name[20];
    char value[50];
    int line_number[10];
    int count;
    int scope_level;
    char dtype[20];
    int var_value;
} table[100];

int line_number = 1;
int sym_table_length = 0;
int curr_value;
int scope_level = 0;
int dtype = 0;
int declaration = 0;
char curr_dtype[20];
char curr_identifier[20];

void insert_symbol(const char* name);
void remove_scope_symbols();
void updateValue(int val, char* identifier);
%}

%option noyywrap

DIGIT   [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*

%%
"if"            { printf("IF token\n"); return IF; }
"else"          { printf("ELSE token\n"); return ELSE; }
"switch"        { printf("SWITCH token\n"); return SWITCH; }
"case"          { printf("CASE token\n"); return CASE; }
"default"       { printf("DEFAULT token\n"); return DEFAULT; }
`"break"         { printf("BREAK token\n"); return BREAK; }
"void"|"int"|"float"|"char" { printf("TYPE token\n"); dtype=1; strcpy(curr_dtype,yytext); return TYPE; }

{ID}            { 
    printf("IDENTIFIER token: %s\n", yytext);
    if(dtype==1) {
        declaration=1;
    } else {
        dtype=0;
        declaration=0;
    }
    insert_symbol(yytext);
    strcpy(curr_identifier,yytext);
    yylval.sval = strdup(yytext);
    return IDENTIFIER; 
}
{DIGIT}+        { 
    printf("NUMBER token: %s\n", yytext);
    curr_value = atoi(yytext);
    if(declaration==1) {
        updateValue(curr_value, curr_identifier);
    }
    yylval.ival = atoi(yytext);
    return NUMBER; 
}
"{"             { printf("LBRACE token\n"); scope_level++; return LBRACE; }
"}"             { printf("RBRACE token\n"); remove_scope_symbols(); scope_level--; return RBRACE; }
"("             { printf("LPAREN token\n"); return LPAREN; }
")"             { printf("RPAREN token\n"); return RPAREN; }
"=="            { printf("EQ token\n"); return EQ; }
"="             { printf("ASSIGN token\n"); return ASSIGN; }
":"             { printf("COLON token\n"); return COLON; }
";"             { printf("SEMICOLON token\n"); return SEMICOLON; }
[ \t\r\n]+     { if(yytext[0] == '\n') line_number++; }
.               { printf("Invalid character: %c\n", yytext[0]); }

%%

void insert_symbol(const char* name) {
    for(int i = 0; i < sym_table_length; i++) {
        if(strcmp(table[i].value, name) == 0 && table[i].scope_level == scope_level) {
            return;
        }
    }
    if(sym_table_length < MAX_SYMBOLS) {
        strcpy(table[sym_table_length].name, "IDENTIFIER");
        strcpy(table[sym_table_length].value, name);
        table[sym_table_length].line_number[0] = line_number;
        table[sym_table_length].count = 1;
        table[sym_table_length].scope_level = scope_level;
        strcpy(table[sym_table_length].dtype, curr_dtype);
        table[sym_table_length].var_value = INIT;
        sym_table_length++;
    }
}

void remove_scope_symbols() {
    for(int i = sym_table_length - 1; i >= 0; i--) {
        if(table[i].scope_level == scope_level) {
            sym_table_length--;
        } else {
            break;
        }
    }
}

void updateValue(int val, char* identifier) {
    for(int i = 0; i < sym_table_length; i++) {
        if(strcmp(table[i].value, identifier) == 0 && table[i].scope_level == scope_level) {
            table[i].var_value = val;
            return;
        }
    }
    printf("Error: Undefined variable %s at line %d\n", identifier, line_number);
}

// Remove the main function from here since it's in parser.y
