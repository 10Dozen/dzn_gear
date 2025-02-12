#include "defines.h"

params ["_unit"];

private _kit = _unit getVariable ["dzn_gear", _self call [F(resolve), [_unit]];];
if (_kit isEqualTo "") exitWith {};

[_unit, _kit] call dzn_fnc_gear_assignKit;
