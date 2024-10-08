params [["_editModeEnabled", false], ["_timeout", 0]];

// **************************
// 	DZN GEAR v2.9
//
//	Initialized when:
//	{ !isNil "dzn_gear_initDone" }
//
//	Server-side initialized when:
//	{ !isNil "dzn_gear_serverInitDone" }
//
dzn_gear_version = "v2.9";

// *************************
//	SETTINGS
// **************************
call compile preprocessFileLineNumbers "dzn_gear\Settings.sqf";

// **************************
// FUNCTIONS
// **************************
dzn_gear_defaultBackpack = "B_Carryall_khk";
dzn_gear_editModeEnabled = _editModeEnabled;

call compile preprocessFileLineNumbers "dzn_gear\fn\dzn_gear_functions.sqf";

// **************************
// EDIT MODE
// **************************
if (dzn_gear_editModeEnabled) then {
	call compile preprocessFileLineNumbers "dzn_gear\fn\dzn_gear_editMode.sqf";
	[] spawn dzn_fnc_gear_editMode_initialize;
};

// **************************
// GEARS
// **************************
call compile preprocessFileLineNumbers "dzn_gear\Kits.sqf";

// **************************
// INITIALIZATION
// **************************
// Delay before run
if (_timeout > 0) then { 
	waitUntil { time > _timeout };
};

if (dzn_gear_enableGearAssignementTable) then { call compile preprocessFileLineNumbers "dzn_gear\plugins\AssignementTable.sqf"; };
if (dzn_gear_enableGearNotes) then { call compile preprocessFileLineNumbers "dzn_gear\plugins\GearNotes.sqf"; };
if (dzn_gear_enableZeusCompatibility) then { call compile preprocessFileLineNumbers "dzn_gear\plugins\ZeusCompatibility.sqf"; };

if (
	!dzn_gear_editModeEnabled
	|| (isMultiplayer && count (call BIS_fnc_listPlayers) > 3)
) then {
	call dzn_fnc_gear_nullifyUnusedVars;
};

[] call dzn_fnc_gear_initialize;
