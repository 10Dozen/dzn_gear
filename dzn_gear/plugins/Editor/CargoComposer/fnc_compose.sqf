#include "defines.h"
#include "..\..\..\fn\defines.h"

params [
    ["_kits", nil, [[]]],
    ["_weaponCount", 1, [0]],
    ["_magazineCount", 1, [0]],
    ["_itemCount", 1, [0]],
    ["_backpackCount", 1, [0]]
];

DBG_ "(composeCargoItems) Kits count: %1", count(_kits) EOL;

private _items = [];
// -- Gather list of items all over the kits
{
    DBG_ "(composeCargoItems) Kit=%1", _x EOL;
    _x params [
        ["_equip", nil, [[]]], "_pw", "_sw", "_hw",
        "",
        "_uniform","_vest","_backpack"
    ];

    {
        // -- Handle randomized items declaration
        if (_x isEqualType []) then {
            { _items pushBackUnique _x; } forEach _x;
            continue;
        };
        // -- Add plain item declaration
        _items pushBackUnique _x;
    } forEach [
        // -- Backpack
        _x get MAP_CAT_BACKPACK,
        // -- Primary weapon and mag
        _x get MAP_CAT_PRIMARY get I_WEAPON_CLASS, _x get MAP_CAT_PRIMARY get I_WEAPON_MAG,
        // -- Secondary weapon and mag
        _x get MAP_CAT_LAUNCHER get I_WEAPON_CLASS, _x get MAP_CAT_LAUNCHER get I_WEAPON_MAG,
        // -- Handgun magazine
        _x get MAP_CAT_HANDGUN get I_WEAPON_MAG
    ]
    // -- Items in uniform, vest and backpack
    + ((_x get MAP_CAT_UNIFORM_ITEMS) apply { _x # 0 })
    + ((_x get MAP_CAT_VEST_ITEMS) apply { _x # 0 })
    + ((_x get MAP_CAT_BACKPACK_ITEMS) apply { _x # 0 });

    DBG_ "(composeCargoItems) Unique item total count: %1", count(_items) EOL;
    DBG_ "(composeCargoItems) Unique items: %1", _items EOL;
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
        DBG_ "(composeCargoItems) Adding Weapon: %1", _x EOL;
        _cargoWeapons pushBack [_x, _weaponCount];
        continue;
    };
    if (isClass(_cfgMagazines >> _x)) then {
        DBG_ "(composeCargoItems) Adding Magazine: %1", _x EOL;
        _cargoMagazines pushBack [_x, _magazineCount];
        continue;
    };
    if (isClass(_cfgBackpacks >> _x)) then {
        DBG_ "(composeCargoItems) Adding Backpack: %1", _x EOL;
        _cargoBackpacks pushBack [_x, _backpackCount];
        continue;
    };

    DBG_ "(composeCargoItems) Adding Misc items: %1", _x EOL;
    _cargoItems pushBack [_x, _itemCount];
} forEach _items;

[_cargoWeapons, _cargoMagazines, _cargoItems, _cargoBackpacks];