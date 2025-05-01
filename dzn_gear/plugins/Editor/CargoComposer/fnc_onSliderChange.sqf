#include "defines.h"
#define DBG_FUNC_PREFIX "onSliderChange"

params ["_eventArgs", "_ad", "_args"];

DBG_1("Params: %1", _this);

_eventArgs params ["", "_newValue"];
(_ad call ["GetByTag", _args]) ctrlSetStructuredText parseText format ["<t align='right'>x%1</t>", _newValue];
