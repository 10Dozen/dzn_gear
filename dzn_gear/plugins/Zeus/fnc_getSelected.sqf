
#include "defines.h"
/*
	Returns units/vehicles currently select by Zeus

	Returns: (ARRAY)
	0: _units (ARRAY)
	1: _crew (ARRAY)
	2: _vics (ARRAY)
*/

params [
	["_includeUnits", true],
	["_includeCrew", true],
	["_includeVics", true]
];


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