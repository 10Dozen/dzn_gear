#include "defines.h"

params ["_category"];

private _itemDescriptor = ["","",["","","",""]];

switch _category do {
    case CAT_PRIMARY_WEAPON: {
        private _weapon = primaryWeapon player;
        private _mag = primaryWeaponMagazine player # 0;
        private _attaches = primaryWeaponItems player;
        _itemDescriptor = [_weapon, _mag, _attaches];
    };
    case CAT_LAUNCHER_WEAPON: {
        private _weapon = secondaryWeapon player;
        private _mag = secondaryWeaponMagazine player # 0;
        private _attaches = secondaryWeaponItems player;
        _itemDescriptor = [_weapon, _mag, _attaches];
    };
    case CAT_HANDGUN_WEAPON: {
        private _weapon = handgunWeapon player;
        private _mag = handgunMagazine player # 0;
        private _attaches = handgunItems player;
        _itemDescriptor = [_weapon, _mag, _attaches];
    };
};

DBG_ "ItemDescripotr: %1", _itemDescriptor EOL;

private _pool = _self get Q(ItemPools) getOrDefaultCall [_category, { [] }, true];
_pool pushBack _itemDescriptor;
_pool sort true;
