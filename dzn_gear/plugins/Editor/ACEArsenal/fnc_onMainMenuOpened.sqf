#include "defines.h"

params ["_display", "_dialogID"];

// --- Ace arsenal dialog - ignore
if (_dialogID == DIALOG_ID_ITEM_POOL || _dialogID == DIALOG_ID_SUBCAT_ITEM_POOL) exitWith {};

// -- Otherwise - hide buttons
["MODIFY", _self get Q(Display), "btn*", [
    ["show", false]
]] call dzn_fnc_HandleControl;
