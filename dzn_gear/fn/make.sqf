#include "defines.h"

/*
    Creates Gear Map from Gear Array

    Params:
    _this (ARRAY) - gear array
*/
DBG_ "Params: %1", _this EOL;

private _personalCategories = [
    ARR_GEAR_EQUIPMENT,
    ARR_GEAR_PRIMARY,
    ARR_GEAR_LAUNCHER,
    ARR_GEAR_HANDGUN,
    ARR_GEAR_UNIFORM_ITEMS,
    ARR_GEAR_VEST_ITEMS,
    ARR_GEAR_BACKPACK_ITEMS,
    ARR_GEAR_ASSIGNED,
    ARR_GEAR_INDENTITY,
    ARR_GEAR_UNIFORM_TEXTURES
];
/*

[
    [   [["arifle_MX_ACO_pointer_F","hgun_P07_F"],3]  ],
    [],
    [[["FirstAidKit", "ACE_rope6"],4]],
    [],
    [[["arifle_MX_GL_F", "muzzle_snds_H", "", "optic_aco", ["30Rnd_65x39_caseless_mag", 15], ["3Rnd_HE_Grenade_shell", 2], ""], 2]]
] call dzn_fnc_gear_make;

*/

if (
    _this findIf {
        // Look for ["CategoryName", [...]] format
        (_x # 0) isEqualType "" &&
        // And check thath "CategoryName" has personal kit categories
        { toUpperANSI (_x # 0) trim ["<> ", 0] in _personalCategories }
    } > -1
) exitWith {
    // -- Personal kit
    DBG_ "Personal kit" EOL;
    private _gearMap = createHashMapObject [
        dzn_gear_gearMapDeclaration,
        _this
    ];
    (_gearMap)
};

DBG_ "Cargo kit" EOL;
private _cargoMap = createHashMapObject [
    dzn_gear_cargoMapDeclaration,
    _this
];
DBG_ "Cargo map: %1", _cargoMap EOL;
(_cargoMap)
