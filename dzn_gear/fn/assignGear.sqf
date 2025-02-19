#include "defines.h"

/*
    Applies gear to unit.
    Also applies extras like TAG variables, script, uniform textures/mats

    Params:
    0: _unit (OBJECT) - unit to apply gear
    1: _gear (dzn_gear_GearMapInterface) - gear

*/

#define GET_RANDOM_ITEM(ITEM) (selectRandom ([[ITEM], ITEM] select ((ITEM) isEqualType [])))

DBG_ "Params: %1", _this EOL;

// [@Unit, @GearSet] spawn dzn_fnc_gear_assignGear;
params ["_unit", "_gear"];

if (_gear isEqualType []) exitWith {
    [_unit, _gear] call dzn_fnc_gear_assignGearArray;
};

_unit setVariable ["BIS_enableRandomization", false];
enableSentences false;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;
removeAllAssignedItems _unit;
removeAllWeapons _unit;

private _magClasses = [];

// -- ADD WEAPONS
private ["_category", "_weaponDescriptor", "_r", "_varArr", "_item", "_count"];

{
    _category = _x;
    _weaponDescriptor = _gear get _x;
    if (_weaponDescriptor isEqualType []) then {
        // -- Radnomized preset
        _weaponDescriptor = selectRandom _weaponDescriptor;
    };

    // -- Check for randomized weapon-mag combo
    private _weapon =_weaponDescriptor get I_WEAPON_CLASS;
    private _mag = _weaponDescriptor get I_WEAPON_MAG;
    private _attaches = _weaponDescriptor get I_WEAPON_ATTACHES;
    if (_weapon isEqualType []) then {
        _r = round random (count _weapon - 1);
        _weapon = _weapon # _r;
        // -- If array of mags - select with same idx
        //    otherwise use same mag for all options
        if (_mag isEqualType []) then {
            _mag = _mag # _r;
        };
    };

    // Save "PRIMARY MAG"-like template value
    _magClasses pushBack _mag;

    _unit addWeaponGlobal _weapon;
    {
        private _item = GET_RANDOM_ITEM(_x);
        DBG_ "Weapon Item (selected): %1", _item EOL;

        switch (_category) do {
            case MAP_CAT_PRIMARY: { _unit addPrimaryWeaponItem _item };
            case MAP_CAT_LAUNCHER: { _unit addSecondaryWeaponItem _item };
            case MAP_CAT_HANDGUN: { _unit addHandgunItem _item };
        };
    } forEach (_attaches + [_mag]);
} forEach [MAP_CAT_PRIMARY, MAP_CAT_LAUNCHER, MAP_CAT_HANDGUN];

_magClasses = createHashMapFromArray [
    ["PRIMARY MAG", _magClasses # 0],
    ["SECONDARY MAG", _magClasses # 1],
    ["HANDGUN MAG", _magClasses # 2]
];

// -- ADD EQUIP
_unit forceAddUniform GET_RANDOM_ITEM(_gear get MAP_CAT_UNIFORM);
_unit addVest GET_RANDOM_ITEM(_gear get MAP_CAT_VEST);
_unit addBackpackGlobal GET_RANDOM_ITEM(_gear get MAP_CAT_BACKPACK);
_unit addHeadgear GET_RANDOM_ITEM(_gear get MAP_CAT_HEADGEAR);
_unit addGoggles GET_RANDOM_ITEM(_gear get MAP_CAT_FACEWEAR);

// -- ADD ASSIGNED ITEMS
{
    _unit addWeapon (GET_RANDOM_ITEM(_x));
} forEach (_gear get MAP_CAT_ASSIGNED);

// -- ADD ITEMS TO UNIFORM, TO VEST, TO BACKPACK
{
    _category = _x;
    DBG_ "Adding %1", _category EOL;
    {
        _item = GET_RANDOM_ITEM(_x select 0);
        _item = _magClasses getOrDefault [_item, _item];
        _count = _x select 1;
        if (_count isEqualType "") then {
            // "x2-5" -> 2 + floor random 4 (5+1-2) => 2 + 0...3 => 2...5
            _limits = ((_count trim ["x ", 0]) splitString "-") apply { parseNumber _x };
            DBG_ "Limits: %1", _limits EOL;
            _count = (_limits # 0) + floor random ((_limits # 1) - (_limits # 0) + 1);
        };

        DBG_ "  - %1 x%2", _item, _count EOL;
        switch (_category) do {
            case MAP_CAT_UNIFORM_ITEMS: {
                DBG_ "Addint to uniform" EOL;
                for "_i" from 1 to _count do { _unit addItemToUniform _item; };
            };
            case MAP_CAT_VEST_ITEMS: {
                DBG_ "Addint to vest" EOL;
                for "_i" from 1 to _count do { _unit addItemToVest _item; };
            };
            case MAP_CAT_BACKPACK_ITEMS: {
                DBG_ "Addint to backpack" EOL;
                for "_i" from 1 to _count do { _unit addItemToBackpack _item; };
            };
        };
    } forEach (_gear get _category);
} forEach [
    MAP_CAT_UNIFORM_ITEMS,
    MAP_CAT_VEST_ITEMS,
    MAP_CAT_BACKPACK_ITEMS
];


// -- EXTRA FIELDS
// -- IDENTITY
private _identity = _gear getOrDefault [MAP_CAT_INDENTITY, []];
if (_identity isNotEqualTo []) then {
    [_unit, _identity] remoteExec ["dzn_fnc_gear_assignIdentity", 0];
};

// -- TAGS
{
    _varArr = [_x, true, true];
    if (_x isEqualType []) then {
        _varArr = [_x # 0, _x # 1, true];
    };
    DBG_ "Tag: _valArr = %1", _varArr EOL;
    _unit setVariable _varArr;
} forEach (_gear getOrDefault [MAP_CAT_TAGS, []]);

// -- Textures
private _texAndMats = _gear getOrDefault [MAP_CAT_UNIFORM_TEXTURES, []];
{
    // -- Apply texture
    _x params ["_selection", "_tex", "_mat"];

    if (_tex isEqualType []) then {
        _r = round random (count _tex - 1);
        _tex = _tex # _r;
        if (_mat isEqualType []) then {
            _mat = _mat # _r;
        };
    };

    if (!isNil "_tex") then {
        _unit setObjectTextureGlobal [_selection, _tex];
    };
    if (!isNil "_mat") then {
        _unit setObjectMaterialGlobal [_selection, _mat];
    };
} forEach _textAndMats;

// -- Script
{
    DBG_ "Script: _idx = %1, _script=%2", _forEachIndex, _x EOL;
    [_unit, _gear] call _x;
} forEach (_gear getOrDefault [MAP_CAT_SCRIPT, []]);

// -- Finalize
_unit setVariable ["dzn_gear_done", true, true];
["dzn_gear_kitApplied", [_unit, _gear]] call CBA_fnc_localEvent;
