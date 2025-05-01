#include "defines.h"
/*
    Return structured array of gear (kit) of given box/vehicle
    EXAMPLE: BOX call dzn_fnc_gear_getCargoGear;
    INPUT:
        0: OBJECT - Box or vehicle
    OUTPUT: ARRAY (kitArray), Copied to clipboard kit
*/

DBG_1("Params: %1", _this);

private _kit = [];

private ["_categoryName", "_classnames", "_counts", "_categoryCargo"];
{
    _category   = _x # 0;
    _classnames = _x # 1 # 0;
    _counts     = _x # 1 # 1;

    _categoryCargo = [];
    {
        _categoryCargo pushBack [_x, _counts select _forEachIndex];
    } forEach _classnames;
    _kit pushBack [_category, _categoryCargo];
} forEach [
    [EXPORT_CAT_WEAPONS, getWeaponCargo _this],
    [EXPORT_CAT_MAGAZINES,getMagazineCargo _this],
    [EXPORT_CAT_ITEMS, getItemCargo _this],
    [EXPORT_CAT_BACKPACKS, getBackpackCargo _this]
];

_kit
