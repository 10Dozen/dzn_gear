
#include "defines.h"

/*
    Updates menu's filter state
*/
params ["_ad", "_payload"];
private _filtersState = _self get Q(MenuFilters);

DBG_ "_payload = %1", _payload EOL;
DBG_ "Before _filtersState = %1", _filtersState EOL;

if (_payload isEqualType []) then {
    // -- Set filters state - [bool, bool, bool]
    DBG_ "Updating all filters, %1", _filterState EOL;
    { _filtersState set [_forEachIndex, _x]; } forEach _payload;
} else {
    // -- Toggle filter - by idx
    DBG_ "Updating specific filter" EOL;
    _filtersState set [_payload, !(_filtersState # _payload)];
};

DBG_ "_filtersState = %1", _filtersState EOL;

// -- Update filter button color
MENU_ITEM_BY_TAG(_ad,BTN_UNITS) ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_STEEL_BLUE] select (_filtersState # 0));
MENU_ITEM_BY_TAG(_ad,BTN_CREW) ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_STEEL_BLUE] select (_filtersState # 1));
MENU_ITEM_BY_TAG(_ad,BTN_VICS) ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_STEEL_BLUE] select (_filtersState # 2));
