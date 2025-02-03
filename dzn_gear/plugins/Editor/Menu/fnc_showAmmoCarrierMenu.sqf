#include "defines.h"

/*
    Menu to select ammo from current's unit gear or from given kit name
*/
params ["_menuNavbar"];

private _menu = _menuNavbar + [
    ["LABEL", "Find and load kit by name or use your current loadout"],
    ["BR"],

    [
        "INPUT", "",
        [
            ["tag", "i_kitname"],
            ["tooltip", "(optional) Load kit's weapon/launcher. On loading empty - current gear will be used."]
        ],
        [
            [
                "EditChanged",
                {
                    params ["_eventData", "_dialogCOB", "_args"];
                    (_eventData # 0) ctrlSetTextColor (
                        [COLOR_WHITE, COLOR_DARK_GREEN] select (!isNil (_eventData # 1))
                    );
                }
            ]
        ]
    ],
    ["BUTTON", "Load kit", {
        params ["_dialogCOB"];
        dzn_gear_AmmoBearearComponent call [F(onKitLoad), [_dialogCOB, _kit]];
    }, [], [["bg", COLOR_STEEL_BLUE]]],
    ["BR"],

    ["LABEL"], ["BR"],

    ["BUTTON", "Primary Weapon", {
        params ["_dialogCOB"];
        dzn_gear_AmmoBearearComponent call [F(onWeaponSelected), [_dialogCOB, 0]];
    }, [], [["tag", "btn_primary"], ["h", 0.12]]],
    ["BUTTON", "Launcher Weapon", {
        params ["_dialogCOB"];
        dzn_gear_AmmoBearearComponent call [F(onWeaponSelected), [_dialogCOB, 1]];
    }, [], [["tag", "btn_launcher"], ["h", 0.12]]],
    ["BR"],

    ["LABEL", "Total magazines count: 0", [["bg", COLOR_STEEL_BLUE], ["tag", "lbl_magTotalCount"]]],
    ["BR"],

    ["DROPDOWN", _allMags, 0, [["tag", "d_maglist"],["w", 0.75], ["h", 0.1]]],
    ["BUTTON", "<t align='center' size='2' color='#000000'>+</t>", {
        params ["_dialogCOB"];
        dzn_gear_AmmoBearearComponent call [F(onMagazineAdd), [_dialogCOB, 1]];
    },[],[["bg", COLOR_PALE_GREEN], ["h", 0.1]]],
    ["BUTTON", "<t align='center' size='2' color='#000000'>–</t>", {
        params ["_dialogCOB"];
        dzn_gear_AmmoBearearComponent call [F(onMagazineRemove), [_dialogCOB, 1]];
    },[],[["bg", COLOR_PALE_RED], ["h", 0.1]]],
    ["BR"],
    ["LABEL", "",[["h",0.02]]], ["BR"],

    ["LABEL","",[["tag", "lbl_magInfo"], ["h", 0.23], ["x",0.1], ["w",0.9]]],
    ["BR"],

    ["BUTTON", "<t align='center'>Clear</t>", {
        params ["_dialogCOB"];
        dzn_gear_AmmoBearearComponent call [F(onClear), [_dialogCOB]];
    }, [], [["bg", COLOR_PALE_RED], ["tooltip", "Clears selected pool of magazines."]]],

    ["BUTTON", "<t align='center'>Apply to self</t>", {
        dzn_gear_AmmoBearearComponent call [F(composeAndExport), [true]];
    }, [], [["bg", COLOR_PALE_GREEN], ["tooltip", "Puts selected pool of magazines to your backpack."]]],

    ["BUTTON", "<t align='center'>Compose</t>", {
        dzn_gear_AmmoBearearComponent call [F(composeAndExport), [false]];
    }, [], [["bg", COLOR_PALE_GREEN], ["tooltip", "Exports composed line to clipboard."]]],

    ["BR"],
    ["OnDraw", {
        params ["_dialogCOB"];
        dzn_gear_AmmoBearearComponent call [F(onKitLoad), [_dialogCOB]];
    }]

];
_menu call dzn_fnc_ShowAdvDialog2;