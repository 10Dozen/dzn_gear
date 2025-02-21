#include "defines.h"

params ["_pluginSettings"];

ThisCOB = [_pluginSettings] call compileScript ['COMPONENT_PATH\Component.sqf'];

[
    "dzn_gear_kitApplied",
    {
        params ["_unit"];
        if (_unit isNotEqualTo player) exitWith {};
        if (ThisCOB get Q(Settings) get "Personal" get "enable") then {
            ThisCOB call [F(AddNotes), []];
        };
        if !(ThisCOB get Q(RefreshGroupNotes)) exitWith {};
        [
            {
                params ["_pfhID", "_self"];
                private _group = units group player;
                if ({ (_x getVariable [Q(dzn_gear_Note), []]) isNotEqualTo [] } count _group != count _group) exitWith {};

                _self call [F(AddGroupNotes), [_group]];

                if (CBA_missionTime > (_self get Q(Settings) get "Group" get "refreshUntil")) then {
                    _pfhID call CBA_fnc_removePerFrameHandler;
                    ThisCOB set [Q(RefreshGroupNotes), false];
                };
            },
            ThisCOB,
            ThisCOB get Q(Settings) get "Group" get "refreshTime"
        ] call CBA_fnc_addPerFrameHandler;
    }
] call CBA_fnc_addEventHandler;
