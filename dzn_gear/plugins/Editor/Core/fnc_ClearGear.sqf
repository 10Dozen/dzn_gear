#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_ClearGear"

#define EMPTY_LOADOUT [[],[],[],[],[],[],"","",[],["","","","","",""]]

params [["_wipeMode", WIPE_BACKPACK]];

if (isNull cursorTarget) exitWith {
    DBG_1("Is null cursor target: %1", cursorTarget);

    clearAllItemsFromBackpack player;
    if (_wipeMode == WIPE_BACKPACK) exitWith {
        ECOB(Editor,Core) call [F(Notify), [NOTIF_GEAR_BACKPACK_CLEAR]];
    };
    if (_wipeMode == WIPE_CONTAINERS) exitWith {
        {player removeItemFromVest _x;} forEach (vestItems player);
        {player removeItemFromUniform _x;} forEach (uniformItems player);
        ECOB(Editor,Core) call [F(Notify), [NOTIF_GEAR_CLEAR]];
    };

    player setUnitLoadout EMPTY_LOADOUT;
    ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_REMOVE_ALL]];
};

if (cursorTarget isKindOf "CAManBase") exitWith {
    DBG_1("Target is some unit: %1", cursorTarget);
    cursorTarget setUnitLoadout EMPTY_LOADOUT;
    ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_REMOVE]];
};

DBG_1("Target is vehicle: %1", cursorTarget);
#define EMPTY_CARGO_KIT [[],[],[],[]]
[cursorTarget, EMPTY_CARGO_KIT] call dzn_fnc_gear_assignCargoGear;
ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_VEHICLE_REMOVE]];
