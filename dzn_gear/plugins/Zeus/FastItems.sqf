#include "defines.h"

[

["Night Vision Goggles", [
    { _this linkItem "NVGoggles_OPFOR"; true },
    { _this unlinkItem "NVGoggles_OPFOR"; true },
    NOTIF_MSG_ITEM_NVG_ADDED,
    NOTIF_MSG_ITEM_NVG_REMOVED
]],

["BLUFOR LR Radio", [
    { _this addBackpack 'tf_rt1523g'; true },
    { removeBackpack _this; true },
    NOTIF_MSG_ITEM_BACKPACK_ADDED,
    NOTIF_MSG_ITEM_BACKPACK_REMOVED
], [["color", COLOR_AQUA]]],

["OPFOR LR Radio", [
    { _this addBackpack 'tf_mr3000_rhs'; true },
    { removeBackpack _this; true },
    NOTIF_MSG_ITEM_BACKPACK_ADDED,
    NOTIF_MSG_ITEM_BACKPACK_REMOVED
], [["color", COLOR_BRICK_RED]]],

["INDEP LR Radio", [
    { _this addBackpack 'tf_anprc155_coyote'; true },
    { removeBackpack _this; true },
    NOTIF_MSG_ITEM_BACKPACK_ADDED,
    NOTIF_MSG_ITEM_BACKPACK_REMOVED
], [["color", COLOR_LIME]]],

["Weapon Flashlight", [
    {
        private _items = (compatibleItems [primaryWeapon _this, "PointerSlot"]);
        private _cfg = configFile >> "CfgWeapons";
        private _idx = _items findIf {
            getNumber(_cfg >> _x >> "ItemInfo" >> "FlashLight" >> "irLight") == 0
        };
        if (_idx == -1) exitWith { false };
        _this addPrimaryWeaponItem (_items # _idx);
        true
    },
    { _this removePrimaryWeaponItem ((primaryWeaponItems _this) # 1); true },
    NOTIF_MSG_ITEM_WEAPON_LIGHT_ADDED,
    NOTIF_MSG_ITEM_WEAPON_LIGHT_REMOVED
]],

["Weapon Suppressor", [
    {
        private _items = (compatibleItems [primaryWeapon _this, "MuzzleSlot"]);
        private _cfg = configFile >> "CfgWeapons";
        private _idx = _items findIf {
            getNumber(_cfg >> _x >> "ItemInfo" >> "soundTypeIndex") == 1
        };
        if (_idx == -1) exitWith { false };
        _this addPrimaryWeaponItem (_items # _idx);
        true
    },
    { _this removePrimaryWeaponItem ((primaryWeaponItems _this) # 0); true },
    NOTIF_MSG_ITEM_WEAPON_SUPPRESSOR_ADDED,
    NOTIF_MSG_ITEM_WEAPON_SUPPRESSOR_REMOVED
]],

["Weapon Optics", [
    {
        private _items = (compatibleItems [primaryWeapon _this, "CowsSlot"]);
        _this addPrimaryWeaponItem (selectRandom _items);
        true
    },
    { _this removePrimaryWeaponItem ((primaryWeaponItems _this) # 2); true },
    NOTIF_MSG_ITEM_WEAPON_OPTICS_ADDED,
    NOTIF_MSG_ITEM_WEAPON_OPTICS_REMOVED
]]

]