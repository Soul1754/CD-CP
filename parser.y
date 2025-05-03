%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;

void yyerror(const char *msg);
int yylex();

// Symbol Table Structure
// Update Symbol Table Structure to include value and data type
struct symbol {
    char *name;
    int type;      // data type (int, float, etc.)
    int scope;
    int value;     // to store integer values
    char *dtype;   // string representation of data type
    struct symbol *next;
};

// AST Node Structure
struct ast_node {
    char *type;
    char *value;
    struct ast_node *left;
    struct ast_node *right;
};

// Global variables
struct symbol *symbol_table = NULL;
int current_scope = 0;

// Function declarations
struct symbol* lookup_symbol(char *name, int scope);
void insert_symbol(char *name, int type, int scope);
void update_symbol_value(char *name, int scope, int value);
void print_symbol_table();
struct ast_node* create_ast_node(char *type, char *value);
void print_ast(struct ast_node *node, int level);
%}

%union {
    int ival;
    char* sval;
    struct ast_node* ast;
}
%token IF ELSE WHILE SWITCH CASE DEFAULT BREAK TYPE EQ RETURN
%token LBRACE RBRACE LPAREN RPAREN ASSIGN SEMICOLON COLON
%token LT GT LE GE NE
%token <ival> NUMBER
%token <sval> IDENTIFIER

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

/* Add AST node types */
%type <ast> program function_definition compound_statement statement_list
%type <ast> statement if_statement switch_statement case_list
%type <ast> case_statements case_statement default_statement condition
%type <ast> declaration_statement assignment_statement

%%

program:
    function_definition
    {
        print_ast($1, 0);
        $$ = $1;
    }
    ;

function_definition:
    TYPE IDENTIFIER LPAREN RPAREN compound_statement
    {
        $$ = create_ast_node("FUNCTION", $2);
        $$->left = create_ast_node("TYPE", "");
        $$->right = $5;
        insert_symbol($2, 0, current_scope);
    }
    ;

compound_statement:
    LBRACE { current_scope++; } statement_list RBRACE { current_scope--; }
    {
        $$ = create_ast_node("COMPOUND", NULL);
        $$->left = $3;
    }
    ;

statement_list:
    statement_list statement
    {
        $$ = create_ast_node("STMT_LIST", NULL);
        $$->left = $1;
        $$->right = $2;
    }
    | /* empty */ { $$ = NULL; }
    ;

statement:
    compound_statement { $$ = $1; }
    | if_statement { $$ = $1; }
    | switch_statement { $$ = $1; }
    | assignment_statement { $$ = $1; }
    | declaration_statement { $$ = $1; }
    | RETURN NUMBER SEMICOLON { $$ = create_ast_node("RETURN", NULL); $$->left = create_ast_node("NUMBER", NULL); $$->left->value = malloc(12); sprintf($$->left->value, "%d", $2); }
    | RETURN SEMICOLON { $$ = create_ast_node("RETURN", NULL); }
    | SEMICOLON { $$ = NULL; }
    ;

declaration_statement:
    TYPE IDENTIFIER SEMICOLON
    {
        // Only check for redeclaration in the current scope
        struct symbol *tmp = symbol_table;
        int redeclared = 0;
        while (tmp) {
            if (strcmp(tmp->name, $2) == 0 && tmp->scope == current_scope) {
                redeclared = 1;
                break;
            }
            tmp = tmp->next;
        }
        if (redeclared) {
            yyerror("Variable already declared");
        } else {
            printf("decl:int\nid:%s\n", $2);
            insert_symbol($2, 0, current_scope);
            $$ = create_ast_node("DECL", $2);
        }
    }
    ;

assignment_statement:
    IDENTIFIER ASSIGN NUMBER SEMICOLON
    {
        // Find the variable in the current scope or any parent scope
        struct symbol *s = lookup_symbol($1, current_scope);
        if (!s) {
            yyerror("Undefined variable");
        } else {
            update_symbol_value($1, s->scope, $3);
            printf("id:%s\nassignop:=\nnum:%d\n", $1, $3);
            $$ = create_ast_node("ASSIGN", $1);
            $$->left = create_ast_node("NUMBER", NULL);
            $$->left->value = malloc(12);
            sprintf($$->left->value, "%d", $3);
        }
    }
    ;

if_statement:
    IF LPAREN condition RPAREN statement %prec LOWER_THAN_ELSE
    {
        printf("if\n");
        $$ = create_ast_node("IF", NULL);
        $$->left = $3;
        $$->right = $5;
    }
    | IF LPAREN condition RPAREN statement ELSE statement
    {
        printf("if-else\n");
        $$ = create_ast_node("IF_ELSE", NULL);
        $$->left = $3;
        struct ast_node *then_else = create_ast_node("THEN_ELSE", NULL);
        then_else->left = $5;
        then_else->right = $7;
        $$->right = then_else;
    }
    ;

switch_statement:
    SWITCH LPAREN IDENTIFIER RPAREN LBRACE { current_scope++; } case_list RBRACE { current_scope--; }
    {
        // Look up the variable in the parent scope since we're checking from inside the switch
        struct symbol *s = lookup_symbol($3, current_scope);
        if (!s) {
            yyerror("Undefined variable in switch statement");
        } else {
            $$ = create_ast_node("SWITCH", $3);
            $$->left = $7;
        }
    }
    ;

case_list:
    case_statements default_statement
    {
        $$ = create_ast_node("CASE_LIST", NULL);
        $$->left = $1;
        $$->right = $2;
    }
    | case_statements { $$ = $1; }
    | default_statement { $$ = $1; }
    ;

