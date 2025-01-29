#include "defines.h"

params ["_pluginSettings"];

[_pluginSettings] call compileScript ["dzn_gear\plugins\Editor\initComponents.sqf"];

[
    { !isNull findDisplay 46 && time > 0},
    { dzn_gear_ArsenalComponent call [F(initEvents)]; }
] call CBA_fnc_waitUntilAndExecute;