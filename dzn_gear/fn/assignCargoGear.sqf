#include "defines.h"
/*
    Change gear of given box or vehicle with given gear set
    EXAMPLE: [ @Unit, @GearSet ] spawn dzn_fnc_gear_assignCargoGear;
    INPUT:
        0: OBJECT - Vehicle or box for which gear will be set
        1: ARRAY - Set of gear
    OUTPUT: NULL
*/
params ["_container", "_gear"];

if (_gear isEqualType []) exitWith {
    [
        _container,
        _gear call dzn_fnc_gear_make
    ] call dzn_fnc_gear_assignCargoGear;
};

DBG_ "Params: %1", _this EOL;

// Clear boxes
clearWeaponCargoGlobal _container;
clearMagazineCargoGlobal _container;
clearBackpackCargoGlobal _container;
clearItemCargoGlobal _container;

#define GET_RANDOM_ITEM(ITEM) (selectRandom ([[ITEM], ITEM] select ((ITEM) isEqualType [])))

// "x2-5" -> 2 + floor random 4 (5+1-2) => 2 + 0...3 => 2...5
#define RESOLVE_COUNT(COUNT) \
    if (COUNT isEqualType "") then { \
        private _limits = ((COUNT trim ["x ", 0]) splitString "-") apply { parseNumber _x }; \
        COUNT = (_limits select 0) + floor random ((_limits select 1) - (_limits select 0) + 1); \
    }

// Add weapons
{
    _x params ["_item", "_count"];
    RESOLVE_COUNT(_count);


    if (_item isEqualTypeParams CARGO_DETAILED_WEAPON_SIGNATURE) then {
        // [["Cl1", "muzzle", "optics", "pointer", ["mag", 30], [], "bipod"], 4]

        _item params ["_w", "_mzl", "_fl", "_op", "_mag1", "_mag2", "_bpd"];
        _mag1 params [["_magCls", ""]];
        // -- Wpn and mag
        if (_w isEqualType []) then {
            private _r = round random (count _w - 1);
            _item set [0, _w # _r];
            if (_magCls isEqualType []) then {
                _mag1 set [0, _mag1 # _r];
            };
        };
        if (_magCls isEqualType []) then {
            _mag1 set [0, GET_RANDOM_ITEM(_magCls)];
        };

        // -- Attaches
        _item set [1, GET_RANDOM_ITEM(_item # 1)];
        _item set [2, GET_RANDOM_ITEM(_item # 2)];
        _item set [3, GET_RANDOM_ITEM(_item # 3)];
        _item set [6, GET_RANDOM_ITEM(_item # 6)];

        _container addWeaponWithAttachmentsCargoGlobal [_item, _count];
    } else {
        // ["Classname", 4]
        // [["Cls1", "Cls2"], 4]

        _container addWeaponCargoGlobal [GET_RANDOM_ITEM(_item), _count];
    };
} forEach (_gear get MAP_CARGO_WEAPONS);

// Add Magazines
{
    _x params ["_item", "_count"];
    RESOLVE_COUNT(_count);
    _container addMagazineCargoGlobal [GET_RANDOM_ITEM(_item), _count];
} forEach (_gear get MAP_CARGO_MAGAZINES);

// Add Items
{
    _x params ["_item", "_count"];
    RESOLVE_COUNT(_count);
    _container addItemCargoGlobal [GET_RANDOM_ITEM(_item), _count];
} forEach (_gear get MAP_CARGO_ITEMS);

// Add Backpacks
{
    _x params ["_item", "_count"];
    RESOLVE_COUNT(_count);
    _container addBackpackCargoGlobal [GET_RANDOM_ITEM(_item), _count];
} forEach (_gear get MAP_CARGO_BACKPACKS);

// -- EXTRA FIELDS
// -- TAGS
{
    private _varArr = [_x, true, true];
    if (_x isEqualType []) then {
        _varArr = [_x # 0, _x # 1, true];
    };
    DBG_ "Tag: _valArr = %1", _varArr EOL;
    _container setVariable _varArr;
} forEach (_gear getOrDefault [MAP_CARGO_TAGS, []]);

// -- Textures
{
    _x params ["_selection", "_tex", "_mat"];
    // -- Select random index from 2 arrays
    if (_tex isEqualType []) then {
        private _r = round random (count _tex - 1);
        _tex = _tex # _r;
        if (_mat isEqualType []) then {
            _mat = _mat # _r;
        };
    };

    if (!isNil "_mat") then {
        _container setObjectMaterialGlobal [_selection, _mat];
    };
    if (!isNil "_tex") then {
        _container setObjectTextureGlobal [_selection, _tex];
    };
} forEach (_gear getOrDefault [MAP_CARGO_TEXTURES, []]);

// -- Script
{
    DBG_ "Script: _idx = %1, _script=%2", _forEachIndex, _x EOL;
    [_container, _gear] call _x;
} forEach (_gear getOrDefault [MAP_CARGO_SCRIPT, []]);

// -- Finalize
_container setVariable ["dzn_gear_done", true, true];
_container setVariable ["dzn_gear_items", _gear, true];
["dzn_gear_cargoApplied", [_container, _gear]] call CBA_fnc_localEvent;
