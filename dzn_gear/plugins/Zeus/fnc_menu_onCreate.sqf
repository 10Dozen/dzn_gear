#include "defines.h"

DBG_ "Params: %1", _this EOL;

params ["_ad", "_args"];
_args params ["_units", "_objects"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);
private _applyToObjects = GET_OBJECTS_BUTTON_STATE(_ad);

if (!_applyToUnits && !_applyToObjects) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

_self call [F(saveKit), [
    [[], _units] select _applyToUnits,
    [[], _objects] select _applyToObjects
]];

_self call [F(openMenu), [_units, _objects]];