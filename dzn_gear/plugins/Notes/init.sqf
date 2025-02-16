#include "defines.h"

params ["_pluginSettings"];

ThisCOB = [] call compileScript ['COMPONENT_PATH\Component.sqf'];

[
    "dzn_gear_kitApplied",
    {
        diag_log "On Kit applied event!";
        ThisCOB call [F(AddNotes), []];
    }
] call CBA_fnc_addEventHandler;
