#include "defines.h"

params ["_eventArgs", "_ad", "_args"];
_eventArgs params ["", "_newValue"];
(_ad call ["GetByTag", _args]) ctrlSetStructuredText parseText format ["<t align='right'>x%1</t>", _newValue];
	