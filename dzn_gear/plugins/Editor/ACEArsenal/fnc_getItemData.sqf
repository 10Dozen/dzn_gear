#include "defines.h"

params ["_category", "_itemDescriptor"];
DBG_ "Params: %1", _this EOL;

if (_category in CAT_WEAPONS) exitWith {
    _itemDescriptor params ["_w", "_m", "_a"];
    private _attaches = (_a select { _x != "" } apply {
        format ["    <t color='#aaaaaa'>+ %1</t>", getText (configFile >> "CfgWeapons" >> _x >> "displayName")],
    }) joinString "<br/>";

    format [
        "%1<br/><t size='0.8'>  <t color='#a7b37b'>%2</t><br/>%3</t>",
        getText (configFile >> "CfgWeapons" >> _w >> "displayName"),
        getText (configFile >> "CfgMagazines" >> _m >> "displayName"),
        _attaches
    ]
};

if (_category == CAT_UNIFORM) exitWith {
    private _cfg = configFile >> "CfgWeapons" >> _itemDescriptor;
    private _load = getNumber (configFile >> "CfgVehicles" >> getText (_cfg >> "ItemInfo" >> "containerClass") >> "maximumLoad");

    format [
        "%1<br/><t size='0.8'>  <t color='#c8d49f'>Load: %2 kg</t>   <t color='#e3d09f'>Mass: %3 kg</t>",
        getText (_cfg >> "displayName"),
        MASS_TO_KG(_load),
        MASS_TO_KG(getNumber (_cfg >> "ItemInfo" >> "mass"))
    ]
};

if (_category == CAT_VEST) exitWith {
    private _cfg = configFile >> "CfgWeapons" >> _itemDescriptor;
    private _load = getNumber (configFile >> "CfgVehicles" >> getText (_cfg >> "ItemInfo" >> "containerClass") >> "maximumLoad");

    format [
        "%1<br/><t size='0.8'>  <t color='#c8d49f'>Load: %2 kg</t>   <t color='#e3d09f'>Mass: %3 kg</t>   <t color='#a3bde3'>Armor: %4+%5</t>",
        getText (_cfg >> "displayName"),
        MASS_TO_KG(_load),
        MASS_TO_KG(getNumber (_cfg >> "ItemInfo" >> "mass")),
        getNumber(_cfg >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "armor"),
        getNumber(_cfg >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Chest" >> "passThrough")
    ]
};

if (_category == CAT_HEADGEAR) exitWith { // TBD: Headgear armor
    private _cfg = configFile >> "CfgWeapons" >> _itemDescriptor;
    format [
        "%1<br/><t size='0.8'>  <t color='#e3d09f'>Mass: %2 kg</t>   <t color='#a3bde3'>Armor: %3+%4</t>",
        getText (_cfg >> "displayName"),
        MASS_TO_KG(getNumber (_cfg >> "ItemInfo" >> "mass")),
        getNumber(_cfg >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor"),
        getNumber(_cfg >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "passThrough")
    ]
};


if (_category == CAT_BACKPACK) exitWith {
    private _cfg = configFile >> "CfgVehicles" >> _itemDescriptor;
    format [
        "%1<br/><t size='0.8'>  <t color='#c8d49f'>Load: %2 kg</t>   <t color='#e3d09f'>Mass: %3 kg</t>",
        getText (_cfg >> "displayName"),
        MASS_TO_KG(getNumber (_cfg >> "ItemInfo" >> "mass")),
        MASS_TO_KG(getNumber (_cfg >> "maximumLoad"))
    ]
};

if (_category == CAT_FACEWEAR) exitWith {
    private _cfg = configFile >> "CfgGlasses" >> _itemDescriptor;;
    format [
        "%1<br/><t size='0.8'>  <t color='#e3d09f'>Mass: %2 kg</t>",
        getText (_cfg >> "displayName"),
        MASS_TO_KG(getNumber (_cfg >> "mass"))
    ]
};


if (_category == CAT_FACE) exitWith {
    _itemDescriptor
};

if (_category == CAT_VOICE) exitWith {
    format [
        "%1",
        getText (configFile >> "CfgVoice" >> _itemDescriptor >> "displayName")
    ]
};

if (_category / CAT_MAG in CAT_WEAPONS || _category / CAT_MAG2 in CAT_WEAPONS) exitWith {
    format [
        "%1",
        getText (configFile >> "CfgMagazines" >> _itemDescriptor >> "displayName")
    ]
};

private _cfg = configFile >> "CfgWeapons" >> _itemDescriptor;
private _massCfg = _cfg >> "ItemInfo" >> "mass";
if (isNull _massCfg) then {
    _massCfg = _cfg >> "WeaponSlotsInfo" >> "mass";
};

format [
    "%1<br/><t size='0.8'>  <t color='#e3d09f'>Mass: %2 kg</t>",
    getText (_cfg >> "displayName"),
    MASS_TO_KG(getNumber _massCfg)
]
