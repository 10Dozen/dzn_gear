#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_SetCurrentDisplay"

DBG_ "Params: %1", _this EOL;

params [["_display", displayNull, [displayNull]]];

_self set [Q(CurrentDisplay), _display];