#include "defines.h"

DBG_ "Params: %1", _this EOL;
params ["_ad", "_args"];
_args params ["_units", "_crew", "_objects"];

private _applyToUnits = GET_UNITS_BUTTON_STATE(_ad);
private _applyToCrew = GET_CREW_BUTTON_STATE(_ad);
private _applyToObjects = GET_OBJECTS_BUTTON_STATE(_ad);

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);
_objects = [[], _objects] select _applyToObjects;

if (_allUnits isEqualTo [] && _objects isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

_self call [F(copyKit), [_allUnits, _objects]];