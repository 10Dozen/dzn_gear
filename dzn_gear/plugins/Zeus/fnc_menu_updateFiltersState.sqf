
#include "defines.h"

/*
    Updates menu's filter state
*/
params ["_ad", "_payload"];
private _filtersState = _self get Q(MenuFilters);

DBG_1("_payload = %1", _payload);
DBG_1("Before _filtersState = %1", _filtersState);

if (_payload isEqualType []) then {
    // -- Set filters state - [bool, bool, bool]
    DBG_1("Updating all filters, %1", _filterState);
    { _filtersState set [_forEachIndex, _x]; } forEach _payload;
} else {
    // -- Toggle filter - by idx
    DBG("Updating specific filter");
    _filtersState set [_payload, !(_filtersState # _payload)];
};

DBG_1("_filtersState = %1", _filtersState);

// -- Update filter button color
MENU_ITEM_BY_TAG(_ad,BTN_UNITS) ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_STEEL_BLUE] select (_filtersState # 0));
MENU_ITEM_BY_TAG(_ad,BTN_CREW) ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_STEEL_BLUE] select (_filtersState # 1));
MENU_ITEM_BY_TAG(_ad,BTN_VICS) ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_STEEL_BLUE] select (_filtersState # 2));
