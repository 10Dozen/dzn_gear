#include "defines.h"
#include "\a3\ui_f\hpp\definedikcodes.inc"
#define KEYBIND_SETTING_TITLE "dzn Gear - Zeus"

[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_OpenMenu",
    "Open dzn_Gear menu on object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay))) exitWith { false };
        ThisCOB call [F(openMenu), []];
        false
    },
    [DIK_H, [false, false, false]]
] call CBA_fnc_addKeybind;

[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_Copy",
    "Copy gear from object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay))) exitWith { false };
        ThisCOB call [F(copyGear), []];
    },
    [DIK_H, [false, true, false]]
] call CBA_fnc_addKeybind;

[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_Paste",
    "Paste gear to object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay))) exitWith { false };
        ThisCOB call [F(applyGear), []];
    },
    [DIK_H, [false, false, true]]
] call CBA_fnc_addKeybind;

[
    KEYBIND_SETTING_TITLE,
    "dznGear_Zeus_Save",
    "Save gear of object",
    {},
    {
        if (isNull (ThisCOB get Q(ZeusDisplay))) exitWith { false };
        ThisCOB call [F(saveGear), []];
    },
    [DIK_H, [true, false, false]]
] call CBA_fnc_addKeybind;