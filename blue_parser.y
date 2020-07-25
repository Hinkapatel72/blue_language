%{
	#include <stdio.h> 
  #include <stdbool.h>    
	#include <stdlib.h>

  #define TRUE 1
  #define FALSE 0

	#include "language_validation.h"

	extern char Data_Type[50];

	extern void yyerror();
	extern int yylex();
	extern char* yytext;
	extern int yylineno;

	void store_datatype(char*);
	int check_duplicate_datatype(char*, char*);
	void cache_identifier(char*,char*);
	void identifier_encountered_duplicate(char*);
	char* redeem_datatype();
	void clear_stored_datatype();
	int check_valid_datatype(char*);
	void assignment_error(char*);
	char* identifier_retrieved(char[]);

 
  int array_identifier_count = 0;
  char retrieved_identifier[50][50];

%}
      

%define parse.lac full
%define parse.error verbose

%union {
  int int_type;
  char* data_type;
  char* str_type;
  float float_type;
  char char_type;
}

%token COLON    EQUALS    SEMICOLON    COMMA    SINGLE_QUOTES
%token VARIABLE    ARRAY    FUNCTION    
%token EQUAL_TO    NOT_EQUAL_TO    
%token LESS_THAN    GREATER_THAN    LESS_THAN_OR_EQUAL_TO    GREATER_THAN_OR_EQUAL_TO
%token PLUS    MINUS    MULTIPLICATION    DIVIDE
%token IF    THEN    ELSE    WHILE
%token OPEN_CURLY_BRACE    CLOSE_CURLY_BRACE    OPEN_SQUARE_BRACKET    CLOSE_SQUARE_BRACKET    OPEN_BRACKET    CLOSE_BRACKET

%token <char_type>  CHARACTER_TYPE
%token <int_type>   INTEGER_TYPE
%token <float_type> FLOAT_TYPE
%token <str_type> STRING_TYPE

%token <int_type> INT
%token <float_type> FLOAT
%token <str_type> STRING
%token <data_type> DATA_TYPE
%token <str_type> IDENTIFIER
%token <str_type> ARRAY_IDENTIFIER


%type <str_type> DECLARATION
%type <str_type> EXPRESSION
%type <str_type> FUNCTION_DECLARATION 
%type <str_type> IFELSE
%type <str_type> WHILECONDITION

%type <int_type> CONDITION
%type <int_type> STATEMENT

%%

DECLARATION : EXPRESSION  SEMICOLON                               { clear_stored_datatype(); }
            |   FUNCTION_DECLARATION SEMICOLON
            | DECLARATION EXPRESSION  SEMICOLON                   { clear_stored_datatype(); }
            | DECLARATION FUNCTION_DECLARATION SEMICOLON          { clear_stored_datatype(); }
            | DECLARATION IFELSE SEMICOLON                        { clear_stored_datatype(); }
            | DECLARATION WHILECONDITION SEMICOLON


            | error '>'                     {/* ' > ' stops execution all together */}
            ;

EXPRESSION  : VARIABLE COLON DATA_TYPE IDENTIFIER              {
                          if(!check_duplicate_datatype($4,redeem_datatype())){
                            cache_identifier($4,redeem_datatype());
                            store_datatype($3);
                          }else{
                            identifier_encountered_duplicate($4);
                          } 
                        }


            | EXPRESSION  EQUALS  NUMBER            {;}

            | EXPRESSION  COMMA IDENTIFIER          {
                        if(!check_duplicate_datatype($3,redeem_datatype())){
                          cache_identifier($3,redeem_datatype());
                        }else{
                          identifier_encountered_duplicate($3);
                        }
                      }

            | ARRAY COLON DATA_TYPE ARRAY_IDENTIFIER            {
                                    
                      strcpy(retrieved_identifier[array_identifier_count],identifier_retrieved($4));
                      if(!check_duplicate_datatype(retrieved_identifier[array_identifier_count],redeem_datatype())){
                        cache_identifier(retrieved_identifier[array_identifier_count],redeem_datatype());
                        store_datatype($3);
                      }else{
                        identifier_encountered_duplicate(retrieved_identifier[array_identifier_count]);
                      } 
                      array_identifier_count++;
                    }

            | EXPRESSION  EQUALS  OPEN_CURLY_BRACE  PARAMETER_LIST  CLOSE_CURLY_BRACE  

            | EXPRESSION COMMA ARRAY_IDENTIFIER             {
                      strcpy(retrieved_identifier[array_identifier_count],identifier_retrieved($3));
                      if(!check_duplicate_datatype(retrieved_identifier[array_identifier_count],redeem_datatype())){
                        cache_identifier(retrieved_identifier[array_identifier_count],redeem_datatype());
                      }else{
                        identifier_encountered_duplicate(retrieved_identifier[array_identifier_count]);
                      } 
                      array_identifier_count++;
                    }

            ;


