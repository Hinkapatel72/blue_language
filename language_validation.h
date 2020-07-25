#include <stdlib.h>
#include <string.h>

#include "blue_parser.tab.h"

extern int strcmp(const char*, const char*); 

char Data_Type[50];   

int identifier_count = 0; 

struct structure_identifier
{
    char*   value;
    char*   data_type;
}identifiers[20];

extern int yylineno;




//check the present datatype
int check_valid_datatype(char* present_datatype)
{
    int i=0;

    if(strcmp(present_datatype, Data_Type) != 0)
    {
        return 0;
    }
    return 1;
}

//convert integer number to ASCII 
char* int_to_ascii(int number)
{
  static char buffer[33];
  snprintf(buffer, sizeof(buffer), "%d", number);
  return buffer;
}


//convert float number to ASCII
char* float_to_ascii(float number)
{
  static char buffer[33];
  snprintf(buffer, sizeof(buffer), "%f", number);
  return buffer;
}


//convert character to ASCII 
char* char_to_ascii(char number)
{
  static char buffer[33];
  snprintf(buffer, sizeof(buffer), "%c", number);
  return buffer;
}



void store_datatype(char* data_type)
{
    int i=0;
    while(data_type[i] != '\0')
    {
        Data_Type[i] = data_type[i];
        i++;
    }
}


void clear_stored_datatype()
{
    int i=0;
    while(Data_Type[i] != '\0')
    {
        Data_Type[i] = '\0';
        i++;
    }
}


char* redeem_datatype()
{
    return Data_Type;
}


int check_duplicate_datatype(char* identifier,char* identifier_data_type)
{
    int i;
    for(i=0;i<identifier_count;i++)
    {
        if(strcmp(identifier,identifiers[i].value) == 0)
        {
            return 1;
        }
    }
    return 0;
}


void identifier_encountered_duplicate(char* identifier)
{
    printf("\nError Found On Line Number %d : \nDuplicate Identifier '%s' \n",yylineno, identifier);
    exit(0);
}


void cache_identifier(char* identifier, char* identifier_data_type)
{
    identifiers[identifier_count].value = identifier;
    identifiers[identifier_count].data_type = identifier_data_type;
    identifier_count++;
}


char* identifier_retrieved(char* array_identifier){
    char retrieved_identifier[50];
    static char issued[50];

    int i=0;

    while(array_identifier[i] != '['){
        retrieved_identifier[i] = array_identifier[i];
        i++;
    }
    retrieved_identifier[i] = '\0';

    i=0;
    while(retrieved_identifier[i] != '\0'){
        issued[i] = retrieved_identifier[i];
        i++;
    }
    issued[i] = '\0';
    return issued;
    
}


void assignment_error(char* data_type){
    printf("\nError Found On Line Number %d : \nInvalid Assignment! Expected '%s', However Found %s \n",yylineno, Data_Type, data_type);
    exit(0);
}



