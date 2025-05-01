
#include "defines.h"
/*
    Returns units/vehicles currently select by Zeus

    Returns: (ARRAY)
    0: _units (ARRAY)
    1: _crew (ARRAY)
    2: _vics (ARRAY)
*/

DBG_1("Params: %1", _this);

params [
    ["_includeUnits", true],
    ["_includeCrew", true],
    ["_includeVics", true]
];

DBG_1("_includeUnits: %1", _includeUnits);
DBG_1("_includeCrew: %1", _includeCrew);
DBG_1("_includeVics: %1", _includeVics);

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
