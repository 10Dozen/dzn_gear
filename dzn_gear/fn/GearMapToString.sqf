#include "defines.h"

/*
    Returns string description of the Gear map:

    PrimaryWeapon: [_class, _mag, _attaches]
    ...
    Uniform: ...
    Items: ...

*/

private _str = [];

private _desc = _self get MAP_GEAR_DESC;
if (_desc != "") then {
    _str pushBack _desc;
};

private _tags = _self get MAP_GEAR_TAGS;
if (_tags isNotEqualTo []) then {
    _str pushBack format ["Tags: %1", _tags joinString ", "];
};
_str pushBack "------";

private ["_item", "_weapon", "_attaches", "_postfix"];
{
    _item = _self get _x;
    if (_item isEqualTo dzn_gear_emptyWeaponDescriptor) then { continue; };

    _postfix = "";
    // -- Randomized weapon descriptor
    if (_item isEqualType []) then {
        _item = _item # 0;
        _postfix = format [" or %1 other presets", (count _item) - 1];
    };

    // -- Randomized weapon
    DBG_2("ItemType: %1, item: %2", typename _item, _item);
    _weapon = _item get I_WEAPON_CLASS;
    if (_weapon isEqualType []) then {
        _weapon = format ["%1 or %2 other variants", _weapon # 0, (count _weapon) - 1];
    };

    _attaches = (_item get I_WEAPON_ATTACHES) select { _x isEqualType [] || { _x != "" }};
    _str pushBack format [
        "%1: %2 %3%4",
        _x,
        _weapon,
        ["", "+ " + str(_attaches)] select (_attaches isNotEqualTo []),
        _postfix
    ];
} forEach [
    MAP_GEAR_PRIMARY,
    MAP_GEAR_LAUNCHER,
    MAP_GEAR_HANDGUN
];

{
    _item = _self getOrDefault [_x, ""];
    if (_item isEqualTo "") then { continue };
    if (_item isEqualType []) then {
        _item = format ["%1 or %2 other", _item # 0, (count _item) - 1];
    };
    _str pushBack format ["%1: %2", _x, _item];
} forEach [
    MAP_GEAR_UNIFORM,
    MAP_GEAR_VEST,
    MAP_GEAR_BACKPACK,
    MAP_GEAR_HEADGEAR,
    MAP_GEAR_FACEWEAR
];

_str pushBack format [
    "%1: %2",
    MAP_GEAR_ASSIGNED,
    (_self get MAP_GEAR_ASSIGNED) joinString ", "
];

private _identity = _self getOrDefault [MAP_GEAR_INDENTITY, []];
if (_identity isNotEqualTo []) then {
    _identity params ["_face", "_voice"];
    private _line = format [
        "(face) %1, (voice) %2",
        if (_face isEqualType "") then { _face } else {
            format ["%1 or %2 other", _face # 0, (count _face) - 1]
        },
        if (_voice isEqualType "") then { _voice } else {
            format ["%1 or %2 other", _voice # 0, (count _voice) - 1]
        }
    ];

    _str pushBack format ["%1: %2", MAP_GEAR_INDENTITY, _line];
};


_str pushBack "------";
private _textures = _self get MAP_GEAR_UNIFORM_TEXTURES;
if (_textures isNotEqualTo []) then {
    _str pushBack format [
        "Re-textures selections: %1",
        _textures apply { _x # 0 } joinString ", "
    ];
};

private _scripts = _self get MAP_GEAR_SCRIPT;
if (_scripts isNotEqualTo []) then {
    _str pushBack format ["Has %1 attached scripts!", count _scripts];
};

(_str joinString "\n")
