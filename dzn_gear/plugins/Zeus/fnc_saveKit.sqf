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

private _idx = 1 + (_self get Q(GenerationIndex));
_self set [Q(GenerationIndex), _idx];

if (_unitCount > 0) exitWith {
    private _unit = _units # 0;
    private _gear = _unit call dzn_fnc_gear_getGear;
    private _kitname = format [
        "kit_%1_%2_%3",
        str(side _unit),
        [_gear # 1 # 1, _gear # 2 # 1, _gear # 0 # 1, "generated"] select { _x != "" } select 0,
        _idx
    ];

    missionNamespace setVariable [_kitname, _gear];
    dzn_gear_personalKits pushBack _kitname;

    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_PERSONAL_GEAR_SAVED]];
};

private _obj = _objects # 0;
private _gear = _obj call dzn_fnc_gear_getCargoGear;
private _kitname = format [
    "cargo_kit_%1_%2",
    typeOf _obj,
    _idx
];

missionNamespace setVariable [_kitname, _gear];
dzn_gear_cargoKits pushBack _kitname;

_self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_GEAR_SAVED]];
