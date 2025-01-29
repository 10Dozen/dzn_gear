#include "defines.h"
#define DBG_FUNC_PREFIX "onShowButtonClick"

params [];

private _display = _self get Q(Display);
private _category = _self get Q(CurrentItemPoolId);
(_self get Q(Categories) getOrDefault [_category, []]) params [
	["_categoryTitle", str(_category)],
	["_categoryItemCfgFunc", {}]
];

private _items = _self get Q(ItemPools) getOrDefault [_category, []];
private _itemsShare = [];
private _totalCount = count _items;


private _menu = [
	["DIALOG", [["dialog", _display],["w", 0.6],["x", 0.2],["dialogShowTime", 0]]],
	["HEADER", format ["%1 (%2 items)", _categoryTitle, _totalCount]]
];


// -- Plain list items to format of 33% Itemname
{
	DBG_ "%1", _x EOL;
	_x params ["_classname", "_count"];
	_itemsShare pushBack [
		_classname,
		_count,
		format [
			"%1 %2",
			str([_count / _totalCount * 100, 0] call BIS_fnc_cutDecimals) + "%",
			[
				getText ((_classname call _categoryItemCfgFunc) >> "displayName"),
				"&lt; no item &gt;"
			] select (_classname == "")
		]
	];
} forEach (_items call BIS_fnc_consolidateArray);


DBG_ "Composing menu" EOL;
{
	DBG_ "%1", _x EOL;
	_x params ["_classname", "_count", "_itemTitle"];
	_menu pushBack ["LABEL", _itemTitle, [
		["w", 0.8],
		["tooltip", "KEke lol"]
	]];
	_menu pushBack ["BUTTON", "<t align='center'>+</t>", {
		params ["_dialogCOB", "_args"];
		ThisCOB call [F(addItemToPool), _args];
		ThisCOB call [F(onShowButtonClick), []];

	}, [_category, _classname]];
	_menu pushBack ["BUTTON",
		"<t align='center'>-</t>",
		{
			params ["_dialogCOB", "_args"];
			ThisCOB call [F(removeItemFromPool), _args];
			ThisCOB call [F(onShowButtonClick), []];
		},
		[_category, _classname],
		[["bg", [[0.7, 0.2, 0.2, 1], [0,0,0,1]] select (_count > 1)]]
	];
	_menu pushBack ["BR"];
} forEach _itemsShare;
/*
 _this # 0 - dzn_AdvDialog2 component object to provide useful methods;
            _this # 1 - passed args;
            _this # 2 - button control;
			*/

if (_items isEqualTo []) then {
	_menu pushBack ["LABEL"];
} else {
	_menu pushBack ["LABEL", ""];
	_menu pushBack ["BR"];
	_menu pushBack ["LABEL", ""];
	_menu pushBack ["BUTTON", "Copy", {}, [], [["w",0.25]]];
};
_menu call dzn_fnc_ShowAdvDialog2;