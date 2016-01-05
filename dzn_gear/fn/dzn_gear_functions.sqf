// **************************
// FUNCTIONS
// **************************
dzn_fnc_gear_assignKit = {
	/*
		Resolve given kit and call function to assign existing kit to unit.	
		EXAMPLE:	[ unit, gearSetName, isBox ] spawn dzn_fnc_gear_assignKit;
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

dzn_fnc_gear_assignGear = {
	...

	//_unit setVariable ["dzn_gear_kit", _unit call dzn_fnc_gear_getGear, true];
	if (dzn_gear_enableGearNotes) then {
		_unit setVariable ["dzn_gear_shortNote", "", true];
		_unit setVariable ["dzn_gear_fullNote", "", true];
	};
	_unit setVariable ["dzn_gear_done", true, true];
};

dzn_fnc_gear_assignCargoGear = {
	
	//_unit setVariable ["dzn_gear_kit", _unit call dzn_fnc_gear_getCargoGear, true];
	_unit setVariable ["dzn_gear_done", true, true];
};

dzn_fnc_gear_getGear = {};
dzn_fnc_gear_getCargoGear = {};

dzn_fnc_gear_initialize = {
	// Wait until player initialized in multiplayer
	if (isMultiplayer && hasInterface) then {
		waitUntil { !isNull player && { local player} };
	};
	
	dzn_fnc_gear_checkSynchroObject = {
		// [@unit, @Par ("dzn_gear_cargo"/"dzn_gear")] call dzn_fnc_gear_checkSynchroObject
		params ["_unit","_par"];
		private ["_kit","_id"];
		_kit = "";
		_id = if (toLower(_par) == "dzn_gear_cargo") then { 14 } else { 9 }; 
		
		{
			if (typeOf _x == "Logic") then {
				if ( !isNil { _x getVariable _par } || [_par, str(_x), false] call BIS_fnc_inString ) exitWith {
					_kit = if (!isNil {_x getVariable _par}) then {_x getVariable _par} else {str(_x) select [_id]};
				};
			};
		} forEach (synchronizedObjects _this);
		
		_kit
	}
	
	private["_crewKit"];
	
	{
		if (local _x && { _x getVariable ["dzn_gear_done", false] }) then {
			// Crew Kit
			if (!isNil { _x getVariable "dzn_gear" }) then {
				_crewKit = _x getVariable "dzn_gear";
				{_x setVariable ["dzn_gear", _crewKit, true];} forEach (crew _x);
			};
			
			// Cargo Kit
			if (!isNil { _x getVariable "dzn_gear_cargo" }) then {
				[_x, _x getVariable "dzn_gear_cargo", true] spawn dzn_fnc_gear_assignKit;
			} else {
				_sObj = synchronizedObjects
			
			};
		};
	} forEach (vehicles);

	{
		if (local _x && { _x getVariable ["dzn_gear_done", false] }) then {
		
		};
	} forEach (allUnits);

};
