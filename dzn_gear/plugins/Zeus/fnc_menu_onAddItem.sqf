#include "defines.h"

DBG_ "Params: %1", _this EOL;
params ["_ad", "_args"];
_args params ["_units", "_crew"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);
private _applyToCrew = GET_CREW_BUTTON_STATE(_ad);

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);

if (_allUnits isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

(_ad call ["GetValueByTag", "d_item"]) params ["", "_itemData"];
_itemData params ["_onAddCode", "", "_onAddMessage"];

private _successCount = 0;

{
    private _isSuccess = [_x] call _onAddCode;
    _successCount = _successCount + ([0,1] select _isSuccess);
} forEach _allUnits;

_self call [F(notify), [NOTIF_INFO, format [_onAddMessage, _successCount, count _allUnits]]];