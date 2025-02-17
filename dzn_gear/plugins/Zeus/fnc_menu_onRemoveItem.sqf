#include "defines.h"

DBG_ "Params: %1", _this EOL;
params ["_ad", "_args"];
_args params ["_units"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);

if (!_applyToUnits || _units isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

(_ad call ["GetValueByTag", "d_item"]) params ["", "_itemData"];
_itemData params ["", "_onRemoveCode", "", "_onRemoveMessage"];

private _successCount = 0;
{
    private _isSuccess = [_x] call _onRemoveCode;
    _successCount = _successCount + ([0,1] select _isSuccess);
} forEach _units;

_self call [F(notify), [NOTIF_INFO, format [_onRemoveMessage, _successCount, count _units]];