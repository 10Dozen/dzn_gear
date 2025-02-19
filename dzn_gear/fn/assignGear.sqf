#include "defines.h"

/*
	Applies gear to unit.
	Also applies extras like TAG variables, script, uniform textures/mats

	Params:
	0: _unit (OBJECT) - unit to apply gear
	1: _gear (dzn_gear_GearMapInterface) - gear 

*/

#define GET_RANDOM_ITEM(ITEM) (selectRandom ([[ITEM], ITEM] select ((ITEM) isEqualType [])))


if ((ITEM) isEqualType []) then { selectRandom (ITEM) } else { ITEM }

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
private ["_weaponDescriptor", "_r"];

{
	_weaponDescriptor = _gear get _x;
	if (_weaponDescriptor isEqualType []) then {
		// -- Radnomized preset
		_weaponDescriptor = selectRandom _weaponDescriptor;
	};

	// -- Check for randomized weapon-mag combo
	private _weapon =_weaponDescriptor get "class";
	private _mag = _weaponDescriptor get "magazine";
	private _attaches = _weaponDescriptor get "attaches";
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
	_attaches pushBack _mag;
	{
		private _item = GET_RANDOM_ITEM(_x);
		switch (_i) do {
			case 1: { _unit addPrimaryWeaponItem _item };
			case 2: { _unit addSecondaryWeaponItem _item };
			case 3: { _unit addHandgunItem _item };
		};
	} forEach _attaches;
} forEach (MAP_CAT_PRIMARY, MAP_CAT_LAUNCHER, MAP_CAT_HANDGUN);

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

// -- ADD ITEMS TO UNIFORM
private ["_item", "_count"];
{
	_item = GET_RANDOM_ITEM(_x select 0);
	_count = _x # 1;
	if (_count isEqualType "") then {
		// "x2-5" -> 2 + floor random 4 (5+1-2) => 2 + 0...3 => 2...5
		_limits = ((_count select [1,22]) splitString "-") apply { parseNumber _x };
		_count = (_limits # 0) + floor random ((_limits # 1) - (_limits # 0));
	};
	for "_i" from 1 to (_x # 1) do {
		_unit addItemToUniform (_magClasses getOrDefault [_item, _item]);
	};
} forEach (_gear get MAP_CAT_UNIFORM_ITEMS);

// -- ADD ITEMS TO VEST
{
	_item = GET_RANDOM_ITEM(_x select 0);
	for "_i" from 1 to (_x # 1) do {
		_unit addItemToVest (_magClasses getOrDefault [_item, _item]);
	};
} forEach (_gear get MAP_CAT_VEST_ITEMS);

// -- ADD ITEMS TO BACKPACK
{
	_item = GET_RANDOM_ITEM(_x select 0);
	for "_i" from 1 to (_x # 1) do {
		_unit addItemToBackpack (_magClasses getOrDefault [_item, _item]);
	};
} forEach (_gear get MAP_CAT_BACKPACK_ITEMS);

// -- EXTRA FIELDS 
// -- IDENTITY
private _identity = _gear getOrDefault [MAP_CAT_INDENTITY, []];
if (_identity isNotEqualTo []) then {
	[_unit, _identity] remoteExec ["dzn_fnc_gear_assignIdentity", 0];
};

// -- TAGS
private _tags = _gear getOrDefault [MAP_CAT_TAGS, []];
{
	_unit setVariable ((
		[_x # 0, _x # 1, true],
		[_x, true, true]
	) select (_x isEqualTo ""));
} forEach _tags;

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
private _script = _gear get MAP_CAT_SCRIPT;
if (!isNil "_script") then {
	[_unit, _gear] call _script;
};


_unit setVariable ["dzn_gear_done", true, true];
["dzn_gear_kitApplied", [_unit, _gear]] call CBA_fnc_localEvent;
