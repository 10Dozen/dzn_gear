#include "defines.h"

DBG_ "InitEvents!" EOL;

private _display = findDisplay 46;
_self call [F(SetCurrentDisplay), [_display]];

// -- Keybinding
_self call [F(InitKeybinds), [_display]];

// -- Arsenal events
ECOB(Editor,Arsenal)  call [F(InitEvents)];

// -- Loadout cahnge events
["loadout", {
    DBG_ "On loadout change!" EOL;
    ThisCOB call [F(ShowTotals), []];
}, true] call CBA_fnc_addPlayerEventHandler;