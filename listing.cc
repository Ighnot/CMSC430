/* 
// John Leckie, CMSC430, Mar '24
// This file contains the bodies of the functions that produces the 
// compilation listing

// Altered from skeleton code for Project 1 to facilitate Project 2

*/

#include <cstdio>
#include <string>
#include <queue> 

using namespace std;

#include "listing.h"

static int lineNumber;
static queue<string> errorQueue;
// {[0]lexical, [1]syntactical, [2]semantic} array for error tracking
static int totalErrors[] = {0, 0, 0}; 
static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ", lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ", lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	int total = totalErrors[0] + totalErrors[1] + totalErrors[2];

	if (total > 0) 
	{
		printf("Lexical Errors: %d\n", totalErrors[0]);
		printf("Syntax Errors: %d\n", totalErrors[1]);
		printf("Semantic Errors: %d\n", totalErrors[2]);
	}
	else
	{
		printf("Compiled Successfully\n\n");
	}
	
	return total;
}

void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = {"ERROR: Lexical-- Invalid Character ", "",
						 "ERROR: Semantic-- ", "Duplicate Identifier- ",
						 "ERROR: Semantic-- Undeclared "};

	errorQueue.push(messages[errorCategory] + message);
	totalErrors[(errorCategory > GENERAL_SEMANTIC) ? GENERAL_SEMANTIC : errorCategory]++;
}

void displayErrors()
{

	while (!errorQueue.empty())
	{
		printf("%s\n", errorQueue.front().c_str());
		errorQueue.pop();
	}
}
