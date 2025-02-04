#include "defines.h"

params ["_title", "_name", "_colorString", "_kit"];

// -- Save kit to namespace
missionNamespace setVariable [_name, _kit];

// -- Action
player addAction [
	format [
		"<t color='%1'>Cargo Kit from %3 at %2</t>"
		, _this select 0
		, [time/3600, "HH:MM:SS"] call BIS_fnc_timeToString
		, (typeOf cursorTarget) call dzn_fnc_gear_editMode_getVehicleName
	]
	, {
		if (!isNull cursorTarget && !(cursorTarget isKindOf "CAManBase")) then {
			[cursorTarget, _this select 3] call dzn_fnc_gear_assignCargoGear;
		} else {
			if (vehicle player != player) then {
				[vehicle player, _this select 3] call dzn_fnc_gear_assignCargoGear;
			};
		};
	}
	, _this select 1, 0
];

// -- Format and copy
private _formatted = _self call [F(FormatKit), [_kit, _name]];
copyToClipboard _formatted;

// -- History and notification
dzn_gear_HistoryComponent call [F(Add), [HISTORY_CARGO_KIT, _name, _formatted]];
[_colorString, +_kit] call _addCargoKitAction;

_self call [F(Notify), [NOTIF_KIT_COPIED, ["Cargo", _colorString]]];
