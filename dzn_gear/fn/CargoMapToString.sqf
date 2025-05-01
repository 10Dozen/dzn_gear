#include "defines.h"

/*
    Returns string description of the Gear map:

    PrimaryWeapon: [_class, _mag, _attaches]
    ...
    Uniform: ...
    Items: ...

*/
DBG("Invoked");
private _str = ["Cargo"];

private _desc = _self get MAP_CARGO_DESC;
if (_desc != "") then {
    _str pushBack _desc;
};

private _tags = _self get MAP_CARGO_TAGS;
if (_tags isNotEqualTo []) then {
    _str pushBack format ["Tags: %1", _tags joinString ", "];
};
_str pushBack "------";

// -- Weapon -- [1x WeaponClass] or [1-2x WeaponClass2 or 3 other]
private ["_items", "_count", "_class", "_line"];
_line = [];
{
    if (_forEachIndex > 3) exitWith {
        _line pushBack format ["and %1 more", count _items];
    };
    _count = [_x # 1, format ["%1x", _x # 1]] select ((_x # 1) isEqualType 0);
    _class = if (_x # 0 isEqualType "") then {
        _x # 0
    } else {
        // -- Detailed signature or randomized weapon
        if (_x # 0 isEqualTypeParams CARGO_DETAILED_WEAPON_SIGNATURE) then {
            // -- Detailed weapon descriptor
            if (_x # 0 # 0 isEqualType []) then {
                // -- Randomized weapon in detailed weapons sign
                format ["%1 or %2 other (detailed)", _x # 0 # 0 # 0, count (_x # 0 # 0) - 1]
            } else {
                // -- Plain weapon
                format ["%1 (detailed)", _x # 0 # 0, count (_x # 0)]
            }
        } else {
            // -- Randomized weapon
            format ["%1 or %2 other", _x # 0 # 0, count (_x # 0) - 1]
        }
    };
    _line pushBack format ["%1 %2", _count, _class];
} forEach (_self get MAP_CARGO_WEAPONS);
_str pushBack format ["%1: %2", MAP_CARGO_WEAPONS, _line joinString ", "];


// -- Other stuff --- [1x Classname] or [1-2x Classnem2 or 3 more]
{
    _items = _self getOrDefault [_x, []];
    if (_item isEqualTo []) then { continue };

    _line = [];
    {
        if (_forEachIndex > 3) exitWith {
            _line pushBack format ["and %1 more", (count _items) - 3];
        };
        _count = [_x # 1, format ["%1x", _x # 1]] select ((_x # 1) isEqualType 0);
        _class = if (_x # 0 isEqualType "") then {
            _x # 0
        } else {
            format ["%1 or %2 other", _x # 0 # 0, count (_x # 0) - 1]
        };
        _line pushBack format ["%1 %2", _count, _class];
    } forEach _items;

    _str pushBack format ["%1: %2", _x, _line joinString ", "];
} forEach [
    MAP_CARGO_MAGAZINES,
    MAP_CARGO_ITEMS,
    MAP_CARGO_BACKPACKS
];

// -- Extra fields
_str pushBack "------";
private _textures = _self get MAP_CARGO_TEXTURES;
if (_textures isNotEqualTo []) then {
    _str pushBack format [
        "Re-textures selections: %1",
        _textures apply { _x # 0 } joinString ", "
    ];
};

private _scripts = _self get MAP_CARGO_SCRIPT;
if (_scripts isNotEqualTo []) then {
    _str pushBack format ["Has %1 attached scripts!", count _scripts];
};

DBG_1("Str Out: %1", _str);
(_str joinString "\n")
