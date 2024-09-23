/* 
 John Leckie, CMSC430, Mar '24
 Project 2 Parser 
 Supplied by class as skeleton code,
	Altered to facilitate Project 2, 3, 4 (Bison Piece)
*/

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

 /* For Bison */
int yylex();
void yyerror(const char* message);

 /* Functions used for additional validations and other things. */
Types find(Symbols<Types>& table, CharPtr identifier, string tableName);
void checkInsert(Symbols<Types>& table, CharPtr identifier, string tableName, Types type);

Symbols<Types> scalars; /* Symbol table that will contain all the datatypes of the simple variables. */
Symbols<Types> lists; /* Symbol table that will contain all the datatypes of the list variables. */
%}

%define parse.error verbose

%union {
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER

%token <type> INT_LITERAL CHAR_LITERAL REAL_LITERAL HEX_LITERAL

%token BOOL_LITERAL

%token ADDOP MULOP ANDOP RELOP NEGOP EXPOP OROP NOTOP REMOP ARROW

%token BEGIN_ BOOLEAN CASE CHARACTER ELSE ELSIF END ENDCASE ENDFOLD ENDIF ENDREDUCE ENDSWITCH
	FOLD FUNCTION IF INTEGER IS LEFT LIST OF OTHERS REAL REDUCE RETURNS RIGHT SWITCH THEN WHEN

%type <type> list expressions body type statement_ statement list_choice elsifs elsif cases case_ case
	expression term exponentiation minus primary function_header_ function_header
%%

function:	
	function_header_ optional_variable body {checkAssignment($1, $3, "Function Return");} ;

function_header_:	
	function_header ';' |
	error ';' {$$ = MISMATCH;} ;

function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type {$$ = $5;} ;

type:
	INTEGER {$$ = INT_TYPE;} |
	REAL {$$ = REAL_TYPE;} |
	CHARACTER {$$ = CHAR_TYPE; };
	
optional_variable:
	variables |
	%empty ;

variables:
	variables variable_ | 
	variable_ ;

variable_:	
	variable ';' |
	error ';' ;
    
variable:	
	IDENTIFIER ':' type IS statement {checkAssignment($3, $5, "Variable Initialization"); checkInsert(scalars, $1, "Scalar", $3);} |
	IDENTIFIER ':' LIST OF type IS list {checkListDecl($5, $7); checkInsert(lists, $1, "List", $5);} ;

list:
	'(' expressions ')' {$$ = $2;} ;
	
optional_parameters:
	parameters |
	%empty ;

parameters:
	parameters ',' parameter | 
	parameter ;
    
parameter:	
	IDENTIFIER ':' type ;

expressions:
	expressions ',' expression {$$ = checkItemsList($1, $3);} | 
	expression ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression {$$ = checkWhen($4, $6);} |
	SWITCH expression IS cases OTHERS ARROW statement_ ENDSWITCH {$$ = checkSwitch($2, $4, $7);} |
	IF condition THEN statement_ elsifs ELSE statement_ ENDIF {$$ = checkIf($4, checkIf($5, $7));} |
	FOLD direction operator list_choice ENDFOLD {$$ = checkFold($4);} ;

direction:
	LEFT |
	RIGHT ;

operator:
	ADDOP |
	MULOP ;

list_choice:
	list |
	IDENTIFIER {$$ = find(lists, $1, "List");} ;

elsifs:
	elsifs elsif {$$ = checkIf($1, $2);} |
	%empty {$$ = NONE;} ;
	
elsif:
	ELSIF condition THEN statement_ {$$ = $4;} ;

cases:
	cases case_ {$$ = checkCases($1, $2);} |
	%empty {$$ = NONE;} ;

case_:	
	case ';' |
	error ';' {$$ = MISMATCH;} ;
	
case:
	CASE INT_LITERAL ARROW statement {$$ = $4;} ; 

condition:
	condition OROP logical |
	logical ; 

logical:
	logical ANDOP negation |
	negation ;

negation:
	NOTOP relation |
	relation ;

relation:
	'(' condition ')' |
	expression RELOP expression {checkRelational($1, $3);} ;

expression:
	expression ADDOP term {$$ = checkArithmetic($1, $3);} |
	term ;
      
term:
	term MULOP exponentiation {$$ = checkArithmetic($1, $3);} |
	term REMOP exponentiation {$$ = checkRemainder($1, $3);} |
	exponentiation ;

exponentiation:
	minus EXPOP exponentiation {$$ = checkOtherArithmetic($1, $3);} |
	minus ;

minus:
	NEGOP primary {$$ = checkOtherArithmetic($2, $2);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	HEX_LITERAL |
	REAL_LITERAL |
	CHAR_LITERAL |
	IDENTIFIER '(' expression ')' {checkListIndex($3); $$ = find(lists, $1, "List");} |
	IDENTIFIER {$$ = find(scalars, $1, "Scalar");} ;

%%

/***********************************************
*
* @Purpose: Sets the error message when a syntax error occurs.
* @Parameters: in: message = string value containing the error message.
* @Return: ----.
*
************************************************/
void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

/***********************************************
*
* @Purpose: Find the datatype of a variable (scalar or list).
* @Parameters: in: table = Symbol table that will contain the data type of the variable.
*              in: identifier = string value containing the name of the variable.
*              in: tableName = string value containing the symbol table information (Scalar or List).
* @Return: datatype value if the variable has been found, MISMATCH otherwise.
*
************************************************/
Types find(Symbols<Types>& table, CharPtr identifier, string tableName) {
	Types type;
	if (!table.find(identifier, type)) {
		appendError(UNDECLARED, tableName + " " + identifier);
		return MISMATCH;
	}
	return type;
}

/***********************************************
*
* @Purpose: Checks if a variable (scalar or list) has already been declared. If not, the variable is inserted.
* @Parameters: in: table = Symbol table that will contain the data type of the variable.
*              in: identifier = string value containing the name of the variable.
*              in: tableName = string value containing the symbol table information (Scalar or List).
*              in: type = enum value that contains the data type of the variable.
* @Return: -NA-.
*
************************************************/
void checkInsert(Symbols<Types>& table, CharPtr identifier, string tableName, Types type) {
	Types aux;
	if (!table.find(identifier, aux)) {
		table.insert(identifier, type);
	} else {
		appendError(DUPLICATE_IDENTIFIER, tableName + " " + identifier);
	}
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
}
