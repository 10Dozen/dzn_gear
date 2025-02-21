
#include "defines.h"

/*
	Menu's BTN_UNITS click 
	Params:
	0: _advDialog 
	1: _args
	2: _control

*/

params ["_ad", "_idx", "_ctrl"];

private _state = !(_ctrl getVariable [Q(Selected), true]);
_ctrl setVariable [Q(Selected), _state];
_ctrl ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_PALE_GREEN] select _state);

// -- Set filter state
(_self get Q(MenuFilters)) set [_idx, _state];

_self call [F(menu_updateState), [_ad]];