#include "defines.h"
/*
    Change gear of given box or vehicle with given gear set
    EXAMPLE: [ @Unit, @GearSet ] spawn dzn_fnc_gear_assignCargoGear;
    INPUT:
        0: OBJECT - Vehicle or box for which gear will be set
        1: ARRAY - Set of gear
    OUTPUT: NULL
*/
params ["_container", "_gear"];

DBG_ "Params: %1", _this EOL;

// Clear boxes
clearWeaponCargoGlobal _container;
clearMagazineCargoGlobal _container;
clearBackpackCargoGlobal _container;
clearItemCargoGlobal _container;

#define GET_RANDOM_ITEM(ITEM) if (ITEM isEqualType []) then { selectRandom ITEM } else { ITEM }

_gear params [
    ["_weapons", []],
    ["_magazines", []],
    ["_items", []],
    ["_backpacks", []],
    ["_weaponsWithAttachments", []]
];

// Add weapons
{
    _x params ["_item", "_count"];
    _container addWeaponCargoGlobal [GET_RANDOM_ITEM(_item), _count];
} forEach _weapons;

// Add Magazines
{
    _x params ["_item", "_count"];
    _container addMagazineCargoGlobal [GET_RANDOM_ITEM(_item), _count];
} forEach _magazines;

// Add Items
{
    _x params ["_item", "_count"];
    _container addItemCargoGlobal [GET_RANDOM_ITEM(_item), _count];
} forEach _items;

// Add Backpacks
{
    _x params ["_item", "_count"];
    _container addBackpackCargoGlobal [GET_RANDOM_ITEM(_item), _count];
} forEach _backpacks;

// Add Weapons with attachements (optional)
{
    _container addWeaponWithAttachmentsCargoGlobal _x;
} forEach _weaponsWithAttachments;

_container setVariable ["dzn_gear_done", true, true];
_container setVariable ["dzn_gear_items", _gear, true];