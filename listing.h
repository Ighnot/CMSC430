// John Leckie, CMSC430, Mar '24

// This file contains the function prototypes for the functions that produce
// the compilation listing

// No alterations made

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);
