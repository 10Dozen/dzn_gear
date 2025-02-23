#include "defines.h"

params [
    ["_kits", nil, [[]]],
    ["_weaponCount", 1, [0]],
    ["_magazineCount", 1, [0]],
    ["_itemCount", 1, [0]],
    ["_backpackCount", 1, [0]]
];

DBG_ "Kits count: %1", count(_kits) EOL;

private ["_kit", "_cat", "_w", "_m", "_item"];
private _items = [];
// -- Gather list of items all over the kits
{
    _kit = _x;
    DBG_ "Kit=%1", _x EOL;

    // -- Weapons: handle random descriptor and/or class randomization
    {
        _cat = [[_x], _x] select (_x isEqualType []);
        {
            if (_x isEqualTo dzn_gear_emptyWeaponDescriptor) then { continue; };
            _w = _x get I_WEAPON_CLASS;
            _m = _x get I_WEAPON_MAG;

            {_items pushBackUnique _x} forEach (
                ([[_w], _w] select (_w isEqualType []))
                + ([[_m], _m] select (_m isEqualType []))
            );
        } forEach _cat;
    } forEach [
        _kit get MAP_CAT_PRIMARY,
        _kit get MAP_CAT_LAUNCHER,
        _kit get MAP_CAT_HANDGUN
    ];

    // -- Items in uniform, vest and backpack
    {
        // -- Handle randomized items declaration
        _itemsInCat = _x;
        DBG_ "Items in cat = %1", _itemsInCat EOL;
        {
            _item = _x;
            {
                DBG_ "Item to add = %1", _x EOL;
                _items pushBackUnique _x
            } forEach ([[_item], _item] select (_item isEqualType []));
        } forEach _itemsInCat;
    } forEach [
        [_kit get MAP_CAT_BACKPACK]
        + ((_kit get MAP_CAT_UNIFORM_ITEMS) apply { _x # 0 })
        + ((_kit get MAP_CAT_VEST_ITEMS) apply { _x # 0 })
        + ((_kit get MAP_CAT_BACKPACK_ITEMS) apply { _x # 0 })
    ];
    DBG_ "Unique item total count: %1", count(_items) EOL;
    DBG_ "Unique items: %1", _items EOL;
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
    DBG_ "Item = %1", _x EOL;
    if (_x in ["", MAG_PRIMARY, MAG_LAUNCHER, MAG_HANDGUN]) then { continue; };
    if (getArray (_cfgWeapons >> _x >> "muzzles") isNotEqualTo []) then {
        DBG_ "Adding Weapon: %1", _x EOL;
        _cargoWeapons pushBack [_x, _weaponCount];
        continue;
    };
    if (isClass(_cfgMagazines >> _x)) then {
        DBG_ "Adding Magazine: %1", _x EOL;
        _cargoMagazines pushBack [_x, _magazineCount];
        continue;
    };
    if (isClass(_cfgBackpacks >> _x)) then {
        DBG_ "Adding Backpack: %1", _x EOL;
        _cargoBackpacks pushBack [_x, _backpackCount];
        continue;
    };

    DBG_ "Adding Misc items: %1", _x EOL;
    _cargoItems pushBack [_x, _itemCount];
} forEach _items;

[_cargoWeapons, _cargoMagazines, _cargoItems, _cargoBackpacks];