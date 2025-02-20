#include "fn\defines.h"
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
[] call compileScript ["dzn_gear\Settings.sqf"];

// **************************
// FUNCTIONS
// **************************
#define PREP(NAME) dzn_fnc_gear_##NAME = compileScript ['dzn_gear\fn\##NAME##.sqf']

PREP(assignKit);
PREP(assignKitByGAT);
PREP(assignGear);
PREP(assignGearArray);
PREP(assignCargoGear);
PREP(assignIdentity);
PREP(getGear);
PREP(getCargoGear);
PREP(getPreciseGear);
PREP(setPreciseGear);
PREP(scanForKitnames);
PREP(make);
PREP(initialize);

dzn_gear_gearMapDeclaration = [
    ["#type", "dzn_gear_GearMapInterface"],
    ["#create", compileScript ['dzn_gear\fn\GearMapConstructor.sqf']],
    ["#str", compileScript ['dzn_gear\fn\GearMapToString.sqf']],
    [MAP_CAT_UNIFORM, ""],
    [MAP_CAT_VEST, ""],
    [MAP_CAT_BACKPACK, ""],
    [MAP_CAT_HEADGEAR, ""],
    [MAP_CAT_FACEWEAR, ""],
    [MAP_CAT_PRIMARY,[]],
    [MAP_CAT_LAUNCHER,[]],
    [MAP_CAT_HANDGUN,[]],
    [MAP_CAT_ASSIGNED, []],
    [MAP_CAT_UNIFORM_ITEMS, []],
    [MAP_CAT_VEST_ITEMS, []],
    [MAP_CAT_BACKPACK_ITEMS, []]
];

dzn_gear_emptyWeaponDescriptor = createHashMapFromArray [
    [I_WEAPON_CLASS, ""],
    [I_WEAPON_MAG, ""],
    [I_WEAPON_ATTACHES, ["", "", "", ""]]
];
/*
dzn_gear_weaponPresetDeclaration = [
    ["#type", "dzn_gear_WeaponPresetInterface"],
    [I_WEAPON_CLASS, ""],
    [I_WEAPON_MAG, ""],
    [I_WEAPON_ATTACHES, []]
];

dzn_gear_cargoGearMapObjectDeclaration = [
    ["#type", "dzn_gear_CargoGearMapInterface"],
    ["#create", compileScript ['dzn_gear\fn\GearMapConstructor.sqf']],
    ["weapons", []],
    ["magazines", []],
    ["items", []],
    ["backpacks", []],
    ["weapons detailed", []]
];
*/

// **************************
// GEARS
// **************************
[] call compileScript [dzn_gear_kitsFile];
dzn_gear_gat_table = [dzn_gear_GATFile] call dzn_fnc_parseSFML;
dzn_gear_gat_table deleteAt "#ERRORS";
dzn_gear_gat_table deleteAt "#SOURCE";

dzn_gear_personalKits = [];
dzn_gear_cargoKits = [];
dzn_gear_kitnameToGearMap = createHashMap;

// **************************
// INITIALIZATION
// **************************

/*
if (dzn_gear_enableZeusCompatibility) then { call compile preprocessFileLineNumbers "dzn_gear\plugins\ZeusCompatibility.sqf"; };

if (
    !dzn_gear_editModeEnabled
    || (isMultiplayer && count (call BIS_fnc_listPlayers) > 3)
) then {
    call dzn_fnc_gear_nullifyUnusedVars;
};
*/

[
    { time >= (_this # 1) && ( !hasInterface || { !isNull player && local player } ) },
    {
        // -- Plugins
        private _pluginSettings = ["dzn_gear\plugins\PluginSettings.yml"] call dzn_fnc_parseSFML;
        {
            private _name = _x;
            if (_name == "Editor" && !(_this # 0)) then { continue }; // Prevent Editor from running if arg not passed

            private _path = format ["dzn_gear\plugins\%1\init.sqf", _name];
            if !(fileExists _path) then {
                diag_log parseText format ["(dzn_gear) [init] Plugin '%1' is disabled (no init file %2). Skip.", _name, _path];
                continue;
            };
            [_pluginSettings get _name] call compileScript [_path];
        } forEach dzn_gear_Plugins;

        // -- Local initialization
        [] call dzn_fnc_gear_initialize;

        // -- Collect kits for other consumers
        [] call dzn_fnc_gear_scanForKitnames;
    },
    [_editModeEnabled, _timeout]
] call CBA_fnc_waitUntilAndExecute;

