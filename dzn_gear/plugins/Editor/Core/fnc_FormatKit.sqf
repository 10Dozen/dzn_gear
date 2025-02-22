#include "defines.h"

params ["_kit", "_name", ["_isPersonal", false]];

DBG_ "Params: %1", _this EOL;

private _str = _name + " = ["
    + NEWLINE_AND_TAB + (_kit joinString ("," + NEWLINE_AND_TAB))
    + NEWLINE + (["];", "] call dzn_fnc_gear_make;"] select _isPersonal);

_str
