#include "defines.h"

params [
	["_kits", nil, [[]]],
	["_weaponCount", 1, [0]],
	["_magazineCount", 1, [0]],
	["_itemCount", 1, [0]],
	["_backpackCount", 1, [0]]
];

private _items = [];
// -- Gather list of items all over the kits
{
	DBG_ "(composeCargoItems) Kit=%1", _x EOL;
	_x params [
		["_equip", nil, [[]]], "_pw", "_sw", "_hw",
		"",
		"_uniform","_vest","_backpack"
	];
	DBG_ "(composeCargoItems) Equip=%1", _equip EOL;
	DBG_ "(composeCargoItems) _pw=%1", _pw EOL;
	DBG_ "(composeCargoItems) _sw=%1", _sw EOL;
	DBG_ "(composeCargoItems) _sw=%1", _sw EOL;

	// In case kit created and accessed in runtime and uniform items macro was used
	if (_uniform isEqualType "") then {
		_uniform = ["",[]];
	};

	{
		// -- Handle randomized items declaration
		if (_x isEqualType []) then {
			{ _items pushBackUnique _x; } forEach _x;
			continue;
		};
		// -- Add plain item declaration
		_items pushBackUnique _x
	} forEach [
		// -- Backpack
		_equip # 3,
		// -- Primary weapon and mag
		_pw # 1, _pw # 2,
		// -- Secondary weapon and mag
		_sw # 1, _sw # 2,
		// -- Handgun magazine
		_hw # 2
	]
	// -- Items in uniform, vest and backpack
	+ ((_uniform # 1) apply { _x # 0 })
	+ ((_vest # 1) apply { _x # 0 })
	+ ((_backpack # 1) apply { _x # 0 });
} forEach _kits;

// -- Compose Cargo kit from it
private _cargoWeapons = [];
private _cargoMagazines = [];
private _cargoItems = [];
private _cargoBackpacks = [];

private _cfgWeapons = configFile >> "CfgWeapons";
private _cfgMagazines = configFile >> "CfgMagazines";
private _cfgBackpacks = configFile >> "CfgVehicles";

{
	if (_x in ["", "PRIMARY MAG", "SECONDARY MAG", "HANDGUN MAG"]) then { continue; };
	if (getArray (_cfgWeapons >> _x >> "muzzles") isNotEqualTo []) then {
		_cargoWeapons pushBack [_x, _weaponCount];
		continue;
	};
	if (isClass(_cfgMagazines >> _x)) then {
		_cargoMagazines pushBack [_x, _magazineCount];
		continue;
	};
	if (isClass(_cfgBackpacks >> _x)) then {
		_cargoBackpacks pushBack [_x, _backpackCount];
		continue;
	};
	_cargoItems pushBack [_x, _itemCount];
} forEach _items;

[_cargoWeapons, _cargoMagazines, _cargoItems, _cargoBackpacks];