// **************************
// FUNCTIONS
// **************************
#include "dzn_gear_functions.sqf"

// **************************
// GEARS
// **************************
#include "dzn_gear_kits.sqf"

// **************************
// INITIALIZATION
// **************************

// Delay before run
if (!isNil { _this select 1 } && { typename (_this select 1) == "SCALAR" }) then { 
	waitUntil { time > _this select 1 };
};

if (hasInterface && !isServer) exitWith {
	waitUntil { !isNil { player getVariable "dzn_gear_assigned" } && !isNil { dzn_fnc_gear_assignKit } };

	// Change gear of player localy
	[player, player getVariable "dzn_gear_assigned"] call dzn_fnc_gear_assignKit;
	
	// Get local groupmembers and assign gear on them:
	_localUnits = units group player;
	{
		if (local _x) then {
			if (_x  isKindOf "CAManBase") then {
				[_x, _kitName] spawn dzn_fnc_gear_assignKit;
			} else {
				private ["_crew"];
				_crew = crew _x;
				if !(_crew isEqualTo []) then {
					{
						[_x, _kitName] spawn dzn_fnc_gear_assignKit;
						sleep 0.3;
					} forEach _crew;
				};
			};
			[_x, _x getVariable "dzn_gear_assigned"] call dzn_fnc_gear_assignKit;
		};
	} forEach _localUnits;
};



private ["_logics", "_kitName", "_synUnits","_units","_crew"];

// Search for Logics with name or variable "dzn_gear"/"dzn_gear_box" and assign gear to synced units
_logics = entities "Logic";
if !(_logics isEqualTo []) then {	
	{
		#define checkIsGearLogic(PAR)	([PAR, str(_x), false] call BIS_fnc_inString || !isNil {_x getVariable PAR})
		#define	getKitName(PAR,IDX)	if (!isNil {_x getVariable PAR}) then {_x getVariable PAR} else {str(_x) select [IDX]};
		
		// Check for vehicle kits
		if checkIsGearLogic("dzn_gear_box") then {
			_synUnits = synchronizedObjects _x;
			_kitName = getKitName("dzn_gear_box",13)
			{
				if (!(_x isKindOf "CAManBase") || {vehicle (crew _x select 0) != _x}) then {
					_veh = if ((crew _x) isEqualTo []) then {
						_x
					} else {
						vehicle (crew _x select 0)
					};
					[_veh, _kitName, true] spawn dzn_fnc_gear_assignKit;
					sleep 0.3;
				};
			} forEach _synUnits;
			deleteVehicle _x;
		} else {
			// Check for infantry kit (order defined by function BIS_fnc_inString - it will return True on 'dzn_gear_box' when searching 'dzn_gear'
			if checkIsGearLogic("dzn_gear") then {
				_synUnits = synchronizedObjects _x;
				_kitName = getKitName("dzn_gear",9)
				{
					// Assign gear to infantry and to crewmen
					if (_x  isKindOf "CAManBase") then {
						[_x, _kitName] spawn dzn_fnc_gear_assignKit;
					} else {
						private ["_crew"];
						_crew = crew _x;
						if !(_crew isEqualTo []) then {
							{
								[_x, _kitName] spawn dzn_fnc_gear_assignKit;
								sleep 0.3;
							} forEach _crew;
						};
					};
					sleep 0.3;
				} forEach _synUnits;
				deleteVehicle _x;
			};
		};
	} forEach _logics;
};

// Searching for Units with Variable "dzn_gear" or "dzn_gear_box" to change gear
_units = allUnits;
{
	// Unit has variable with infantry kit 
	if (!isNil {_x getVariable "dzn_gear"}) then {
		_kitName = _x getVariable "dzn_gear";
		
		// Search for infantry or crewman and assign kit
		if (_x isKindOf "CAManBase" && isNil {_x getVariable "dzn_gear_done"}) then {
			[_x, _kitName] spawn dzn_fnc_gear_assignKit;
		} else {
			_crew = crew _x;
			if !(_crew isEqualTo []) then {
				{
					if (isNil {_x getVariable "dzn_gear_done"}) then {
						[_x, _kitName] spawn dzn_fnc_gear_assignKit;
					};
					sleep 0.3;
				} forEach _crew;
			};
		};
	} else {
		// Vehicle has variable with vehicle/box kit 
		if (!isNil {_x getVariable "dzn_gear_box"} && { !(_x isKindOf "CAManBase") }) then {
			[_x, _x getVariable "dzn_gear_box", true] spawn dzn_fnc_gear_assignKit;
		};
	};
	sleep 0.2;
} forEach _units;
