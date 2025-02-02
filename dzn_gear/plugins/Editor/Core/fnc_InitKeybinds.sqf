#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_InitKeybinds"

params ["_display"];
DBG_ "Params: %1", _this EOL;

_display displayAddEventHandler [
    "KeyUp",
    { ThisCOB call [F(onKeyPressed), _this] }
];