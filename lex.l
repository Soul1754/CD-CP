%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern int current_scope;
%}

%%
"int"           { printf("TYPE token\n"); return TYPE; }
"void"          { printf("TYPE token\n"); return TYPE; }  /* Add void as a TYPE */
"if"            { printf("IF token\n"); return IF; }
"else"          { printf("ELSE token\n"); return ELSE; }
"switch"        { printf("SWITCH token\n"); return SWITCH; }
"case"          { printf("CASE token\n"); return CASE; }
"default"       { printf("DEFAULT token\n"); return DEFAULT; }
"break"         { printf("BREAK token\n"); return BREAK; }
"=="            { printf("EQ token\n"); return EQ; }
"="             { printf("ASSIGN token\n"); return ASSIGN; }
"{"             { printf("LBRACE token\n"); return LBRACE; }
"}"             { printf("RBRACE token\n"); return RBRACE; }
"("             { printf("LPAREN token\n"); return LPAREN; }
")"             { printf("RPAREN token\n"); return RPAREN; }
";"             { printf("SEMICOLON token\n"); return SEMICOLON; }
":"             { printf("COLON token\n"); return COLON; }
[0-9]+          { printf("NUMBER token: %d\n", atoi(yytext)); yylval.ival = atoi(yytext); return NUMBER; }
"return"        { printf("RETURN token\n"); return RETURN; }
[a-zA-Z][a-zA-Z0-9_]*  { printf("IDENTIFIER token: %s\n", yytext); yylval.sval = strdup(yytext); return IDENTIFIER; }
"<"            { printf("LT token\n"); return LT; }
">"            { printf("GT token\n"); return GT; }
"<="           { printf("LE token\n"); return LE; }
">="           { printf("GE token\n"); return GE; }
"!="           { printf("NE token\n"); return NE; }
[ \t\n]+        { /* ignore whitespace */ }
.               { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
