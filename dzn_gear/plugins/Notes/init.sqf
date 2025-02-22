#include "defines.h"

params ["_pluginSettings"];

ThisCOB = [_pluginSettings] call compileScript ['COMPONENT_PATH\Component.sqf'];

[
    "dzn_gear_kitApplied",
    {
        params ["_unit"];
        if (_unit isNotEqualTo player) exitWith {};

        private _loadout = getUnitLoadout player;
        _loadout pushBack loadAbs player;
        player setVariable [Q(dzn_gear_Note), _loadout, true];

        if (ThisCOB get Q(Settings) get Q(Personal) get Q(enable)) then {
            ThisCOB call [F(AddNotes), []];
        };
        if !(ThisCOB get Q(RefreshGroupNotes)) exitWith {};

        // -- Start group info loop - scan for all group memebers to finalize their equip, then create topic
        //    Stop loop once Group.refreshUntil timer reached.
        [
            {
                params ["_self", "_pfhID"];
                private _group = units group player;
                if (
                    _self get Q(MemberInfoShown) ||
                    {
                        (_x getVariable [Q(dzn_gear_Note), []]) isNotEqualTo []
                    } count _group != count _group
                ) exitWith {};

                _self call [F(AddGroupNotes), [_group]];

                if (CBA_missionTime > (_self get Q(Settings) get Q(Group) get Q(refreshUntil))) then {
                    _pfhID call CBA_fnc_removePerFrameHandler;
                    ThisCOB set [Q(RefreshGroupNotes), false];
                };
            },
            ThisCOB get Q(Settings) get Q(Group) get Q(refreshTime),
            ThisCOB
        ] call CBA_fnc_addPerFrameHandler;
    }
] call CBA_fnc_addEventHandler;
