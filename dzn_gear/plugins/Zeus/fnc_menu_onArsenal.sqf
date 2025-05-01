#include "defines.h"

DBG_1("Params: %1", _this);

params ["_ad"];

(_self get Q(MenuFilters)) params ["_applyToUnits", "_applyToCrew"];
(_self get Q(ZeusLastSelected)) params ["_units", "_crew"];

private _allUnits = [] + ([[], _units] select _applyToUnits) + ([[], _crew] select _applyToCrew);

if (_allUnits isEqualTo []) exitWith {
    _self call [F(notify), [NOTIF_FAIL, NOTIF_MSG_NOT_SELECTED]];
};

_ad call ["Close", []];

[_allUnits # 0, _allUnits # 0, true] call ace_arsenal_fnc_openBox;
