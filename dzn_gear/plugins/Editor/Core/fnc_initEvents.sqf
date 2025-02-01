#include "defines.h"

DBG_ "InitEvents!" EOL;

// -- Keybinding
(findDisplay 46) displayAddEventHandler [
    "KeyUp",
    { ThisCOB call [F(onKeyPressed), _this] }
];

// -- Arsenal events
ECOB(Editor,Arsenal)  call [F(initEvents)];

// -- Loadout cahnge events
["loadout", {
    DBG_ " Loadout event!!" EOL;
    ThisCOB call [F(ShowTotals), [ThisCOB get Q(TotalsTargetDisplay)]];
}, true] call CBA_fnc_addPlayerEventHandler;