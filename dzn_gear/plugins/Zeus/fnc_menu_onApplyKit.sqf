#include "defines.h"

// TODO: Add messages!!!

DBG_ "Params: %1", _this EOL;

params ["_ad"];

(_self get Q(MenuFilters)) params ["_applyToUnits", "_applyToCrew", "_applyToObjects"];
(_self get Q(ZeusLastSelected)) params ["_units", "_crew", "_objects"];

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);
_objects = [[], _objects] select _applyToObjects;

if (_allUnits isEqualTo [] && _objects isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

// -- Select kitname from input or dropdown
private _kitname = _ad call ["GetValueByTag", INP_KITNAME];
if (_kitname isEqualTo "") then {
    DBG_ "Pick from dropdown _kitname: %1", _kitname EOL;
    _kitname = (_ad call ["GetValueByTag", DP_KITNAME]) select 1;
};

DBG_ "Final _kitname: %1", _kitname EOL;

// -- Apply personal
if (STARTS_WITH(_kitname,"kit_")) exitWith {
    DBG_ "Is personal kit & _applyToUnits=%1", _applyToUnits EOL;
    if (_allUnits isEqualTo []) exitWith {
        DBG_ "No ApplyToUnits select. Skip." EOL;
        _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NO_UNIT_SELECTED]];
    };

    {
        DBG_ "Apply personal kit to = %1", _x EOL;
        [_x, _kitname] call dzn_fnc_gear_assignKit;
    } forEach _allUnits;

    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_PERSONAL_GEAR_APPLIED]];
};

// -- Apply cargo
if (STARTS_WITH(_kitname,"cargo_kit_")) exitWith {
    DBG_ "Is cargo kit & _applyToObjects=%1", _applyToObjects EOL;

    if (_objects isEqualTo []) exitWith {
        DBG_ "No ApplyToObjects select. Skip." EOL;
        _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NO_VEHICLE_SELECTED]];
    };
    {
        DBG_ "Apply cargo kit to = %1", _x EOL;
        [_x, _kitname, true] call dzn_fnc_gear_assignKit;
    } forEach _objects;

    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_GEAR_APPLIED]];
};

// -- Cannot determine what kit is... Let user decide
if (_allUnits isNotEqualTo []) exitWith {
    { [_x, _kitname] call dzn_fnc_gear_assignKit; } forEach _allUnits;
    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_PERSONAL_GEAR_APPLIED]];
};
if (_objects isNotEqualTo []) exitWith {
    { [_x, _kitname, true] call dzn_fnc_gear_assignKit; } forEach _objects;
    _self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_GEAR_APPLIED]];
};