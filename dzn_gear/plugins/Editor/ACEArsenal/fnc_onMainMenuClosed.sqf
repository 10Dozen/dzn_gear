#include "defines.h"

params ["_display", "_dialogID"];

// --- Ace arsenal dialog - ignore
if (_dialogID == DIALOG_ID_ITEM_POOL || _dialogID == DIALOG_ID_SUBCAT_ITEM_POOL) exitWith {};

// -- Otherwise - show buttons
["MODIFY", _self get Q(Display), "btnCat*", [
    ["show", true]
]] call dzn_fnc_HandleControl;

if !((_self get Q(CurrentCategory)) in CATS_WITH_SUBCAT) exitWith {};
["MODIFY", _self get Q(Display), "btnSub*", [["show", true]]] call dzn_fnc_HandleControl;
