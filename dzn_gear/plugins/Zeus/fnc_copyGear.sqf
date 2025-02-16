#include "defines.h"

DBG_ "Params: %1", _this EOL;
params [
    ["_units", []],
    ["_objects", []]
];

private _unitsCount = count _units;
private _objectsCount = count _objects;
if (_unitsCount == 0 && _objectsCount == 0) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

if (_unitsCount > 1 || _objectsCount > 1) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_TOO_MUCH_SELECTED]];
};

if (_unitCount > 0) exitWith {
    _self set [Q(LastPersonalGear), (_units # 0) call dzn_fnc_gear_getGear];
    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_PERSONAL_GEAR_COPIED]];
};

_self set [Q(LastCargoGear), (_objects # 0) call dzn_fnc_gear_getCargoGear];
_self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_GEAR_COPIED]];
