

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>

#define HASH_TABLE_SIZE 100

struct sym_t
{
	char* lexeme;
	double value;
	int data_type;
	int lineno;
	struct sym_t* successor;
};

typedef struct sym_t sym_t;

sym_t** create_table()
{
	sym_t** h_ptr = NULL; 

	if( ( h_ptr = malloc( sizeof( sym_t* ) * HASH_TABLE_SIZE ) ) == NULL )
    	return NULL;

	int i;

	// Intitialise all entries as NULL
    for( i = 0; i < HASH_TABLE_SIZE; i++ )
	{
		h_ptr[i] = NULL;
	}

	return h_ptr;
}

uint32_t hash( char *lexeme )
{
	size_t i;
	uint32_t hash;


	for ( hash = i = 0; i < strlen(lexeme); ++i ) {
        hash += lexeme[i];
        hash += ( hash << 10 );
        hash ^= ( hash >> 6 );
    }
	hash += ( hash << 3 );
	hash ^= ( hash >> 11 );
    hash += ( hash << 15 );

	return hash % HASH_TABLE_SIZE; 
}

sym_t *create_entry( char *lexeme, int value,int lineno,int d_type )
{
	sym_t *newentry;

	if( ( newentry = malloc( sizeof( sym_t ) ) ) == NULL ) {
		return NULL;
	}
	if( ( newentry->lexeme = strdup( lexeme ) ) == NULL ) {
		return NULL;
	}

	newentry->value = value;
	newentry->data_type = d_type;
	newentry->lineno = lineno;
	newentry->successor = NULL;

	return newentry;
}

sym_t* search( sym_t** h_ptr, char* lexeme )
{
	uint32_t idx = 0;
	sym_t* myentry;

	idx = hash( lexeme );

	myentry = h_ptr[idx];

	while( myentry != NULL && strcmp( lexeme, myentry->lexeme ) != 0 )
	{
		myentry = myentry->successor;
	}

	if(myentry == NULL) 
		return NULL;

	else 
		return myentry;

}

sym_t* insert( sym_t** h_ptr, char* lexeme,int d_type, int value,int lineno )
{
	sym_t* finder = search( h_ptr, lexeme );
	if( finder != NULL) 
	    return finder ;

	uint32_t idx;
	sym_t* newentry = NULL;
	sym_t* head = NULL;

	idx = hash( lexeme ); 
	newentry = create_entry( lexeme, value,lineno,d_type); 

	if(newentry == NULL) 
	{
		printf("Insert failed. New entry could not be created.");
		exit(1);
	}

	head = h_ptr[idx]; 

	if(head == NULL) 
	{
		h_ptr[idx] = newentry;
	}
	else 
	{
		newentry->successor = h_ptr[idx];
		h_ptr[idx] = newentry;
	}
	return h_ptr[idx];
}

void display(sym_t** h_ptr)
{
	int i;
	sym_t* iter;
    printf("\n\n");
    printf(" %-20s %-20s %-20s %-20s\n","lexeme","value","data-type","Line no.");
    printf("\n");

	for( i=0; i < HASH_TABLE_SIZE; i++)
	{
		iter = h_ptr[i];

		while( iter != NULL)
		{
			printf(" %-20s %-20d %-20d %-20d\n", iter->lexeme, (int)iter->value, iter->data_type,iter->lineno);
			iter = iter->successor;
		}
	}
    printf("\n");

}