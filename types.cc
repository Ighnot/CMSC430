/* CMSC 430 Compiler Theory and Design
Project 4 Skeleton
UMGC CITE
Summer 2023
John Leckie, CMSC430, Mar '24
This file contains the bodies of the type checking functions, altered to facilitate Project 4
*/
#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message) { /* Function that determines the datatype of a initialization of variable or a return function */
	if (lValue != MISMATCH && rValue != MISMATCH) {
		if (lValue != REAL_TYPE || rValue != INT_TYPE) {
			if (lValue == INT_TYPE && rValue == REAL_TYPE) {
				appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
			} else if (lValue != rValue) {
				appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
			}
		}
	}
}

Types checkWhen(Types true_, Types false_) { /* Function that determines the datatype of a "when" statement. */
	if (true_ == MISMATCH || false_ == MISMATCH)
		return MISMATCH;
	if (true_ != false_)
		appendError(GENERAL_SEMANTIC, "When Types Mismatch");
	return true_;
}

Types checkSwitch(Types case_, Types when, Types other) { /* Function that determines the datatype of a "switch" statement. */
	if (case_ != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "Switch Expression Not Integer");
	return checkCases(when, other);
}

Types checkCases(Types left, Types right) { /* Function that determines the datatype of a "case" pair. */
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == NONE || left == right)
		return right;
	appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
	return MISMATCH;
}

Types checkArithmetic(Types left, Types right) { /* Function that determines the datatype of the result of an arithmetic operation (+, -, *, /). */
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	if ((left == REAL_TYPE || left == INT_TYPE) && (right == REAL_TYPE || right == INT_TYPE))
		return REAL_TYPE;
	appendError(GENERAL_SEMANTIC, "Integer Type Required");
	return MISMATCH;
}

Types checkItemsList(Types left, Types right) { /* Function that determines the datatype of a pair of elements that belong to a list. */
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == right)
		return left;
	appendError(GENERAL_SEMANTIC, "List Element Types Do Not Match");
	return MISMATCH;
}

void checkListDecl(Types lValue, Types rValue) { /* Function that determines the datatype of a list and its elements. */
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "List Type Does Not Match Element Types");
}

void checkListIndex(Types lstIndex) { /* Function that determines the datatype of a subscript of a list. */
	if (lstIndex != MISMATCH && lstIndex != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "List Subscript Must Be Integer");
}

void checkRelational(Types lValue, Types rValue) { /* Function that determines the datatype of the result of an relational operation (<, <=, >, >=, =, <>). */
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue && (lValue == CHAR_TYPE || rValue == CHAR_TYPE))
		appendError(GENERAL_SEMANTIC, "Character Literals Cannot be Compared to Numeric Expressions");
}

Types checkOtherArithmetic(Types left, Types right) { /* Function that determines the datatype of the result of an arithmetic operation (^, ~). */
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	if ((left == REAL_TYPE || left == INT_TYPE) && (right == REAL_TYPE || right == INT_TYPE))
		return REAL_TYPE;
	appendError(GENERAL_SEMANTIC, "Arithmetic Operator Requires Numeric Types");
	return MISMATCH;
}

Types checkRemainder(Types left, Types right) { /* Function that determines the datatype of the result of an remainder operation (%). */
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
	return MISMATCH;
}

Types checkIf(Types left, Types right) { /* Function that determines the datatype of a "if" statement. */
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == NONE || left == right)
		return right;
	appendError(GENERAL_SEMANTIC, "If-Elsif-Else Type Mismatch");
	return MISMATCH;
}

Types checkFold(Types list) { /* Function that determines the datatype of a "fold" statement. */
	if (list == MISMATCH)
		return MISMATCH;
	if (list == INT_TYPE || list == REAL_TYPE)
		return list;
	appendError(GENERAL_SEMANTIC, "Fold Requires A Numeric List");
	return MISMATCH;
}
