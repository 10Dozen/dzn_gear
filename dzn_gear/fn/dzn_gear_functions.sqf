// **************************
// FUNCTIONS
// **************************
dzn_fnc_gear_assignKit = {
	/*
		Resolve given kit and call function to assign existing kit to unit.	
		EXAMPLE:	[ unit, gearSetName, isBox ] spawn dzn_gearSetup;
		INPUT:
			0: OBJECT		- Unit for which gear will be set
			1: ARRAY or STRING	- List of Kits or single kit for assignment: ["kit_r","kit_ar"] or "kit_ar"
			2: BOOLEAN		- Is given unit a box?
		OUTPUT: NULL
	*/
	params ["_unit","_kits",["_isCargo", false]];
	private ["_kit","_randomKit"];
	
	_kit = if (typename _kits == "ARRAY") then { _kits call BIS_fnc_selectRandom } else { _kits };
	if (isNil {call compile _kit}) exitWith {
		diag_log format ["There is no kit with name %1", (_kit)];
		player sideChat format ["There is no kit with name %1", (_kit)];
	};
	
	_unit setVariable ["dzn_gear", _kit];
	
	if (_isCargo) then {
		[_unit, call compile _kit] call dzn_fnc_gear_assignGear;
	} else {
		[_unit, call compile _kit] call dzn_fnc_gear_assignCargoGear;
	};
};


dzn_fnc_gear_assignGear = {};
dzn_fnc_gear_assignCargoGear = {};

dzn_fnc_gear_getGear = {};
dzn_fnc_gear_getCargoGear = {};

dzn_fnc_gear_initialize = {};
