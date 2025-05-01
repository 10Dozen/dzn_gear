#include "fn\categories.h"
params [["_editModeEnabled", false], ["_timeout", 0], ["_settingsFile", "dzn_gear\Settings.sqf"]];

// **************************
// DZN GEAR v2.28
//
// Initialized when:
// { !isNil "dzn_gear_initDone" }
//
// Server-side initialized when:
// { !isNil "dzn_gear_serverInitDone" }
// **************************

dzn_gear_version = "v2.28";

#define LOG_ diag_log text format ["[dzn_gear] (init) " +
#define EOL ]

LOG_ "Initialization started. Version: %1.", dzn_gear_version EOL;
// *************************
// SETTINGS
// **************************
[] call compileScript [_settingsFile];

// **************************
// FUNCTIONS
// **************************
#define PREP(NAME) dzn_fnc_gear_##NAME = compileScript ['dzn_gear\fn\##NAME##.sqf']

PREP(assignKit);
PREP(assignKitByGAT);
PREP(assignGear);
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
    [MAP_GEAR_UNIFORM, ""],
    [MAP_GEAR_VEST, ""],
    [MAP_GEAR_BACKPACK, ""],
    [MAP_GEAR_HEADGEAR, ""],
    [MAP_GEAR_FACEWEAR, ""],
    [MAP_GEAR_PRIMARY,[]],
    [MAP_GEAR_LAUNCHER,[]],
    [MAP_GEAR_HANDGUN,[]],
    [MAP_GEAR_ASSIGNED, []],
    [MAP_GEAR_UNIFORM_ITEMS, []],
    [MAP_GEAR_VEST_ITEMS, []],
    [MAP_GEAR_BACKPACK_ITEMS, []],
    [MAP_GEAR_DESC, ""]
];

dzn_gear_emptyWeaponDescriptor = createHashMapFromArray [
    [I_WEAPON_CLASS, ""],
    [I_WEAPON_MAG, ""],
    [I_WEAPON_ATTACHES, ["", "", "", ""]]
];

dzn_gear_cargoMapDeclaration = [
    ["#type", "dzn_gear_CargoMapInterface"],
    ["#create", compileScript ['dzn_gear\fn\CargoMapConstructor.sqf']],
    ["#str", compileScript ['dzn_gear\fn\CargoMapToString.sqf']],
    [MAP_CARGO_WEAPONS, []],
    [MAP_CARGO_MAGAZINES, []],
    [MAP_CARGO_ITEMS, []],
    [MAP_CARGO_BACKPACKS, []]
];

// **************************
// GEAR AND KITS
// **************************
{
    LOG_ "Going to initialize kits at %1", _x EOL;
    [] call compileScript [_x];
} forEach dzn_gear_kitsFiles;

dzn_gear_gat_table = [dzn_gear_GATFile] call dzn_fnc_parseSFML;
if ((dzn_gear_gat_table get "#ERRORS") isNotEqualTo []) then {
    [
        "dzn_gear :: Gear Assignment Table :: %1 error(s) occured! See RPT logs for more info.",
        count (dzn_gear_gat_table get "#ERRORS")
    ] call BIS_fnc_error;
    { LOG_ "GAT Error at [%1] - %2", _x # 2, _x # 3 EOL; } forEach (dzn_gear_gat_table get "#ERRORS");
};
dzn_gear_gat_table deleteAt "#ERRORS";
dzn_gear_gat_table deleteAt "#SOURCE";

dzn_gear_personalKits = [];
dzn_gear_cargoKits = [];
dzn_gear_kitnameToGearMap = createHashMap;


// -- Plain variant (Array of [Rolename (Side, Group), Kitname]
dzn_gear_gat_table_plain = [];
private ["_sideName", "_groupName"];
{
    if (_y isEqualType "") then { dzn_gear_gat_table_plain pushBack [_x, _y]; continue; };
    _sideName = _x;
    {
        if (_y isEqualType "") then { dzn_gear_gat_table_plain pushBack [format ["%1 (%2)", _x, _sideName], _y]; continue; };
        _groupName = _x;
        { dzn_gear_gat_table_plain pushBack [format ["%1 (%2, %3)", _x, _sideName, _groupName], _y]; } forEach _y;
    } forEach _y;
} forEach dzn_gear_gat_table;

// **************************
// INITIALIZATION
// **************************

[
    { !isNil "dzn_gear_serverInitDone" },
    { LOG_ "Server-side initialized." EOL; }
] call CBA_fnc_waitUntilAndExecute;

[
    { time >= (_this # 1) && ( !hasInterface || { !isNull player && local player } ) },
    {
        LOG_ "Init condition met. Starting plugins." EOL;
        // -- Plugins
        private _pluginSettings = [dzn_gear_PluginsSettingsFile] call dzn_fnc_parseSFML;
        {
            private _name = _x;
            if (_name == "Editor" && !(_this # 0)) then { continue }; // Prevent Editor from running if arg not passed

            private _path = format ["dzn_gear\plugins\%1\init.sqf", _name];
            if !(fileExists _path) then {
                LOG_ "Plugin '%1' is disabled (no init file %2). Skip.", _name, _path EOL;
                continue;
            };
            LOG_ "Plugin '%1' is starting", _name EOL;
            [_pluginSettings get _name] call compileScript [_path];
        } forEach dzn_gear_Plugins;

        // -- Local initialization
        [] call dzn_fnc_gear_initialize;

        // -- Collect kits for other consumers
        [] call dzn_fnc_gear_scanForKitnames;

        LOG_ "Fully initialized." EOL;
    },
    [_editModeEnabled, _timeout]
] call CBA_fnc_waitUntilAndExecute;
