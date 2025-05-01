#include "defines.h"

DBG_1("Params: %1", _this);
params ["_ad"];

(_self get Q(MenuFilters)) params ["_applyToUnits", "_applyToCrew", "_applyToObjects"];
(_self get Q(ZeusLastSelected)) params ["_units", "_crew", "_objects"];

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);
_objects = [[], _objects] select _applyToObjects;

if (_allUnits isEqualTo [] && _objects isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

_self call [F(applyGear), [_allUnits, _objects]];
