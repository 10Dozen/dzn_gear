#include "defines.h"

/*
    Applies gear to unit.
    Backward compatibility version - convert to new format and execute actual function

    Params:
    0: _unit (OBJECT) - unit to apply gear
    1: _gear (ARRAY) - gear
*/

[
    _unit,
    _gear call dzn_fnc_gear_make
] call dzn_fnc_gear_assignGear;
