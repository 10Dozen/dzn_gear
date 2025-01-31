#include "defines.h"

params [["_paginationDirection", 0]];

private _targetPageIdx = _self get Q(PageIdx) + _paginationDirection;
private _maxIdx = count (_self get Q(Pages)) - 1;
private _getInRangeIndex = {
	params ["_idx"];
	[
		[_idx, 0] select (_idx > _maxIdx),
		_maxIdx
	] select (_idx < 0)
};

_self set [Q(PageIdx), [_targetPageIdx] call _getInRangeIndex];

private _targetPage = (_self get Q(Pages)) # (_self get Q(PageIdx));
private _prevPage =  (_self get Q(Pages)) # ([_self get Q(PageIdx) - 1] call _getInRangeIndex);
private _nextPage =  (_self get Q(Pages)) # ([_self get Q(PageIdx) + 1] call _getInRangeIndex);

private _menu = [
	["HEADER", "dzn_Gear Menu"],
	[
		"BUTTON",
		"<t align='center'>&lt;</t>",
		{
			params ["_ad"];
            ThisCOB call [F(HandleMenu), [-1]];
		}, [],
		[["w", 0.25], ["size", 0.05], ["tooltip", _prevPage get "title"]]
	],
	[
		"LABEL",
		format ["<t align='center'>%1</t>", _targetPage get "title"],
		[
			["bg", [0,0,0,1]],
			["size", 0.05],
			["tooltip", _targetPage get "description"]
		]
	],
	[
		"BUTTON",
		"<t align='center'>&gt;</t>",
		{
			params ["_ad"];
            ThisCOB call [F(HandleMenu), [+1]];
		}, [],
		[["w", 0.25], ["size", 0.05], ["tooltip", _nextPage get "title"]]
	],
	["BR"]
];

_self call [(_targetPage get "renderer"), [_menu]];