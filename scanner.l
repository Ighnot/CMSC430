/* 
 John Leckie, CMSC430, Mar '24
 This file contains flex input file originally provided in skele code 
 Original adjustments made for Project 1

*/



%{

#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

 /* Definition of names. */

ws			[ \a\b\f\r\t\v]+
comment		(\-\-.*\n)|(\/\/.*\n)  
line		[\n]
id		[A-Za-z]([A-Za-z0-9]*(_{1,2}[A-Za-z0-9]+)*)?
digit		[0-9]
int		{digit}+
hex_digit	[0-9A-Fa-f]
hex_int		#{hex_digit}+		
char		\'([^'\\]|\\['"?\\abfnrtv0])\'
punc		[\(\),:;]
real		[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?

%%

 /* Definition of patterns. */

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"<"|">"|">="|"<="|"="|"<>"	{ ECHO; return(RELOP); }
"+"|"-"		{ ECHO; return(ADDOP); }
"*"|"/"		{ ECHO; return(MULOP); }
"~"			{ ECHO; return(NEGOP); } 
"=>"		{ ECHO; return(ARROW); }
"^" 	 	{ ECHO; return(EXPOP); }
"&"			{ ECHO; return(ANDOP); }
"|"			{ ECHO; return(OROP); }
"!" 		{ ECHO; return(NOTOP); }
"%"			{ ECHO; return(REMOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
else		{ ECHO; return(ELSE); }
elsif		{ ECHO; return(ELSIF); }
end			{ ECHO; return(END); }
endcase		{ ECHO; return(ENDCASE); }
endfold		{ ECHO; return(ENDFOLD); }
endif		{ ECHO; return(ENDIF); }
endswitch	{ ECHO; return(ENDSWITCH); }
endreduce	{ ECHO; return(ENDREDUCE); }
fold		{ ECHO; return(FOLD); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
if			{ ECHO; return(IF); }
is			{ ECHO; return(IS); }
left		{ ECHO; return(LEFT); }
list		{ ECHO; return(LIST); }
of			{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
right		{ ECHO; return(RIGHT); }
switch		{ ECHO; return(SWITCH); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); } 
true|false	{ ECHO; return(BOOL_LITERAL); }
{hex_int}	{ ECHO; yylval.type = INT_TYPE; return(HEX_LITERAL); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{char}		{ ECHO; yylval.type = CHAR_TYPE; return(CHAR_LITERAL); }
{int}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{real}		{ ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.			{ ECHO; appendError(LEXICAL, yytext); }

%%

/*	NOTE-- commented out after Project 1
int main()
{
	firstLine();
	
	FILE *file = fopen("lexemes.txt", "wa"); 
	int token = yylex();
	while (token)
	{
		fprintf(file, "%d %s\n", token, yytext);
		token = yylex();
	}
	lastLine();
	fclose(file);
	return 0;
}
*/