case_statements:
    case_statements case_statement
    {
        $$ = create_ast_node("CASES", NULL);
        $$->left = $1;
        $$->right = $2;
    }
    | case_statement { $$ = $1; }
    ;

case_statement:
    CASE NUMBER COLON { current_scope++; } statement_list BREAK SEMICOLON { current_scope--; }
    {
        $$ = create_ast_node("CASE", NULL);
        $$->value = malloc(12);
        sprintf($$->value, "%d", $2);
        $$->left = $5;
    }
    ;

default_statement:
    DEFAULT COLON { current_scope++; } statement_list BREAK SEMICOLON { current_scope--; }
    {
        $$ = create_ast_node("DEFAULT", NULL);
        $$->left = $4;
    }
    ;

condition:
    IDENTIFIER EQ NUMBER
    {
        struct symbol *s = lookup_symbol($1, current_scope);
        if (!s) {
            yyerror("Undefined variable in condition");
        }
        $$ = create_ast_node("COND_EQ", $1);
        $$->left = create_ast_node("NUMBER", NULL);
        $$->left->value = malloc(12);
        sprintf($$->left->value, "%d", $3);
    }
    | IDENTIFIER LT NUMBER
    {
        struct symbol *s = lookup_symbol($1, current_scope);
        if (!s) {
            yyerror("Undefined variable in condition");
        }
        $$ = create_ast_node("COND_LT", $1);
        $$->left = create_ast_node("NUMBER", NULL);
        $$->left->value = malloc(12);
        sprintf($$->left->value, "%d", $3);
    }
    | IDENTIFIER GT NUMBER
    {
        struct symbol *s = lookup_symbol($1, current_scope);
        if (!s) {
            yyerror("Undefined variable in condition");
        }
        $$ = create_ast_node("COND_GT", $1);
        $$->left = create_ast_node("NUMBER", NULL);
        $$->left->value = malloc(12);
        sprintf($$->left->value, "%d", $3);
    }
    | IDENTIFIER LE NUMBER
    {
        struct symbol *s = lookup_symbol($1, current_scope);
        if (!s) {
            yyerror("Undefined variable in condition");
        }
        $$ = create_ast_node("COND_LE", $1);
        $$->left = create_ast_node("NUMBER", NULL);
        $$->left->value = malloc(12);
        sprintf($$->left->value, "%d", $3);
    }
    | IDENTIFIER GE NUMBER
    {
        struct symbol *s = lookup_symbol($1, current_scope);
        if (!s) {
            yyerror("Undefined variable in condition");
        }
        $$ = create_ast_node("COND_GE", $1);
        $$->left = create_ast_node("NUMBER", NULL);
        $$->left->value = malloc(12);
        sprintf($$->left->value, "%d", $3);
    }
    | IDENTIFIER NE NUMBER
    {
        struct symbol *s = lookup_symbol($1, current_scope);
        if (!s) {
            yyerror("Undefined variable in condition");
        }
        $$ = create_ast_node("COND_NE", $1);
        $$->left = create_ast_node("NUMBER", NULL);
        $$->left->value = malloc(12);
        sprintf($$->left->value, "%d", $3);
    }
    ;

%%

struct symbol* lookup_symbol(char *name, int scope) {
    struct symbol *s = symbol_table;
    int max_scope = -1;
    struct symbol *result = NULL;
    
    // First, try to find in current scope or any parent scope
    while (s) {
        if (strcmp(s->name, name) == 0 && s->scope <= scope && s->scope > max_scope) {
            result = s;
            max_scope = s->scope;
        }
        s = s->next;
    }
    
    return result;
}

void insert_symbol(char *name, int type, int scope) {
    struct symbol *s = malloc(sizeof(struct symbol));
    s->name = strdup(name);
    s->type = type;
    s->scope = scope;
    s->value = 0;  // Default value
    
    // Set data type string
    if (type == 0) {
        s->dtype = strdup("int");
    } else if (type == 1) {
        s->dtype = strdup("float");
    } else {
        s->dtype = strdup("unknown");
    }
    
    s->next = symbol_table;
    symbol_table = s;
}

void update_symbol_value(char *name, int scope, int value) {
    struct symbol *s = lookup_symbol(name, scope);
    if (s) {
        s->value = value;
    }
}

void print_symbol_table() {
    printf("\n---------------\n\n");
    printf("Symbol Table\n");
    printf("%-15s %-15s %-15s %-15s\n", "Symbol", "Scope", "dtype", "Value");
    
    struct symbol *s = symbol_table;
    while (s) {
        printf("%-15s %-15d %-15s %-15d\n", s->name, s->scope, s->dtype, s->value);
        s = s->next;
    }
}

struct ast_node* create_ast_node(char *type, char *value) {
    struct ast_node *node = malloc(sizeof(struct ast_node));
    node->type = strdup(type);
    node->value = value ? strdup(value) : NULL;
    node->left = NULL;
    node->right = NULL;
    return node;
}

void print_ast(struct ast_node *node, int level) {
    if (!node) return;
    for (int i = 0; i < level; i++) printf("  ");
    printf("%s", node->type);
    if (node->value) printf(" (%s)", node->value);
    printf("\n");
    print_ast(node->left, level + 1);
    print_ast(node->right, level + 1);
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
}

int main() {
    FILE *file = fopen("test.c", "r");
    if (!file) {
        perror("Failed to open test.c");
        return 1;
    }
    extern FILE *yyin;
    yyin = file;
    yyparse();
    fclose(file);
    print_symbol_table();
    printf("Parsing completed successfully!\n");
    return 0;
}