NUMBER    : INTEGER_TYPE                 {if(!check_valid_datatype("int")){ assignment_error(int_to_ascii($1));}}
      | FLOAT_TYPE                   {if(!check_valid_datatype("float")){ assignment_error(float_to_ascii($1));}}
      | CHARACTER_TYPE                 {if(!check_valid_datatype("char")){ assignment_error(char_to_ascii($1));}   }
      | STRING_TYPE                  {if(!check_valid_datatype("char*")){ assignment_error($1);} }
      ;

CONDITION  :   STATEMENT {$$ = $1; }
          | STATEMENT GREATER_THAN STATEMENT {$$ = $1 > $3? 1: 0; } 
          | STATEMENT LESS_THAN STATEMENT {$$ = $1 < $3? 1: 0; }
          | STATEMENT GREATER_THAN_OR_EQUAL_TO STATEMENT {$$ = $1 >= $3? 1: 0; }
          | STATEMENT LESS_THAN_OR_EQUAL_TO STATEMENT {$$ = $1 <= $3? 1: 0; }
          | STATEMENT EQUAL_TO STATEMENT {$$ = $1 == $3? 1: 0; }
          | STATEMENT NOT_EQUAL_TO STATEMENT {$$ = $1 != $3? 1: 0; }
          ;


STATEMENT  :  INTEGER_TYPE {$$ = $1; }
          | STATEMENT PLUS STATEMENT {$$ = $1 + $3;}
          | STATEMENT MINUS STATEMENT {$$ = $1 - $3;}
          | STATEMENT MULTIPLICATION STATEMENT {$$ = $1 * $3;}
          | STATEMENT DIVIDE STATEMENT {$$ = $1 / $3;}
          ;


PARAMETER_LIST  : NUMBER
          | PARAMETER_LIST  COMMA   NUMBER
          |   NUMBER EQUALS NUMBER                        { yyerror("Two or more equal signs are not allowed in C");} 
      
          |   error '>'
        ;

FUNCTION_DECLARATION : FUNCTION IDENTIFIER OPEN_BRACKET DATA_TYPE_LIST CLOSE_BRACKET {
  
                          if(!check_duplicate_datatype($2,redeem_datatype())){
                            cache_identifier($2,redeem_datatype());
                          }else{
                            identifier_encountered_duplicate($2);
                          } 

                        }
          ;


IFELSE  :  IF OPEN_BRACKET CONDITION CLOSE_BRACKET THEN STATEMENT ELSE STATEMENT {
                   if($3) {
                      printf("IfElse Condition Encountered");
                   }
                   else {
                    printf("Incorrect Condition");
                   }
                   printf("\n");
                 }
         ;

WHILECONDITION  :  WHILE OPEN_BRACKET CONDITION CLOSE_BRACKET THEN STATEMENT {
               if ($3) {
                printf("While Condition Encountered");
               }
               else {
                printf("Incorrect Condition");
               }
               printf("\n");
              }
         ;


DATA_TYPE_LIST     : DATA_TYPE
            | DATA_TYPE_LIST  COMMA DATA_TYPE
            ;



%%                    

int main(){

  yyparse();
  printf("Successfully Run!!\n");
  return 0;
}