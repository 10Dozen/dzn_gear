#include "defines.h"

/*
    Returns string description of the Gear map:

    PrimaryWeapon: [_class, _mag, _attaches]
    ...
    Uniform: ...
    Items: ...

*/

private _str = [];

private ["_cat", "_postfix", "_attaches"];
{
    _cat = _self get _x;
    _postfix = "";
    if (_cat isEqualType []) then {
        _cat = _cat # 0;
        _postfix = format [" and %1 more", str(count _cat - 1)];
    };

    _attaches = (_cat get I_WEAPON_ATTACHES) select { _x isEqualType [] || { _x != "" }};
    _str pushBack format [
        "%1: %2 %3%4",
        _x,
        _cat get I_WEAPON_CLASS,
        ["", _attaches] select (_attaches isNotEqualTo []),
        _postfix
    ];
} forEach [
    MAP_CAT_PRIMARY,
    MAP_CAT_LAUNCHER,
    MAP_CAT_HANDGUN
];


{
    _str pushBack format ["%1: %2", _x, _self get _x];
} forEach [
    MAP_CAT_UNIFORM,
    MAP_CAT_VEST,
    MAP_CAT_BACKPACK,
    MAP_CAT_HEADGEAR,
    MAP_CAT_FACEWEAR,
    MAP_CAT_ASSIGNED,
    MAP_CAT_INDENTITY,
    MAP_CAT_TAGS,
    MAP_CAT_UNIFORM_TEXTURES
];

(_str joinString "\n")