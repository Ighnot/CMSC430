/* CMSC 430 Compiler Theory and Design
// Project 4 Skeleton
// UMGC CITE
// Summer 2023
// John Leckie, CMSC430, Mar '24
// This file contains type definitions and the function
// prototypes for the type checking functions
*/
typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, REAL_TYPE, CHAR_TYPE, NONE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkWhen(Types true_, Types false_);
Types checkSwitch(Types case_, Types when, Types other);
Types checkCases(Types left, Types right);
Types checkArithmetic(Types left, Types right);
Types checkItemsList(Types left, Types right);
void checkListDecl(Types lValue, Types rValue);
void checkListIndex(Types lstIndex);
void checkRelational(Types lValue, Types rValue);
Types checkOtherArithmetic(Types left, Types right);
Types checkRemainder(Types left, Types right);
Types checkIf(Types left, Types right);
Types checkFold(Types list);

