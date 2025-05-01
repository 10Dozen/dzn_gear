#include "defines.h"
#define DBG_FUNC_PREFIX "onKeyPressed"

DBG_1("Params: %1", _this);

params ["_display", "_key", "_shift", "_ctrl", "_alt"];

private _binding = _self get Q(Keybinds) get _key;

// -- Ignore unbinded keys
if (isNil "_binding") exitWith { false };

private _execKey = [
    ["","ctrl"] select _ctrl,
    ["","shift"] select _shift,
    ["","alt"] select _alt
] select { _x != "" } joinString "+";
if (_execKey == "") then { _execKey = "key"; };

DBG_2("_execKey=%1, exec=%2", _execKey, _binding get _execKey);
[] call (_binding get _execKey);

true
