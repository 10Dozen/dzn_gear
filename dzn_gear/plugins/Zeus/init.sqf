#include "defines.h"

params ["_pluginSettings"];

ThisCOB = [] call compileScript ['COMPONENT_PATH\Component.sqf'];

// -- Init keybingdings
[] call compileScript ['COMPONENT_PATH\addKeybinding.sqf'];

[
    { !isNull (findDisplay 46) && (getAssignedCuratorLogic player) isNotEqualTo objNull },
    {
        // -- Set Zeus display on key pressed
        ThisCOB set [
            Q(ZeusOpenedEH),
            addUserActionEventHandler ["curatorInterface", "Activate", {
                [
                    { !isNull (findDisplay 312) },
                    { ThisCOB set [Q(ZeusDisplay), findDisplay 312] }
                ] call CBA_fnc_waitUntilAndExecute;
            }]
        ];

        // -- Add Event Handlers to Zeus
        ThisCOB set [
            Q(ZeusSelectionEH),
            (getAssignedCuratorLogic player) addEventHandler [
                "CuratorObjectSelectionChanged",
                { ["dzn_gear_zeusSelectionChanged"] call CBA_fnc_localEvent; }
            ]
        ];
    }
] call CBA_fnc_waitUntilAndExecute;
