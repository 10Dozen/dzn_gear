#include "defines.h"
/*
    Return structured array of gear (kit) of given box/vehicle
    EXAMPLE: BOX call dzn_fnc_gear_getCargoGear;
    INPUT:
        0: OBJECT - Box or vehicle
    OUTPUT: ARRAY (kitArray), Copied to clipboard kit
*/


DBG_ "Params: %1", _this EOL;

private _kit = [];
private _cargo = [getWeaponCargo _this, getMagazineCargo _this, getItemCargo _this, getBackpackCargo _this];

private ["_classnames", "_count", "_categoryKit"];
{
    _classnames = _x select 0;
    _count = _x select 1;
    _categoryKit = [];
    {
        _categoryKit = _categoryKit + [ [_x, (_count select _forEachIndex)] ];
    } forEach _classnames;

    _kit pushBack _categoryKit;
} forEach _cargo;

_kit