#include "defines.h"


#define WeaponMag(X) (if ((X) isEqualTo []) then { "" } else { X select 0 })

// @Kit = @Unit call dzn_fnc_gear_getGear
// Return: PersonalGearArray

DBG_1("Params: %1", _this);

private _kit = [];

_kit pushBack [
    EXPORT_CAT_EQUIPMENT
    ,uniform _this
    ,vest _this
    ,backpack _this
    ,headgear _this
    ,goggles _this
];

// Primary
private _priMag = WeaponMag(primaryWeaponMagazine _this);
_kit pushBack [
    EXPORT_CAT_PRIMARY
    ,primaryWeapon _this
    ,_priMag
    ,primaryWeaponItems _this
];

// Secondary
private _secMag = WeaponMag(secondaryWeaponMagazine _this);
_kit pushBack [
    EXPORT_CAT_LAUNCHER
    ,secondaryWeapon _this
    ,_secMag
    ,secondaryWeaponItems _this
];

// Handgun
private _handMag = WeaponMag(handgunMagazine _this);
_kit pushBack [
    EXPORT_CAT_HANDGUN
    ,handgunWeapon _this
    ,_handMag
    ,handgunItems _this
];

// Assigned Items
_kit pushBack ([EXPORT_CAT_ASSIGNED] + assignedItems _this);

// Equiped Items and magazines
private "_items";
{
    _items = _x call BIS_fnc_consolidateArray;
    {
        switch (_x select 0) do {
            case _priMag:  { _x set [0, MAG_PRIMARY] };
            case _secMag:  { _x set [0, MAG_LAUNCHER] };
            case _handMag: { _x set [0, MAG_HANDGUN] };
        };
    } forEach _items;

    _kit pushBack [
        switch (_forEachIndex) do {
            case 0: { EXPORT_CAT_UNIFORM_ITEMS  };
            case 1: { EXPORT_CAT_VEST_ITEMS     };
            case 2: { EXPORT_CAT_BACKPACK_ITEMS };
        },
        _items
    ];
} forEach [
    uniformItems _this
    , vestItems _this
    , backpackItems _this
];

// Copy idnetity if setting enabled
if (dzn_gear_handleIdentity) then {
    _kit pushBack [
        EXPORT_CAT_IDENTITY
        , face _this
        , speaker _this
        , name _this
    ];
};

_kit
