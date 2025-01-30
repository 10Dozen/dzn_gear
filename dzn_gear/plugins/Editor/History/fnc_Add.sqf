#include "defines.h"
#define DBG_FUNC_PREFIX "Add"

DBG_ "Invoked. Params: %1", _this EOL;

params ["_type", "_title", "_content"];

(_self get Q(History)) pushBack [_type, _title, CBA_missionTime, _content];