#include "defines.h"

params ["_pluginSettings"];

ThisCOB = [] call compileScript ['COMPONENT_PATH\Component.sqf'];

[
    { !isNull (findDisplay 46) },
    {
        (findDisplay 46) displayAddEventHandler ["KeyDown", {
            systemChat format ["Key down. %1", inputAction "CuratorInterface" ];
            if (inputAction "CuratorInterface" <= 0) exitWith { false };
            [
                { !isNull (findDisplay 312) },
                { ThisCOB set [Q(ZeusDisplay), findDisplay 312]}
            ] call CBA_fnc_waitUntilAndExecute;
            false
        }];
    }
] call CBA_fnc_waitUntilAndExecute;
