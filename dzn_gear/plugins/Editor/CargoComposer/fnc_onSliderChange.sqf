#include "defines.h"
#define DBG_FUNC_PREFIX "onSliderChange"

params ["_eventArgs", "_ad", "_args"];

DBG_ "Params: %1", _this EOL;

_eventArgs params ["", "_newValue"];
(_ad call ["GetByTag", _args]) ctrlSetStructuredText parseText format ["<t align='right'>x%1</t>", _newValue];
