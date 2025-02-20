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

{
    private _unit = _x;
    clearBackpackCargoGlobal _unit;
    {_unit removeItemFromVest _x;} forEach (vestItems _unit);
    {_unit removeItemFromUniform _x;} forEach (uniformItems _unit);
} forEach _allUnits;

{
    clearWeaponCargoGlobal _x;
    clearMagazineCargoGlobal _x;
    clearBackpackCargoGlobal _x;
    clearItemCargoGlobal _x;
} forEach _objects;

_self call [F(notify), [NOTIF_OK, NOTIF_MSG_CARGO_CLEARED]];