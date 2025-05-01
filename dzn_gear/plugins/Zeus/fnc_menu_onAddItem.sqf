#include "defines.h"

DBG_1("Params: %1", _this);
params ["_ad"];

(_self get Q(MenuFilters)) params ["_applyToUnits", "_applyToCrew"];
(_self get Q(ZeusLastSelected)) params ["_units", "_crew"];

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);

if (_allUnits isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

(_ad call ["GetValueByTag", DP_ITEM]) params ["", "", "_itemData"];
DBG_2("_itemData: %1", _itemData, _onAddMessage);
_itemData params ["_onAddCode", "", "_onAddMessage"];

DBG_2("Going to execute: %1, _msg=%2", _onAddCode, _onAddMessage);

private _successCount = 0;

{
    private _isSuccess = _x call _onAddCode;
    DBG_2("_unit: %1, _isSuccess: %2", _x, _isSuccess);
    _successCount = _successCount + ([0,1] select _isSuccess);
} forEach _allUnits;

_self call [F(notify), [
    [NOTIF_INFO, NOTIF_OK] select (_successCount > 0),
    _onAddMessage,
    [_successCount, count _allUnits]]
];
