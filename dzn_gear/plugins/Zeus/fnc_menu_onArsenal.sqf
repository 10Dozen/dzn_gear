#include "defines.h"

DBG_ "Params: %1", _this EOL;

params ["_ad", "_args"];
_args params ["_units", "_crew"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);
private _applyToCrew = GET_CREW_BUTTON_STATE(_ad);

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);

if (_allUnits isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

[_allUnits # 0, _allUnits # 0, true] call ace_arsenal_fnc_openBox;

