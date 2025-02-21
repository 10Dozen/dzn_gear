#include "defines.h"

/*
	Update menu controls depending on current selected units/vehicles and 
	menu options.
	
	Params:
	0: _advDialog 
*/

params ["_ad"];

(_self get Q(MenuFilters)) params ["_applyToUnits", "_applyToCrew", "_applyToObjects"];
((_self get Q(ZeusLastSelected)) apply { _x isNotEqualTo [] }) params [
	"_hasUnits", "_hasCrew", "_hasVics"
];

// -- Toggle unit-only controls
MENU_ITEM_BY_TAG(_ad,BTN_ARSENAL) ctrlEnable (_applyToUnits && _hasUnits);

// -- Toggles unit+crew controls
private _state = (_applyToUnits && _hasUnits) || (_applyToCrew && _hasCrew);
{ MENU_ITEM_BY_TAG(_ad,_x) ctrlEnable _state; } forEach [
	BTN_ADD_ITEM, 
	BTN_REMOVE_ITEM
];

// -- Toggle other contrls 
_state = (_applyToUnits && _hasUnits) || (_applyToCrew && _hasCrew) || (_applyToObjects && _hasVics);
{ MENU_ITEM_BY_TAG(_ad,_x) ctrlEnable _state; } forEach [
	BTN_APPLY_KIT,
	BTN_COPY,
	BTN_APPLY,
	BTN_CREATE,
	BTN_CLEAR
];
