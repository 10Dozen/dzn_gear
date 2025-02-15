#include "defines.h"

params ["_display"];

["dzn_AdvDialog2_onOpened", _self get Q(MainMenuOpenedEH)] call CBA_fnc_removeEventHandler;
["dzn_AdvDialog2_onClosed", _self get Q(MainDialogClosedEH)] call CBA_fnc_removeEventHandler;

_self set [Q(MainMenuOpenedEH), -1];
_self set [Q(MainDialogClosedEH), -1];