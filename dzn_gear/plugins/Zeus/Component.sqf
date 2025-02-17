#include "defines.h"
#include "\a3\ui_f\hpp\definedikcodes.inc"

/*

*/


#define KEYBIND_SETTING_TITLE "dzn Gear - Zeus"
[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_OpenMenu",
    "Open dzn_Gear menu on object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay)) exitWith { false };
        ThisCOB call [F(openMenu), GET_SELECTED_OBJECTS];
    },
    [DIK_G, [false, false, false]]
] call CBA_fnc_addKeybind;

[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_Copy",
    "Copy gear from object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay)) exitWith { false };
        ThisCOB call [F(copyGear), GET_SELECTED_OBJECTS];
    },
    [DIK_G, [false, true, false]]
] call CBA_fnc_addKeybind;

[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_Paste",
    "Paste gear to object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay)) exitWith { false };
        ThisCOB call [F(applyKit), GET_SELECTED_OBJECTS];
    },
    [DIK_G, [false, true, false]]
] call CBA_fnc_addKeybind;

[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_Paste",
    "Save gear of object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay)) exitWith { false };
        ThisCOB call [F(saveKit), GET_SELECTED_OBJECTS];
    },
    [DIK_G, [true, false, false]]
] call CBA_fnc_addKeybind;


private _messages = ['COMPONENT_PATH\Messages.yml',"PREPROCESS_FILE"] call dzn_fnc_parseSFML;
CONVERT_NUMERIC_KEYS(_messages);

/*
, { 
			params ["_units", "_add"];			
			{
				[_x, format ["_this %1 'NVGoggles_OPFOR'", SEL(_add, "linkItem", "unlinkItem")]] call dzn_fnc_gear_zc_addItemsToUnits;
			} forEach _units;			
			[format ["NVG %1 units", SEL(_add, "added to","removed from")], "success"] call dzn_fnc_gear_zc_showNotif;	
		}
        */
private _declaration = [
    [Q(ZeusDisplay), displayNull],
    [Q(FastItems), [
        ["NVG", [
            { _this linkItem "NVGoggles_OPFOR"; true },
            { _this unlinkItem "NVGoggles_OPFOR"; true },
            NOTIF_MSG_ITEM_NVG_ADDED,
            NOTIF_MSG_ITEM_NVG_REMOVED
        ]],
        ["BLUFOR LR", [
            { _this addBackpack 'tf_rt1523g'; true },
            { removeBackpack _this; true },
            NOTIF_MSG_ITEM_BACKPACK_ADDED,
            NOTIF_MSG_ITEM_BACKPACK_REMOVED
        ], [["color", COLOR_HEX_AQUA]]],
        ["OPFOR LR", [
            { _this addBackpack 'tf_mr3000_rhs'; true },
            { removeBackpack _this; true },
            NOTIF_MSG_ITEM_BACKPACK_ADDED,
            NOTIF_MSG_ITEM_BACKPACK_REMOVED
        ], [["color", COLOR_HEX_BRICK_RED]]],
        ["INDEP LR", [
            { _this addBackpack 'tf_anprc155_coyote'; true },
            { removeBackpack _this; true },
            NOTIF_MSG_ITEM_BACKPACK_ADDED,
            NOTIF_MSG_ITEM_BACKPACK_REMOVED
        ], [["color", COLOR_HEX_LIME]]],
        ["Weapon Flashlight", [
            {
                private _items = (compatibleItems [primaryWeapon _this, "PointerSlot"]);
                private _cfg = configFile >> "CfgWeapons";
                private _idx = _items findIf {
                    getNumber(_cfg >> _x >> "ItemInfo" >> "FlashLight" >> "daylight") == 1
                };
                if (_idx == -1) exitWith { false };
                _this addPrimaryWeaponItem (_items # _idx);
                true
            },
            { _unit removePrimaryWeaponItem ((primaryWeaponItems _unit) # 1); true },
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
            { _unit removePrimaryWeaponItem ((primaryWeaponItems _unit) # 0); true },
            NOTIF_MSG_ITEM_WEAPON_SUPPRESSOR_ADDED,
            NOTIF_MSG_ITEM_WEAPON_SUPPRESSOR_REMOVED
        ]],
        ["Weapon Optics", [
            {
                private _items = (compatibleItems [primaryWeapon _this, "CowsSlot"]);
                _this addPrimaryWeaponItem (selectRandom _items);
                true
            },
            { _unit removePrimaryWeaponItem ((primaryWeaponItems _unit) # 2); true },
            NOTIF_MSG_ITEM_WEAPON_OPTICS_ADDED,
            NOTIF_MSG_ITEM_WEAPON_OPTICS_REMOVED
        ]],
    ]],

    [Q(Messages), _messages],

    [Q(GenerationIndex), 0],
    [Q(LastPersonalGear), []],
    [Q(LastCargoGear), []],

    PREP_COMPONENT_FUNCTION(openMenu),
    PREP_COMPONENT_FUNCTION(copyGear),
    PREP_COMPONENT_FUNCTION(applyKit),
    PREP_COMPONENT_FUNCTION(saveKit),


    PREP_COMPONENT_FUNCTION(openMenu),

    PREP_COMPONENT_FUNCTION(notify)
];

private _cob = createHashMapObject [_declaration];

_cob
