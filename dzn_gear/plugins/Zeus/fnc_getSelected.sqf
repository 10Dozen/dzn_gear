
#include "defines.h"
/*
    Returns units/vehicles currently select by Zeus

    Returns: (ARRAY)
    0: _units (ARRAY)
    1: _crew (ARRAY)
    2: _vics (ARRAY)
*/

DBG_ "Params: %1", _this EOL;

params [
    ["_includeUnits", true],
    ["_includeCrew", true],
    ["_includeVics", true]
];

DBG_ "_includeUnits: %1", _includeUnits EOL;
DBG_ "_includeCrew: %1", _includeCrew EOL;
DBG_ "_includeVics: %1", _includeVics EOL;

private _selectedUnits = curatorSelected select 0;

private _units = [];
private _crew = [];
private _vics = [];
{
    if (_x isKindOf "CAManBase") then {
        _units pushBack _x;
        continue;
    };

    _vics pushBack _x;
    _crew append (crew _x);
} forEach _selectedUnits;

[
    [[], _units] select _includeUnits,
    [[], _crew] select _includeCrew,
    [[], _vics] select _includeVics
]