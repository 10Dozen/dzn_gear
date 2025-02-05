#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_ClearGear"

params [["_wipeMode", WIPE_BACKPACK]];

#define EMPTY_KIT [["","","","","",""],["","","",["","","",""]],["","","",["","","",""]],["","","",["","","",""]],[""],["",[]],["",[]],["",[]]]

if (isNull cursorTarget) exitWith {
    DBG_ "Is null cursor target: %1", cursorTarget EOL;

    clearAllItemsFromBackpack player;
    if (_wipeMode == WIPE_BACKPACK) exitWith {
        ECOB(Editor,Core) call [F(Notify), [NOTIF_GEAR_BACKPACK_CLEAR]];
    };
    if (_wipeMode == WIPE_CONTAINERS) exitWith {
        {player removeItemFromVest _x;} forEach (vestItems player);
        {player removeItemFromUniform _x;} forEach (uniformItems player);
        ECOB(Editor,Core) call [F(Notify), [NOTIF_GEAR_CLEAR]];
    };

    [player, EMPTY_KIT] call dzn_fnc_gear_assignGear;
    ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_REMOVE_ALL]];
};

if (cursorTarget isKindOf "CAManBase") exitWith {
    DBG_ "Target is some unit: %1", cursorTarget EOL;
    [cursorTarget, EMPTY_KIT] call dzn_fnc_gear_assignGear;
    ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_REMOVE]];
};

DBG_ "Target is vehicle: %1", cursorTarget EOL;
#define EMPTY_CARGO_KIT [[],[],[],[]]
[cursorTarget, EMPTY_CARGO_KIT] call dzn_fnc_gear_assignCargoGear;
ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_VEHICLE_REMOVE]];
