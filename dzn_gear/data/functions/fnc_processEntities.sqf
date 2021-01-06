/* ----------------------------------------------------------------------------
Function: dzn_gear_fnc_processEntities

Description:
	Process all mission placed Units and Vehicles, checks for assigned kits
	and apply it.

	Function runs on both server and clients to decrease network load 
	on mission start if logics are local to players.

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		[] call dzn_gear_fnc_processEntities;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#import "..\macro.hpp"

private _filter = { local _x && !(_x getVariable ["dzn_gear_done", false]) };

// --- Process vehicles and boxes
{
	// --- Assign kits for crew 
	private _crewKit = _x getVariable ["dzn_gear", nil];
	if (!isNil _crewKit) then {
		(crew _x) apply { _x setVariable ["dzn_gear", _crewKit, true] };
	};

	// --- Assign cargo kits 
	private _cargoKit = _x getVariable ["dzn_gear_cargo", nil];
	if (!isNil _cargoKit) then {
		[_x, _cargoKit, true] call FUNC(assignKit);
	};
} forEach (vehicles select _filter);

// --- Process units
{
	private _kit = _x getVariable ["dzn_gear", nil];
	if (!isNil _kit) then {
		[_x, _kit] call FUNC(assignKit);
	};
} forEach (allUnits select _filter);
