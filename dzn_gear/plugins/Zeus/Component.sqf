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

private _declaration = [
    [Q(ZeusDisplay), displayNull],
    [Q(FastItems), [
        ["NVG", {}],
        ["BLUFOR LR", {}],
        ["OPFOR LR", {}],
        ["INDEP LR", {}],
        ["Weapon Flashlight", {}],
        ["Weapon Muzzle", {}],
        ["Weapon Optics", {}],
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
