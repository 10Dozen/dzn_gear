#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_SetCurrentDisplay"

DBG_1("Params: %1", _this);

params [["_display", displayNull, [displayNull]]];

_self set [Q(CurrentDisplay), _display];
