#include "defines.h"

params ["_title", "_kit", "_name", "_colorString"];

// -- Save kit to namespace
missionNamespace setVariable [_name, _kit];

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
	_kit ,0
];

// -- Items override
private _assignedItemsOverride = _self get Q(OverrideAssignedItems);
if (_assignedItemsOverride != NO_OVERRIDE) then {
    _kit set [4, _self get Q(Settings) get "AssignedItemsOverride" get _assignedItemsOverride]
};

private _uniformItemsOverride = _self get Q(OverrideUniformItems);
if (_uniformItemsOverride != NO_OVERRIDE) then {
    _kit set [5, _self get Q(Settings) get "UniformItemsOverride" get _uniformItemsOverride]
};

// -- Format and copy
private _formatted = _self call [F(FormatKit), [_kit, _name]];
copyToClipboard _formatted;

// -- History and notification
dzn_gear_HistoryComponent call [F(add), [HISTORY_PERSONAL_KIT, _name, _formatted]];
_self call [F(Notify), [NOTIF_KIT_COPIED, [_title, _colorString]]];
