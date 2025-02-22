
#include "defines.h"

/*
    Menu's OnCBAEvent::dzn_gear_zeusSelectionChanged handled.

*/
DBG_ "OnCustomEvent 'dzn_gear_zeusSelectionChanged'. Params: %1", _this EOL;

_this params ["_ad"];

// -- Scan for current selections and save.
//    When triggered by event - it always has something selected, so when user drops selection
//    entities will be stored for a while.
(_self call [F(getSelected), []]) params ["_units", "_crew", "_objects"];
_self set [Q(ZeusLastSelected), [_units, _crew, _objects]];

// -- Update filter button text
MENU_ITEM_BY_TAG(_ad,BTN_UNITS) ctrlSetStructuredText parseText BTN_FILTER_TITLE("units",_units);
MENU_ITEM_BY_TAG(_ad,BTN_CREW) ctrlSetStructuredText parseText BTN_FILTER_TITLE("crew",_crew);
MENU_ITEM_BY_TAG(_ad,BTN_VICS) ctrlSetStructuredText parseText BTN_FILTER_TITLE("vehicles",_objects);

_self call [F(menu_updateMenu), [_ad]];