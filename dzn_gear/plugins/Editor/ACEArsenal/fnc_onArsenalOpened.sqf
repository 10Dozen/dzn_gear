#include "defines.h"

params ["_display"];
_self set [Q(Display), _display];

["RESET", _display] call dzn_fnc_HandleControl;

// -- Show gear totals
ECOB(Editor,Core) call [F(InitKeybinds), [_display]];
ECOB(Editor,Core) call [F(SetCurrentDisplay), [_display]];
ECOB(Editor,Core) call [F(ShowTotals), []];

// -- Event handlers
_self set [
    Q(MainMenuOpenedEH),
    ["dzn_AdvDialog2_onBeforeOpened", { ThisCOB call [F(onMainMenuOpened), _this];}] call CBA_fnc_addEventHandler
];

_self set [
    Q(MainDialogClosedEH),
    ["dzn_AdvDialog2_onClosed", { ThisCOB call [F(onMainMenuClosed), _this]; }] call CBA_fnc_addEventHandler
];

(_display displayCtrl IDC_leftTabContent) ctrlAddEventHandler ["LBSelChanged", {
    // params ["_ctrl", "_idx"];
    [{ ThisCOB call [F(onTabSwitch), [true, _this]]; }, _this] call CBA_fnc_execNextFrame;
}];

(_display displayCtrl IDC_rightTabContent) ctrlAddEventHandler ["LBSelChanged", {
    // params ["_ctrl", "_idx"];
    [{ ThisCOB call [F(onTabSwitch), [false, _this]]; }, _this] call CBA_fnc_execNextFrame;
}];


// -- Render buttons
#define BTN_FORMAT "<t align='center' size='2'>%1</t>"
#define _POS(Y) [-0.02, Y, 0.1, 0.1]

[
    "ADD", _display, BTN_SHOW, [
        "BUTTON",
        format [BTN_FORMAT, "O"],
        { ThisCOB call [F(onShowButtonClick), [true]]; }, [],
        [["pos", _POS(0.32)], ["tooltip", "Show item pool"], ["bg", COLOR_STEEL_BLUE]]
    ]
] call dzn_fnc_HandleControl;

[
    "ADD", _display, BTN_ADD, [
        "BUTTON",
        format [BTN_FORMAT, "+"],
        { ThisCOB call [F(onAddButtonClick), [true]]; }, [],
        [["pos", _POS(0.42)], ["tooltip", "Adds item to pool!"], ["bg", COLOR_PALE_GREEN]]
    ]
] call dzn_fnc_HandleControl;


// -- Sub category buttons
#define _POS(Y) [0.92, Y, 0.1, 0.1]
[
    "ADD", _display, BTN_SUB_SHOW, [
        "BUTTON",
        format [BTN_FORMAT, "O"],
        { ThisCOB call [F(onShowButtonClick), [false]]; }, [],
        [["pos", _POS(0.32)], ["tooltip", "Show sub-category item pool"], ["bg", COLOR_STEEL_BLUE]]
    ]
] call dzn_fnc_HandleControl;

[
    "ADD", _display, BTN_SUB_ADD, [
        "BUTTON",
        format [BTN_FORMAT, "+"],
        { ThisCOB call [F(onAddButtonClick), [false]]; }, [],
        [["pos", _POS(0.42)], ["tooltip", "Adds sub-category item to pool"], ["bg", COLOR_PALE_GREEN]]
    ]
] call dzn_fnc_HandleControl;
