/*
 * SETTINGS
 */

// Paths
dzn_gear_kitsFile = "dzn_gear\Kits.sqf";
dzn_gear_GATFile = "dzn_gear\GearAssignmentTable.yml";

// Plugins - comment line with unwanted plugin to disable
dzn_gear_Plugins = [
    /*
        Provides powefull GUI tools to create kits.
    */
    "Editor"

    /*
        Gear information displayed in Briefing topic.
        Includes full list of player's equipment.
    */
    , "Notes"

    /*
        dzn Gear Zeus Compatibility
        Allows to assign gear kits to units via Zeus.
        Select unit and press 'G' key to invoke menu
    */
    , "Zeus"
];
