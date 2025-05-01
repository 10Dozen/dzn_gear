#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_InitKeybinds"

params ["_display"];
DBG_1("Params: %1", _this);

_display displayAddEventHandler [
    "KeyUp",
    { ThisCOB call [F(onKeyPressed), _this] }
];
