
#include "defines.h"

/*
    Menu's BTN_UNITS click
    Params:
    0: _advDialog
    1: _args
    2: _control

*/

params ["_ad", "_idx", "_ctrl"];

// -- Set filter state & update GUI
_self call [F(menu_updateFiltersState), [_ad, _idx]];
_self call [F(menu_updateMenu), [_ad]];
