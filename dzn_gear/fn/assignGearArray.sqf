#include "defines.h"

/*
/*
    Applies gear to unit.
    Backward compatibility version. Do not apply extras except identity.

    Params:
    0: _unit (OBJECT) - unit to apply gear
    1: _gear (ARRAY) - gear
*/


#define GET_RANDOM_ITEM(ITEM) if ((ITEM) isEqualType []) then { selectRandom (ITEM) } else { ITEM }

DBG_ "Params: %1", _this EOL;

// [@Unit, @GearSet] spawn dzn_fnc_gear_assignGear;
params ["_unit", "_gear"];

_unit setVariable ["BIS_enableRandomization", false];
enableSentences false;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;
removeAllAssignedItems _unit;
removeAllWeapons _unit;

// waitUntil { (items _unit) isEqualTo [] };

private _magClasses = [];

// -- ADD WEAPONS
private ["_weaponDescriptor", "_r"];

DBG_ "Gear: %1", _gear EOL;

for "_i" from 1 to 3 do {
    _weaponDescriptor = (_gear # _i) select [1, 3];
    if (count (_gear # _i) == 2) then {
        // -- Radnomized preset
        _weaponDescriptor = selectRandom (_gear # _i # 1);
    };
    _weaponDescriptor params ["_weapon", "_mag", "_attaches"];

    // -- Check for randomized weapon-mag combo
    if ((_weaponDescriptor # 0) isEqualType []) then {
        _r = round random (count (_weaponDescriptor # 0) - 1);
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
    _attaches pushBack _mag;
    {
        private _item = _x;
        // -- Randomized attachment option
        if (_item isEqualType []) then {
            _item = selectRandom _x;
        };

        switch (_i) do {
            case 1: { _unit addPrimaryWeaponItem _item };
            case 2: { _unit addSecondaryWeaponItem _item };
            case 3: { _unit addHandgunItem _item };
        };
    } forEach _attaches;
};
_magClasses = createHashMapFromArray [
    ["PRIMARY MAG", _magClasses # 0],
    ["SECONDARY MAG", _magClasses # 1],
    ["HANDGUN MAG", _magClasses # 2]
];

// -- ADD EQUIP
private _equip = ((_gear # 0) select [1, 5]) apply { GET_RANDOM_ITEM(_x) };

_unit forceAddUniform _equip # 0;
_unit addVest _equip # 1;
_unit addBackpackGlobal _equip # 2;
_unit addHeadgear _equip # 3;
_unit addGoggles _equip # 4;

// -- ADD ASSIGNED ITEMS
{
    _unit addWeapon (GET_RANDOM_ITEM(_x));
} forEach ((_gear # 4) select [1, 20]);

// -- ADD ITEMS TO UNIFORM
private ["_item", "_count"];
{
    _item = GET_RANDOM_ITEM(_x select 0);
    for "_i" from 1 to (_x # 1) do {
        _unit addItemToUniform (_magClasses getOrDefault [_item, _item]);
    };
} forEach (_gear # 5 # 1);

// -- ADD ITEMS TO VEST
{
    _item = GET_RANDOM_ITEM(_x select 0);
    for "_i" from 1 to (_x # 1) do {
        _unit addItemToVest (_magClasses getOrDefault [_item, _item]);
    };
} forEach (_gear # 6 # 1);

// -- ADD ITEMS TO BACKPACK
{
    _item = GET_RANDOM_ITEM(_x select 0);
    for "_i" from 1 to (_x # 1) do {
        _unit addItemToBackpack (_magClasses getOrDefault [_item, _item]);
    };
} forEach (_gear # 7 # 1);

// -- IDENTITY
if (count _gear >= 9) then {
    [_unit, _gear # 8] remoteExec ["dzn_fnc_gear_assignIdentity", 0];
};

_unit setVariable ["dzn_gear_done", true, true];
["dzn_gear_kitApplied", [_unit]] call CBA_fnc_localEvent;
