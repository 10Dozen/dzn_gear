#include "defines.h"

params ["_display"];
_self set [Q(Display), _display];

["RESET", _display] call dzn_fnc_HandleControl;

// -- Show gear totals
ECOB(Editor,Core) call [F(InitKeybinds), [_display]];
ECOB(Editor,Core) call [F(SetCurrentDisplay), [_display]];
ECOB(Editor,Core) call [F(ShowTotals), []];

// -- Event handlers
(_display displayCtrl IDC_leftTabContent) ctrlAddEventHandler ["LBSelChanged", {
	// params ["_ctrl", "_idx"];
	[{ ThisCOB call [F(onTabSwitch), [true, _this]]; }, _this] call CBA_fnc_execNextFrame;
}];

(_display displayCtrl IDC_rightTabContent) ctrlAddEventHandler ["LBSelChanged", {
	// params ["_ctrl", "_idx"];
	[{ ThisCOB call [F(onTabSwitch), [false, _this]]; }, _this] call CBA_fnc_execNextFrame;
}];
/*
["ace_arsenal_leftPanelFilled", {
	// params ["_display"];
	DBG_ "On Left Panel Filled" EOL;
}] call CBA_fnc_addEventHandler;
["ace_arsenal_rightPanelFilled", {
	// params ["_display"];
	DBG_ "On Right Panel Filled" EOL;
}] call CBA_fnc_addEventHandler;
*/

// TBD - get selected item class
/*
(_display displayCtrl IDC_rightTabContentListnBox) ctrlAddEventHandler ["LBSelChanged", {
	params ["_ctrl", "_idx"];
	if (ThisCOB get Q(SkipSelChangeEvent)) exitWith {};
	ThisCOB set [Q(CurrentCategory), ace_arsenal_currentRightPanel];
	ThisCOB set [Q(CurrentItemSelected), _ctrl lbData _idx];

	DBG_
		"On Right Tab Listbox content selected: %1. PoolId: %2, Item: %3",
		_this,
		ThisCOB get  Q(CurrentCategory),
		ThisCOB get Q(CurrentItemSelected)
	EOL;
}];
*/

// -- Render buttons
#define BTN_FORMAT "<t align='center' size='2'>%1</t>"
#define _POS(Y) [-0.02, Y, 0.1, 0.1]

[
	"ADD", _display, BTN_SHOW, [
		"BUTTON",
		format [BTN_FORMAT, "O"],
		{ ThisCOB call [F(onShowButtonClick), [true]]; }, [],
		[["pos", _POS(0.32)], ["tooltip", "Show item pool"]]
    ]
] call dzn_fnc_HandleControl;

[
	"ADD", _display, BTN_ADD, [
		"BUTTON",
		format [BTN_FORMAT, "+"],
		{ ThisCOB call [F(onAddButtonClick), [true]]; }, [],
		[["pos", _POS(0.42)], ["tooltip", "Adds item to pool!"]]
    ]
] call dzn_fnc_HandleControl;

[
	"ADD", _display, BTN_RESET, [
		"BUTTON",
		format [BTN_FORMAT, "X"],
		{ ThisCOB call [F(onResetButtonClick), [true]]; }, [],
		[["pos", _POS(0.52)], ["tooltip", "Reset item pool!"]]
    ]
] call dzn_fnc_HandleControl;


// -- Sub category buttons
#define _POS(Y) [0.92, Y, 0.1, 0.1]
[
	"ADD", _display, BTN_SUB_SHOW, [
		"BUTTON",
		format [BTN_FORMAT, "O"],
		{ ThisCOB call [F(onShowButtonClick), [false]]; }, [],
		[["pos", _POS(0.32)], ["tooltip", "Show sub-category item pool"]]
    ]
] call dzn_fnc_HandleControl;

[
	"ADD", _display, BTN_SUB_ADD, [
		"BUTTON",
		format [BTN_FORMAT, "+"],
		{ ThisCOB call [F(onAddButtonClick), [false]]; }, [],
		[["pos", _POS(0.42)], ["tooltip", "Adds sub-category item to pool"]]
    ]
] call dzn_fnc_HandleControl;

[
	"ADD", _display, BTN_SUB_RESET, [
		"BUTTON",
		format [BTN_FORMAT, "X"],
		{ ThisCOB call [F(onResetButtonClick), [false]]; }, [],
		[["pos", _POS(0.52)], ["tooltip", "Reset sub-category items pool!"]]
    ]
] call dzn_fnc_HandleControl;

