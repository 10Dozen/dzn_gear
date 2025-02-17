#include "defines.h"

DBG_ "Params: %1", _this EOL;

params ["_ad", "_args"];
_args params ["_units", "_objects"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);
private _applyToObjects = GET_OBJECTS_BUTTON_STATE(_ad);

if (!_applyToUnits && !_applyToObjects) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

private _kitname = _ad call ["GetValueByTag", "i_kitname"];
if (_kitname isEqualTo "") then {
    _kitname = _ad call ["GetValueByTag", "d_kitname"];
};

if (STARTS_WITH(_kitname,"cargo_kit_")) exitWith {
    if (!_applyToObjects) exitWith {
        hint "Select vehicle to apply cargo kit"; // TBD
    };
    { [_x, _kitname, true] call dzn_fnc_gear_assignKit; } forEach _objects;
};

if (STARTS_WITH(_kitname,"kit_")) exitWith {
    { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach _units;
    {
        { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach (crew _x);
    } forEach _objects;
};

// -- Cannot determine what kit is... Let user decide
if (_applyToUnits) exitWith {
    { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach _units;
    {
        { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach (crew _x);
    } forEach _objects;
};

{ [_x, _kitname, true] call dzn_fnc_gear_assignKit; } forEach _objects;