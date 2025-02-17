#include "defines.h"

params ["_pluginSettings"];

ThisCOB = [] call compileScript ['COMPONENT_PATH\Component.sqf'];

[
    "dzn_gear_kitApplied",
    {
        params ["_unit"];
        if (_unit isNotEqualTo player) exitWith {};
        ThisCOB call [F(AddNotes), []];
    }
] call CBA_fnc_addEventHandler;
