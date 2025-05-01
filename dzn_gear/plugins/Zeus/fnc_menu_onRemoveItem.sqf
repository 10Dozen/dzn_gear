#include "defines.h"

DBG_1("Params: %1", _this);
params ["_ad"];

(_self get Q(MenuFilters)) params ["_applyToUnits", "_applyToCrew", "_applyToObjects"];
(_self get Q(ZeusLastSelected)) params ["_units", "_crew", "_objects"];

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);

if (_allUnits isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

(_ad call ["GetValueByTag", DP_ITEM]) params ["", "", "_itemData"];
_itemData params ["", "_onRemoveCode", "", "_onRemoveMessage"];

private _successCount = 0;
{
    private _isSuccess = _x call _onRemoveCode;
    _successCount = _successCount + ([0,1] select _isSuccess);
} forEach _allUnits;

_self call [F(notify), [
    [NOTIF_INFO, NOTIF_OK] select (_successCount > 0),
    _onRemoveMessage,
    [_successCount, count _allUnits]]
];
