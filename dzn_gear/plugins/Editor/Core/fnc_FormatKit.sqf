#include "defines.h"

params ["_kit", "_name", ["_isPersonal", false]];

DBG_1("Params: %1", _this);

private _str = _name + " = ["
    + NEWLINE_AND_TAB + (_kit joinString ("," + NEWLINE_AND_TAB))
    + NEWLINE + "] call dzn_fnc_gear_make;";

_str
