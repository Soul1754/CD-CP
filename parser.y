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
%token IF ELSE WHILE SWITCH CASE DEFAULT BREAK TYPE EQ
%token LBRACE RBRACE LPAREN RPAREN ASSIGN SEMICOLON COLON
%token <ival> NUMBER
%token <sval> IDENTIFIER

/* Precedence rules to resolve conflicts */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program:
    function_definition
    ;

function_definition:
    TYPE IDENTIFIER LPAREN RPAREN compound_statement
    | IDENTIFIER IDENTIFIER LPAREN RPAREN compound_statement
    ;

compound_statement:
    LBRACE statement_list RBRACE
    ;

statement_list:
    statement_list statement
    | /* empty */
    ;

statement:
    compound_statement
    | if_statement
    | switch_statement
    | assignment_statement
    | declaration_statement
    | SEMICOLON
    ;

declaration_statement:
    TYPE IDENTIFIER SEMICOLON
    | TYPE IDENTIFIER ASSIGN NUMBER SEMICOLON
    ;

assignment_statement:
    IDENTIFIER ASSIGN NUMBER SEMICOLON
    ;

if_statement:
    IF LPAREN condition RPAREN statement %prec LOWER_THAN_ELSE
    | IF LPAREN condition RPAREN statement ELSE statement
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
    | IDENTIFIER
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