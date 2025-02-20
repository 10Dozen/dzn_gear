#include "defines.h"

DBG_ "Params: %1", _this EOL;
params [
    ["_units", []],
    ["_objects", []]
];

private _hasUnits = _units isNotEqualTo [];
if (!_hasUnits && _objects isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

if (_hasUnits) exitWith {
    {
        [_x, _self get Q(LastPersonalGear)] remoteExec ["dzn_fnc_gear_assignGear", _x];
    } forEach (_units + (_objects apply { crew _x }));
    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_PERSONAL_GEAR_APPLIED]];
};

{
    [_x, _self get Q(LastCargoGear)] remoteExec ["dzn_fnc_gear_assignCargoGear", _x];
} forEach _objects;
_self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_GEAR_APPLIED]];