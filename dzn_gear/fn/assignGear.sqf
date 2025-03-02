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
private ["_category", "_addItemExpr", "_weaponDescriptor", "_r", "_varArr", "_item", "_count"];

{
    _category = _x # 0;
    _addItemExpr = _x # 1;
    DBG_ "Adding weapon %1", _category EOL;
    _weaponDescriptor = _gear get _category;
    if (_weaponDescriptor isEqualType []) then {
        // -- Radnomized preset
        _weaponDescriptor = selectRandom _weaponDescriptor;
    };

    // -- Check for randomized weapon-mag combo
    private _weapon =_weaponDescriptor get I_WEAPON_CLASS;
    private _mag = _weaponDescriptor get I_WEAPON_MAG;
    private _attaches = _weaponDescriptor get I_WEAPON_ATTACHES;
    if (_weapon isEqualType []) then {
        // -- Select random index from 2 arrays
        _r = round random (count _weapon - 1);
        _weapon = _weapon # _r;
        // -- If array of mags - select with same idx
        //    otherwise use same mag for all options
        if (_mag isEqualType []) then {
            _mag = _mag # _r;
        };
    };
    _mag = GET_RANDOM_ITEM(_mag); // In case only mag randomization was used

    // Save "PRIMARY MAG"-like template value
    _magClasses pushBack _mag;

    _unit addWeaponGlobal _weapon;
    {
        private _item = GET_RANDOM_ITEM(_x);
        if (true) then _addItemExpr;
    } forEach (_attaches + [_mag]);
} forEach [
    [MAP_CAT_PRIMARY, { _unit addPrimaryWeaponItem _item }],
    [MAP_CAT_LAUNCHER, { _unit addSecondaryWeaponItem _item }],
    [MAP_CAT_HANDGUN, { _unit addSecondaryWeaponItem _item }]
];

_magClasses = createHashMapFromArray [
    [MAG_PRIMARY, _magClasses # 0],
    [MAG_LAUNCHER, _magClasses # 1],
    [MAG_HANDGUN, _magClasses # 2]
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
    _category = _x # 0;
    _addItemExpr = _x # 1;

    DBG_ "Adding %1", _category EOL;
    DBG_ " items %1", (_gear get _category) EOL;

    {
        _item = GET_RANDOM_ITEM(_x select 0);  // _x = [_itemClass, _count] or [[_itemCls1, _itemCLs2], _count]
        _item = _magClasses getOrDefault [_item, _item]; // Replace to PRIMARY MAG like if item is a favourite mag
        _count = _x select 1;
        if (_count isEqualType "") then {
            // "x2-5" -> 2 + floor random 4 (5+1-2) => 2 + 0...3 => 2...5
            _limits = ((_count trim ["x ", 0]) splitString "-") apply { parseNumber _x };
            _count = (_limits # 0) + floor random ((_limits # 1) - (_limits # 0) + 1);
            DBG_ "Limits: %1", _limits EOL;
        };

        DBG_ "  - %1 x%2", _item, _count EOL;
        for "_i" from 1 to _count do _addItemExpr;
    } forEach (_gear get _category);
} forEach [
    [MAP_CAT_UNIFORM_ITEMS, { _unit addItemToUniform _item; }],
    [MAP_CAT_VEST_ITEMS, { _unit addItemToVest _item; }],
    [MAP_CAT_BACKPACK_ITEMS, { _unit addItemToBackpack _item; }]
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
{
    _x params ["_selection", "_tex", "_mat"];
    // -- Select random index from 2 arrays
    if (_tex isEqualType []) then {
        _r = round random (count _tex - 1);
        _tex = _tex # _r;
        if (_mat isEqualType []) then {
            _mat = _mat # _r;
        };
    };

    if (!isNil "_mat") then {
        _unit setObjectMaterialGlobal [_selection, _mat];
    };
    if (!isNil "_tex") then {
        _unit setObjectTextureGlobal [_selection, _tex];
    };
} forEach (_gear getOrDefault [MAP_CAT_UNIFORM_TEXTURES, []]);

// -- Script
{
    DBG_ "Script: _idx = %1, _script=%2", _forEachIndex, _x EOL;
    [_unit, _gear] call _x;
} forEach (_gear getOrDefault [MAP_CAT_SCRIPT, []]);

// -- Finalize
_unit setVariable ["dzn_gear_done", true, true];
["dzn_gear_kitApplied", [_unit, _gear]] call CBA_fnc_localEvent;
