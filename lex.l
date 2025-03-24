%{
#include "parser.tab.h"
%}

%%
"if"            { printf("IF token\n"); return IF; }
"else"          { printf("ELSE token\n"); return ELSE; }
"switch"        { printf("SWITCH token\n"); return SWITCH; }
"case"          { printf("CASE token\n"); return CASE; }
"default"       { printf("DEFAULT token\n"); return DEFAULT; }
"break"         { printf("BREAK token\n"); return BREAK; }
"{"             { printf("LBRACE token\n"); return LBRACE; }
"}"             { printf("RBRACE token\n"); return RBRACE; }
"("             { printf("LPAREN token\n"); return LPAREN; }
")"             { printf("RPAREN token\n"); return RPAREN; }
"=="            { printf("EQ token\n"); return EQ; }
"="             { printf("ASSIGN token\n"); return ASSIGN; }
";"             { printf("SEMICOLON token\n"); return SEMICOLON; }
":"             { printf("COLON token\n"); return COLON; }
[0-9]+          { printf("NUMBER token: %s\n", yytext); yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFIER token: %s\n", yytext); yylval.sval = strdup(yytext); return IDENTIFIER; }
[ \t\r\n]+     ; /* Ignore all whitespace */
.               { printf("Invalid character: %c\n", yytext[0]); }

%%

int yywrap() {
    return 1;
}
