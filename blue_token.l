%{
	#include <string.h>
    #include <stdlib.h>
    #include "blue_parser.tab.h"

    void invalid_token();
    void extern yyerror(char*);
%}


%%

"'"                                             { return SINGLE_QUOTES; }
"var"											{ return VARIABLE; }
"array"                                         { return ARRAY; }
"function"                                      { return FUNCTION; }
"if"                                            { return IF; }
"then"                                          { return THEN; }
"else"                                          { return ELSE; }
"while"                                         { return WHILE; }
":"												{ return COLON; }
"="          									{ return EQUALS; }
";"          									{ return SEMICOLON; }
","                                             { return COMMA; }
"=="                                            { return EQUAL_TO; }
"!="                                            { return NOT_EQUAL_TO; }
"<"                                             { return LESS_THAN; }
">"                                             { return GREATER_THAN; }
"<="                                            { return LESS_THAN_OR_EQUAL_TO; }
">="                                            { return GREATER_THAN_OR_EQUAL_TO; }
"+"                                             { return PLUS; }
"-"                                             { return MINUS; }
"*"                                             { return MULTIPLICATION; }
"/"                                             { return DIVIDE; }
"("                                             { return OPEN_BRACKET; }
")"                                             { return CLOSE_BRACKET; }
"{"                                             { return OPEN_CURLY_BRACE; }
"}"                                             { return CLOSE_CURLY_BRACE; }
"["                                             { return OPEN_SQUARE_BRACKET; }
"]"                                             { return CLOSE_SQUARE_BRACKET; }

"int"    |
"float"  |
"char"                                          { yylval.data_type = strdup(yytext);   return DATA_TYPE; }

[-+]?[0-9]+                                     { yylval.int_type = atoi(yytext);  return INTEGER_TYPE; }
[-+]?[0-9]*\.?[0-9]+                            { yylval.float_type = atof(yytext); return FLOAT_TYPE; }
[\'][a-zA-Z][\']                                { yylval.char_type = yytext[1];    return CHARACTER_TYPE; }
[a-zA-Z][_a-zA-Z0-9]*                           { yylval.data_type = strdup(yytext); return IDENTIFIER; }
[a-zA-Z][_a-zA-Z0-9]*(\[[0-9]+\])+              { yylval.str_type = strdup(yytext); return ARRAY_IDENTIFIER; }
\"(\\.|[^"])*\"                                 { yylval.str_type = strdup(yytext); return STRING_TYPE; }
 
\n                                              { yylineno++; }
[ \t\r\v\f]                                     ;
.                                               { invalid_token(); }

%%

int yywrap(void){
    return 1;
}

void yyerror(char *s) {
    fprintf(stderr, "\nError Found On Line Number %d : \n %s\n", yylineno, s);
    exit(0);
}

void invalid_token(){
    printf("\nError Found On Line Number %d : \n Token is Invalid %s\n", yylineno, yytext);
    exit(0);
}
