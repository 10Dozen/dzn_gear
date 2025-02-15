#include "defines.h"
DBG_ "Params: %1", _this EOL;

private["_crewKit","_cargoKit","_synKit","_logic","_par","_id","_kit"];

// -- Game logics
{
	_logic = _x;
	{
		_varname = _x;
		_kit = "";
		_kit = _logic getVariable [_varname, ""];
		if (_kit == "") then { continue; };
		{
			if (!local _x) then { continue; };
			_x setVariable [_varname, _kit, true];
		} forEach (synchronizedObjects _logic);
	} forEach [
		"dzn_gear",
		"dzn_gear_cargo"
	];
} forEach (entities "Logic");

// -- Variable on Vehicles
{
	_crewKit = _x getVariable ["dzn_gear", ""];
	if (_crewKit != "") then {
		{ _x setVariable ["dzn_gear", _crewKit, true]; } forEach (crew _x);
	};
	_cargoKit = _x getVariable ["dzn_gear_cargo", ""];
	if (_cargoKit == "") then { continue; };
	[_x, _cargoKit, true] call dzn_fnc_gear_assignKit;
} forEach ((vehicles) select {
	local _x
	&& !(_x getVariable ["dzn_gear_done", false])
	&& (_x getVariable ["dzn_gear", ""] != "" || _x getVariable ["dzn_gear_cargo", ""] != "")
});

// -- Variable on Units
{
	_kit = _x getVariable ["dzn_gear", ""];
	if (_kit == "") then { continue; };

	DBG_ "Variable on unit" EOL;
	[_x,_kit] call dzn_fnc_gear_assignKit;
} forEach ((allUnits) select {
	local _x
	&& !(_x getVariable ["dzn_gear_done", false])
});

// -- Gear assignment table
if (hasInterface) then {
	DBG_ "GAT" EOL;
	[player] call dzn_fnc_gear_assignKitByGAT;
};

dzn_gear_initDone = true;
if (isServer) then {
	dzn_gear_serverInitDone = true;
	publicVariable "dzn_gear_serverInitDone";
};