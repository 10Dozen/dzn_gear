#include "defines.h"

params ["_kit", "_name"];
private _str = _name + " = ["
    + NEWLINE_AND_TAB + (_kit joinString ("," + NEWLINE_AND_TAB))
    + NEWLINE + "];";

_str
