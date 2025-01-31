#include "defines.h"

params ["_name", "_target"];

private _color = [
    "#", COLOR_POOL, COLOR_POOL, COLOR_POOL
    , COLOR_POOL, COLOR_POOL, COLOR_POOL
] joinString "";

if (_target isEqualTo player) exitWith {
	_self call [
        F(composeUnitKit),
        ["Player's", player call dzn_fnc_gear_getGear, _name, _color]
    ];
};

if (_target isKindOf "CAManBase") exitWith {
    _self call [
        F(composeUnitKit),
        ["Unit's", cursorTarget call dzn_fnc_gear_getGear, _name, _color]
    ];
};

_self call [
    F(composeCargoKit),
    ["Vehicle's", cursorTarget call dzn_fnc_gear_getCargoGear, _name, _color]
];