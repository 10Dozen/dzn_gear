#include "defines.h"

DBG_ "Params: %1", _this EOL;

params ["_units", "_objects"];

if (_this isEqualTo []) then {
    private _sel = (_self call [F(getSelected), [true, false, true]]);
    _units = _sel # 0;
    _objects = _sel # 2;

    DBG_ "Read current selections: _units: %1, _objects=%2", _units, _objects EOL;
};

private _unitsCount = count _units;
private _objectsCount = count _objects;

DBG_ "_unitCount: %1, _units=%2", _unitsCount, _units EOL;
DBG_ "_objectsCount: %1, _objects=%2", _objectsCount, _objects EOL;

// -- Only 1 unit or vehicle is selected
if (_unitsCount == 0 && _objectsCount == 0) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

if ((_unitsCount > 1 && _objectsCount > 0) || (_unitsCount > 0 && _objectsCount > 1)) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_TOO_MUCH_SELECTED]];
};


DBG_ "_unitCount > 0: %1", _unitsCount > 0 EOL;
if (_unitsCount > 0) exitWith {
    DBG_ "Going to get gear of first unit: %1", (_units # 0) EOL;
    DBG_ "Gear: %1", (_units # 0) call dzn_fnc_gear_getGear EOL;
    _self set [
        Q(LastPersonalGear),
        ((_units # 0) call dzn_fnc_gear_getGear) call dzn_fnc_gear_make
    ];
    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_PERSONAL_GEAR_COPIED]];
};

DBG_ "Going to get cargo gear of vehicle unit: %1", (_objects # 0) EOL;
_self set [Q(LastCargoGear), (_objects # 0) call dzn_fnc_gear_getCargoGear];
_self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_GEAR_COPIED]];
