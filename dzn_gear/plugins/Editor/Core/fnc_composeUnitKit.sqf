#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_composeUnitKit"

params [
    "_title",
    "_name",
    "_colorString",
    "_kit",
    ["_overrideAssignedItems", NO_OVERRIDE],
    ["_overrideUniformItems", NO_OVERRIDE]
];

// -- Save kit to namespace
missionNamespace setVariable [_name, _kit call dzn_fnc_gear_make];

// -- Action
player addAction [
    format [
        "<t color='%3'>%1 (at %2)</t>",
        _name,
        [time/3600, "HH:MM:SS"] call BIS_fnc_timeToString,
        _color
    ],
    {
        params ["", "", "", "_kitArg"];
        if (isNull cursorTarget) exitWith {
            [player, _kitArg] call dzn_fnc_gear_assignGear;
        };
        if (cursorTarget isKindOf "CAManBase") then {
            [cursorTarget, _kitArg] call dzn_fnc_gear_assignGear;
        };
    },
    +_kit ,0
];

// -- Items override
DBG_ "Override assigned items = %1", _overrideAssignedItems EOL;
DBG_ "Override assigned items = %1", _self get Q(Settings) get "AssignedItemsOverride" get _overrideAssignedItems EOL;
if (_overrideAssignedItems != NO_OVERRIDE) then {
    _kit set [4, _self get Q(Settings) get "AssignedItemsOverride" get _overrideAssignedItems]
};

DBG_ "Override assigned items = %1", _overrideUniformItems EOL;
DBG_ "Override assigned items = %1", _self get Q(Settings) get "UniformItemsOverride" get _overrideUniformItems EOL;
if (_overrideUniformItems != NO_OVERRIDE) then {
    _kit set [5, _self get Q(Settings) get "UniformItemsOverride" get _overrideUniformItems]
};

// -- Format and copy

DBG_ "Going to execute FormatKit" EOL;
private _formatted = _self call [F(FormatKit), [_kit, _name, true]];
copyToClipboard _formatted;

// -- History and notification
ECOB(Editor,History) call [F(Add), [HISTORY_PERSONAL_KIT, _name, _formatted]];
_self call [F(Notify), [NOTIF_KIT_COPIED, [_title, _colorString]]];
