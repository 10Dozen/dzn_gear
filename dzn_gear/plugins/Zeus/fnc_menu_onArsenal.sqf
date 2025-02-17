#include "defines.h"

DBG_ "Params: %1", _this EOL;

params ["_ad", "_args"];
_args params ["_units"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);
if (!_applyToUnits || _units isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

[_units # 0, _units # 0, true] call ace_arsenal_fnc_openBox;

