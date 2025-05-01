#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_composeUnitKit"

params [
    "_title",
    "_nameAndRoleDesc",
    "_colorString",
    "_gearArr",
    ["_overrideAssignedItems", NO_OVERRIDE],
    ["_overrideUniformItems", NO_OVERRIDE]
];

forceUnicode 0;

_nameAndRoleDesc params ["_name", "_roleDesc"];
_roleDesc params [
    ["_roleTitle", ""],
    "", //["_roleSuffix", ""],
    ["_roleTags", []]
];

// -- Update gear array
if (_roleTitle isNotEqualTo "") then {
    _gearArr pushBack [format ["<%1 >> ", ARR_GEAR_DESC], _roleTitle];
};
if (_roleTags isNotEqualTo []) then {
    _gearArr pushBack ([format ["<%1 >> ", ARR_GEAR_TAGS]] + _roleTags);
};


// -- Save kit to namespace
private _gearMap = _gearArr call dzn_fnc_gear_make;
missionNamespace setVariable [_name, _gearMap];
dzn_gear_personalKits pushBackUnique _name;

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
    +_gearMap ,0
];

// -- Items override
DBG_1("Override assigned items = %1", _overrideAssignedItems);
DBG_1("Override assigned items = %1", _self get Q(Settings) get "AssignedItemsOverride" get _overrideAssignedItems);
if (_overrideAssignedItems != NO_OVERRIDE) then {
    _gearArr set [4, _self get Q(Settings) get "AssignedItemsOverride" get _overrideAssignedItems]
};

DBG_1("Override assigned items = %1", _overrideUniformItems);
DBG_1("Override assigned items = %1", _self get Q(Settings) get "UniformItemsOverride" get _overrideUniformItems);
if (_overrideUniformItems != NO_OVERRIDE) then {
    _gearArr set [5, _self get Q(Settings) get "UniformItemsOverride" get _overrideUniformItems]
};

// -- Format and copy

DBG("Going to execute FormatKit");
private _formatted = _self call [F(FormatKit), [_gearArr, _name, true]];
copyToClipboard _formatted;

// -- History and notification
ECOB(Editor,History) call [F(Add), [HISTORY_PERSONAL_KIT, _name, _formatted]];
_self call [F(Notify), [NOTIF_KIT_COPIED, [_title, _colorString]]];

forceUnicode -1;
