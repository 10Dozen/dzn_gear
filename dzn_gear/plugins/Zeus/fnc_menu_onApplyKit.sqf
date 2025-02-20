#include "defines.h"

// TODO: Add messages!!!

DBG_ "Params: %1", _this EOL;

params ["_ad", "_args"];
_args params ["_units", "_objects"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);
private _applyToObjects = GET_OBJECTS_BUTTON_STATE(_ad);

if (!_applyToUnits && !_applyToObjects) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

// -- Select kitname from input or dropdown
private _kitname = _ad call ["GetValueByTag", "i_kitname"];
if (_kitname isEqualTo "") then {
    DBG_ "Pick from dropdown _kitname: %1", _kitname EOL;
    _kitname = (_ad call ["GetValueByTag", "d_kitname"]) select 1;
};

DBG_ "Final _kitname: %1", _kitname EOL;

// -- Apply personal
if (STARTS_WITH(_kitname,"kit_")) exitWith {
    DBG_ "Is personal kit & _applyToUnits=%1", _applyToUnits EOL;
    if (!_applyToUnits) exitWith {
        DBG_ "No ApplyToUnits select. Skip." EOL;
        hint "Select unit to apply personal kit"; // TBD
    };
    {
        DBG_ "Apply personal kit to = %1", _x EOL;
        [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x];
    } forEach _units;
};

// -- Apply cargo
if (STARTS_WITH(_kitname,"cargo_kit_")) exitWith {
    DBG_ "Is cargo kit & _applyToObjects=%1", _applyToObjects EOL;

    if (!_applyToObjects) exitWith {
        DBG_ "No ApplyToObjects select. Skip." EOL;
        hint "Select vehicle to apply cargo kit"; // TBD
    };
    {
        DBG_ "Apply cargo kit to = %1", _x EOL;
        [_x, _kitname, true] call dzn_fnc_gear_assignKit;
    } forEach _objects;
};

// -- Cannot determine what kit is... Let user decide
if (_applyToUnits) exitWith {
    { [_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x]; } forEach _units;
};
{ [_x, _kitname, true] call dzn_fnc_gear_assignKit; } forEach _objects;