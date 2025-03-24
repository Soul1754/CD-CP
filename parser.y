%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *msg);
int yylex();
%}

/* Define union for different value types */
%union {
    int ival;
    char* sval;
}

/* Token definitions with types */
%token IF ELSE SWITCH CASE DEFAULT BREAK LBRACE RBRACE LPAREN RPAREN EQ ASSIGN SEMICOLON COLON
%token <ival> NUMBER
%token <sval> IDENTIFIER

%%

program:
    statement_list
    ;

statement_list:
    statement_list statement
    | statement
    ;

statement:
    if_statement
    | switch_statement
    | assignment_statement
    | SEMICOLON    /* Allow empty statements */
    ;

assignment_statement:
    IDENTIFIER ASSIGN NUMBER SEMICOLON
    ;

if_statement:
    IF LPAREN condition RPAREN LBRACE statement_list RBRACE
    | IF LPAREN condition RPAREN LBRACE statement_list RBRACE ELSE LBRACE statement_list RBRACE
    ;

switch_statement:
    SWITCH LPAREN IDENTIFIER RPAREN LBRACE case_list RBRACE
    ;

case_list:
    case_statements default_statement
    | case_statements
    | default_statement
    ;

case_statements:
    case_statements case_statement
    | case_statement
    ;

case_statement:
    CASE NUMBER COLON statement_list BREAK SEMICOLON
    ;

default_statement:
    DEFAULT COLON statement_list BREAK SEMICOLON
    ;

condition:
    IDENTIFIER EQ NUMBER
    | IDENTIFIER    /* Allow just identifier as condition */
    ;

%%

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
}

int main() {
    printf("Enter C code for conditional or switch-case statements:\n");
    yyparse();
    printf("Parsing completed successfully!\n");
    return 0;
}