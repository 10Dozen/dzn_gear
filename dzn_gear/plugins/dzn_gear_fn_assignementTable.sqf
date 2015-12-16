// ******** Gear Assignement Table Plug-in ************
// ****************************************************
//
//
// ******************** Settings **********************

dzn_gear_gat_table = [];

// ********************** FNC ************************
dzn_fnc_gear_plugin_resolveKit = {
	// @Kitname = @Unit call dzn_fnc_gear_plugin_resolveKit
	params["_unit"];
	private["_kit","_nameKit","_roleKit"];
	
	_kit = "";
	
	_nameKit = [ dzn_gear_gat_table , { (_x select 0) isEqualTo (vehicleVarName _unit) }] call BIS_fnc_conditionalSelect;
	if (_nameKit isEqualTo []) then {
		_roleKit = [ dzn_gear_gat_table , { (_x select 0) isEqualTo (roleDescription _unit) }] call BIS_fnc_conditionalSelect;
		if !(_roleKit isEqualTo []) then {
			_kit = _roleKit;
		};
	} else {
		_kit = _nameKit;
	};
	
	_kit
};

dzn_fnc_gear_plugin_assignByTable = {
	params["_unit"];
	if (!isNil {_unit getVariable "dzn_gear"}) exitWith {};
	
	_kit = _unit call dzn_fnc_gear_plugin_resolveKit;
	if !(_kit isEqualTo "") then {
		[_unit, _kit] spawn dzn_fnc_gear_assignKit;
	};
};
