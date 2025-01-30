#include "defines.h"
#define DBG_FUNC_PREFIX "onArsenalOpened"

params ["_display"];
_self set [Q(Display), _display];

["RESET", _display] call dzn_fnc_HandleControl;

// -- Buttons
#define BTN_FORMAT "<t align='center' size=2>%1</t>"
private _showBtn = [
	"ADD", _display, "btnCategoryShow", [
		"BUTTON",
		format [BTN_FORMAT, "S"],
		{ ThisCOB call [F(onShowButtonClick), []]; }, [],
		[["pos", [0, 0.2, 0.1, 0.1]], ["tooltip", "Show item pool"]]
    ]
] call dzn_fnc_HandleControl;

private _addBtn = [
	"ADD", _display, "btnCategoryAdd", [
		"BUTTON",
		format [BTN_FORMAT, "+"],
		{ ThisCOB call [F(onAddButtonClick), []]; }, [],
		[["pos", [0, 0.3, 0.1, 0.1]], ["tooltip", "Adds item to pool!"]]
    ]
] call dzn_fnc_HandleControl;

private _resetBtn = [
	"ADD", _display, "btnCategoryReset", [
		"BUTTON",
		format [BTN_FORMAT, "R"],
		{ ThisCOB call [F(onResetButtonClick), []]; }, [],
		[["pos", [0, 0.4, 0.1, 0.1]], ["tooltip", "Reset item pool!"]]
    ]
] call dzn_fnc_HandleControl;

private _exportBtn = [
	"ADD", _display, "btnCategoryExport", [
		"BUTTON",
		format [BTN_FORMAT, "E"],
		{ ThisCOB call [F(onExportButtonClick), []]; }, [],
		[["pos", [0, 0.5, 0.1, 0.1]], ["tooltip", "Export item pool!"]]
    ]
] call dzn_fnc_HandleControl;

// -- Event handlers
(_display displayCtrl IDC_leftTabContent) ctrlAddEventHandler ["LBSelChanged", {
	params ["_ctrl", "_idx"];
	ThisCOB set [Q(CurrentItemPoolId), ace_arsenal_currentLeftPanel];
	ThisCOB set [Q(CurrentItemSelected), _ctrl lbData _idx];
	ThisCOB set [Q(SkipSelChangeEvent), true];
	[{ ThisCOB set [Q(SkipSelChangeEvent), false]; }] call CBA_fnc_execNextFrame;
}];

(_display displayCtrl IDC_rightTabContent) ctrlAddEventHandler ["LBSelChanged", {
	params ["_ctrl", "_idx"];
	if (ThisCOB get Q(SkipSelChangeEvent)) exitWith {};
	ThisCOB set [Q(CurrentItemPoolId), ace_arsenal_currentRightPanel];
	ThisCOB set [Q(CurrentItemSelected), _ctrl lbData _idx];

	DBG_
		"On Right Tab content selected: PoolId: %1, Item: %2",
		ThisCOB get  Q(CurrentItemPoolId),
		ThisCOB get Q(CurrentItemSelected)
	EOL;
}];

// TBD - get selected item class
(_display displayCtrl IDC_rightTabContentListnBox) ctrlAddEventHandler ["LBSelChanged", {
	params ["_ctrl", "_idx"];
	if (ThisCOB get Q(SkipSelChangeEvent)) exitWith {};
	ThisCOB set [Q(CurrentItemPoolId), ace_arsenal_currentRightPanel];
	ThisCOB set [Q(CurrentItemSelected), _ctrl lbData _idx];

	DBG_
		"On Right Tab Listbox content selected: %1. PoolId: %2, Item: %3",
		_this,
		ThisCOB get  Q(CurrentItemPoolId),
		ThisCOB get Q(CurrentItemSelected)
	EOL;
}];