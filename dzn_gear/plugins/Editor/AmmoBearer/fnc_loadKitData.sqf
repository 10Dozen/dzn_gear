#include "defines.h"
#define DBG_FUNC_PREFIX "loadKitData"

// Loads data from kit (if given and exists) or from current loadout (if kitname is empty). Does nothing if kitname not exists.
params ["_kitname"];
DBG_1("(ABC.loadKitData) Invoked. Params: %1", _this);

private _weapons = [primaryWeapon player, secondaryWeapon player];
private _magazines = ["", ""];

private _primaryMagArr = primaryWeaponMagazine player;
if (_primaryMagArr isNotEqualTo []) then {
    _magazines set [0, _primaryMagArr # 0];
};

private _secondaryMagArr = secondaryWeaponMagazine player;
if (_secondaryMagArr isNotEqualTo []) then {
    _magazines set [1, _secondaryMagArr # 0];
};

if (_kitname != "") then {
    private _kit = missionNamespace getVariable [_kitname, []];
    if (_kit isEqualTo []) exitWith {};
    DBG("(ABC.loadKitData) Using Kit weapons");

    // -- Weapon/magazine may be a randomized array, so pick first item
    _weapons = [_kit # 1 # 1, _kit # 2 # 1] apply {
        if (_x isEqualType []) then {
            _x # 0
        } else {
            _x
        }
    };
    _magazines = [_kit # 1 # 2, _kit # 2 # 2] apply {
        if (_x isEqualType []) then {
            _x # 0
        } else {
            _x
        }
    };
};

_self set [Q(CurrentWeapons), _weapons];
_self set [Q(CurrentWeaponsMags), _magazines];
