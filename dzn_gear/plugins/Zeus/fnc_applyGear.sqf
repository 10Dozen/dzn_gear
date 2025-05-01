#include "defines.h"

/*
    Applies previously copied gear to units or vehicles.
    If units are selected - only personal kit is applied.
    If no units selected - apply cargo kit to objects.
*/
DBG_1("Params: %1", _this);

params ["_units", "_objects"];
if (_this isEqualTo []) then {
    private _sel = (_self call [F(getSelected), [true, false, true]]);
    _units = _sel # 0;
    _objects = _sel # 2;
};

private _hasUnits = _units isNotEqualTo [];

if (!_hasUnits && _objects isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

if (_hasUnits) exitWith {
    {
        [_x, _self get Q(LastPersonalGear)] remoteExec ["dzn_fnc_gear_assignGear", _x];
    } forEach _units;
    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_PERSONAL_GEAR_APPLIED]];
};

{
    [_x, _self get Q(LastCargoGear)] call dzn_fnc_gear_assignCargoGear;
} forEach _objects;
_self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_GEAR_APPLIED]];
