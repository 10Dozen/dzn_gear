#include "defines.h"

params ["_pluginSettings"];

ThisCOB = [] call compileScript ['COMPONENT_PATH\Component.sqf'];

[
    { !isNull (findDisplay 46) && (getAssignedCuratorLogic player) isNotEqualTo [] },
    {
        addUserActionEventHandler ["curatorInterface", "Activate", {
            [
                { !isNull (findDisplay 312) },
                { ThisCOB set [Q(ZeusDisplay), findDisplay 312] }
            ] call CBA_fnc_waitUntilAndExecute;

            ThisCOB set [Q(ZeusSelectionEH), (getAssignedCuratorLogic player) addEventHandler [
                "CuratorObjectSelectionChanged",
                {
                    DBG_ "Emitting 'dzn_gear_zeusSelectionChanged' event" EOL;
                    ["dzn_gear_zeusSelectionChanged"] call CBA_fnc_localEvent;
                }
            ]];
        }];
    }
] call CBA_fnc_waitUntilAndExecute;
