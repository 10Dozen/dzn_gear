#include "defines.h"

params [["_wipeAll", false]];

if (!_wipeAll) exitWith {
    clearAllItemsFromBackpack player;
    {player removeItemFromVest _x;} forEach (vestItems player);
    {player removeItemFromUniform _x;} forEach (uniformItems player);
    ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_CLEAR]]
};

#define EMPTY_KIT [["","","","","",""],["","","",["","","",""]],["","","",["","","",""]],["","","",["","","",""]],[""],["",[]],["",[]],["",[]]]

if (isNull cursorTarget) exitWith {
	[player, EMPTY_KIT] call dzn_fnc_gear_assignGear;
    ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_REMOVE]];
};

if (cursorTarget isKindOf "CAManBase") exitWith {
	[cursorTarget, EMPTY_KIT] call dzn_fnc_gear_assignGear;
    ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_REMOVE]];
};

#define EMPTY_CARGO_KIT [[],[],[],[]]
[cursorTarget, EMPTY_CARGO_KIT] call dzn_fnc_gear_assignCargoGear;
ECOB(Editor,Core)  call [F(Notify), [NOTIF_GEAR_VEHICLE_REMOVE]];
