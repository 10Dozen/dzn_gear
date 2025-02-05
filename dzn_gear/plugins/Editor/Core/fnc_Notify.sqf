#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_Notify"

params ["_type", ["_msgParams", []]];
DBG_ "Params: %1", _this EOL;

DBG_ "Message: %1", (_self get Q(Messages)) getOrDefault [_type, ""] EOL;

[
    parseText format ([(_self get Q(Messages)) getOrDefault [_type, ""]] + _msgParams),
    true, nil, 7, 0.2, 0
] spawn BIS_fnc_textTiles;