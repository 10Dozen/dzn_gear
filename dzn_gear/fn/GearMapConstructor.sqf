#include "defines.h"
/*
    Converts gear array to Gear Map object.

    Params:
    _this (ARRAY) -

    Returns:
    _kitObject
*/

// -- Set defaults to weapon that might missing in kit array
private _emptyWeapon = dzn_gear_emptyWeaponDescriptor;
_self set [MAP_CAT_PRIMARY, _emptyWeapon];
_self set [MAP_CAT_LAUNCHER, _emptyWeapon];
_self set [MAP_CAT_HANDGUN, _emptyWeapon];

{
    private _category = toUpperANSI ((_x # 0) trim ["<> ", 0]);
    DBG_ "Category: %1", _category EOL;

    if (_category == ARR_CAT_EQUIPMENT) then {
        _self set [MAP_CAT_UNIFORM, _x # 1];
        _self set [MAP_CAT_VEST, _x # 2];
        _self set [MAP_CAT_BACKPACK, _x # 3];
        _self set [MAP_CAT_HEADGEAR, _x # 4];
        _self set [MAP_CAT_FACEWEAR, _x # 5];
        continue;
    };

    // -- Weapons
    if (_category in [ARR_CAT_PRIMARY, ARR_CAT_LAUNCHER, ARR_CAT_HANDGUN]) then {
        private _wpnCategory = [
            [MAP_CAT_HANDGUN, MAP_CAT_LAUNCHER] select (_category == ARR_CAT_LAUNCHER),
            MAP_CAT_PRIMARY
        ] select (_category == ARR_CAT_PRIMARY);

        DBG_ "WpnCat: %1", _wpnCategory EOL;

        // Randomized:               [[_cls, _mag, _att], [_cls, _mag, _att] ]
        // Single weapon:            _cls, _mag, _att
        // Single randmoized weapon: [_cls, _cls], [_mag, _mag], _attr

        private ["_weaponPreset"];
        if (count _x == 2) then {
            // Randomized weapon preset: [[...], [...]]
            DBG_ "Randomzmied weapon :: _x: %1", _x EOL;
            _weaponPreset = (_x # 1) apply {
                createHashMapFromArray [
                    [I_WEAPON_CLASS, _x # 0],
                    [I_WEAPON_MAG, _x # 1],
                    [I_WEAPON_ATTACHES, _x # 2]
                ]
            };
        } else {
            // Single weapon descriptor: "class", "mag", "attaches[]"
            DBG_ "Single weapon :: _x: %1", _x EOL;
            _weaponPreset = createHashMapFromArray [
                [I_WEAPON_CLASS, _x # 1],
                [I_WEAPON_MAG, _x # 2],
                [I_WEAPON_ATTACHES, _x # 3]
            ];
        };
        DBG_ "_weaponPreset: %1", _weaponPreset EOL;
        _self set [_wpnCategory, _weaponPreset];
        continue;
    };

    // -- Assigned items
    if (_category == ARR_CAT_ASSIGNED) then {
        _self set [MAP_CAT_ASSIGNED, _x select [1,10]];
        continue;
    };

    // -- Identity
    if (_category == ARR_CAT_INDENTITY) then {
        _self set [MAP_CAT_INDENTITY, _x select [1,3]];
        continue;
    };

    // -- Tags
    if (_category == ARR_CAT_TAGS) then {
        _self set [MAP_CAT_TAGS, _x select [1,25]];
        continue;
    };

    // -- Uniform textures
    if (_category == ARR_CAT_UNIFORM_TEXTURES) then {
        _self set [MAP_CAT_UNIFORM_TEXTURES, _x select [1, 20]];
        continue;
    };

    // -- Script
    if (_category == ARR_CAT_SCRIPT) then {
        _self set [MAP_CAT_SCRIPT, _x select [1,20]];
        continue;
    };

    // -- Description
    if (_category == ARR_CAT_DESC) then {
        _self set [MAP_CAT_DESC, _x select 1];
        continue;
    };

    // -- Container items
    _self set [
        [
            [MAP_CAT_BACKPACK_ITEMS, MAP_CAT_VEST_ITEMS] select (_category == ARR_CAT_VEST_ITEMS),
            MAP_CAT_UNIFORM_ITEMS
        ] select (_category == ARR_CAT_UNIFORM_ITEMS),
        _x # 1
    ];
} forEach _this;
