params [["_editModeEnabled", false], ["_timeout", 0]];

// **************************
// 	DZN GEAR v2.11
//
//	Initialized when:
//	{ !isNil "dzn_gear_initDone" }
//
//	Server-side initialized when:
//	{ !isNil "dzn_gear_serverInitDone" }
//
dzn_gear_version = "v2.11";

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
/*
if (dzn_gear_editModeEnabled) then {
	[] call compileScript ["dzn_gear\fn\dzn_gear_editMode.sqf"];
};
*/

// **************************
// GEARS
// **************************
call compile preprocessFileLineNumbers dzn_gear_kits; // "dzn_gear\Kits.sqf";

// **************************
// INITIALIZATION
// **************************
// Delay before run
if (_timeout > 0) then {
	waitUntil { time > _timeout };
};

/*
if (dzn_gear_enableGearNotes) then { call compile preprocessFileLineNumbers "dzn_gear\plugins\GearNotes.sqf"; };
if (dzn_gear_enableZeusCompatibility) then { call compile preprocessFileLineNumbers "dzn_gear\plugins\ZeusCompatibility.sqf"; };

if (
	!dzn_gear_editModeEnabled
	|| (isMultiplayer && count (call BIS_fnc_listPlayers) > 3)
) then {
	call dzn_fnc_gear_nullifyUnusedVars;
};
*/

[
	{ !hasInterface || { !isNull player && local player } },
	{
		// -- Local initialization
		[] call dzn_fnc_gear_initialize;

		// -- Plugins
		dzn_gear_PluginSettings = ["dzn_gear\plugins\PluginSettings.yml"] call dzn_fnc_parseSFML;
		{
			private _name = _x;
			private _path = format ["dzn_gear\plugins\%1\init.sqf", _name];
			if !(fileExists _path) then {
				diag_log parseText format ["(dzn_gear) [init] Plugin '%1' is disabled (no init file %2). Skip.", _name, _path];
				continue;
			};
			[dzn_gear_PluginSettings get _name] call compileScript [_path];
		} forEach dzn_gear_Plugins;
	}
] call CBA_waitAndExecute;



