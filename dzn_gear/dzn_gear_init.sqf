// **************************
// 	DZN GEAR
//
//
//	SETTINGS
// **************************

// Plugins
dzn_gear_enableGearAssignementTable		= true;
dzn_gear_enableGearNotes			= true;


dzn_gear_defaultBackpack = "B_Carryall_khk";
dzn_gear_editModeEnabled = _this select 0;
if (isServer) then { dzn_gear_initialized = false; };

// **************************
// FUNCTIONS
// **************************
#include "fn\dzn_gear_functions.sqf"

// **************************
// EDIT MODE
// **************************
if (dzn_gear_editModeEnabled) then {call compile preProcessFileLineNumbers "dzn_gear\fn\dzn_gear_editMode.sqf";};

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

[] spawn dzn_fnc_gear_initialize;
waitUntil { !isNil "dzn_gear_initialized" && { dzn_gear_initialized } };

if (hasInterface) then {
	// Waiting until dzn_gear is initialized and then, if player is JIP - wait for "dzn_gear" variable is assigned to change kit
	[] spawn {
		if (didJIP) then {
			waitUntil { sleep 1; !isNil { player getVariable "dzn_gear" } };
			[player, player getVariable "dzn_gear"] spawn dzn_fnc_gear_assignKit;
		};
	};
	
	if (dzn_gear_enableGearAssignementTable) then {
		[] execVM "dzn_gear\plugins\dzn_gear_fn_assignementTable.sqf";
		[] spawn {
			waitUntil { !isNil "dzn_gear_initialized" && !isNil "dzn_gear_gat_enabled" };	
			player call dzn_fnc_gear_plugin_assignByTable;
		};
	};
	
	if (dzn_gear_enableGearNotes) then {
		[] execVM "dzn_gear\plugins\dzn_gear_fn_gearNotes.sqf";
	};
};
