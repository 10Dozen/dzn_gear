#include "defines.h"

/*
    TODO:

    + Show totals -- show estimated weight
    + Add F2 keybind for Toggle Totals
    - DEL to Delete vehicle/box container
    - Main menu
        + Remove dialog animation?
        + Unit kit creation
            + Assigned/Uniform items override
            + Store key
            + Roles options

        - Vehicle kit creation
        - Copycat kit creation
    - Cargo kit composer
    - AmmoBearer composer
    - History

    - ControlHandler -- reset all displays on mission restart (check tSF Chatter for details)
*/

params ["_pluginSettings"];

[_pluginSettings] call compileScript ["dzn_gear\plugins\Editor\initComponents.sqf"];

[
    { !isNull findDisplay 46 && time > 0},
    {
        ECOB(Editor,Core) call [F(InitEvents)];
    }
] call CBA_fnc_waitUntilAndExecute;