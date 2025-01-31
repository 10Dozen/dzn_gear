#include "defines.h"


params ["_menuNavbar"];

private _currentFilters = dzn_gear_HistoryComponent get Q(Filters);

private _menu = _menuNavbar + [
	["LABEL", "Filter by:", [["w", 0.25], ["bg", COLOR_STEEL_BLUE]]],
	["CHECKBOX", "Personal kits", _currentFilters get "PERSONAL_KIT",
		[["tag", "cb_personalKit"], ["bg", COLOR_STEEL_BLUE]], [
		[
			"MouseButtonClick",
			{
				params["", "_dialogCOB"];
				dzn_gear_HistoryComponent call [F(onFilterChange), [_dialogCOB]];
			}
		]
	]],
	["CHECKBOX", "Cargo kits", _currentFilters get "CARGO_KIT",
		[["tag", "cb_cargoKit"], ["bg", COLOR_STEEL_BLUE]], [
		[
			"MouseButtonClick",
			{
				params["", "_dialogCOB"];
				hint "XXX";
				dzn_gear_HistoryComponent call [F(onFilterChange), [_dialogCOB]];
			}
		]
	]],
	["CHECKBOX", "Composed", _currentFilters get "COMPOSED",
		[["tag", "cb_composed"], ["bg", COLOR_STEEL_BLUE]], [
		[
			"MouseButtonClick",
			{
				params["", "_dialogCOB"];
				dzn_gear_HistoryComponent call [F(onFilterChange), [_dialogCOB]];
			}
		]
	]],
	["BR"],

	["LABEL", "", [["h", 0.02], ["size", 0.02]]],["BR"],
	["DROPDOWN", [], 0, [["tag", "d_entities"], ["h", 0.06]]],
	["BUTTON", "<t size='1'>Show</t>", {
		params ["_dialogCOB"];
		dzn_gear_HistoryComponent call [F(onShow), [_dialogCOB]];
	}, [], [["w", 0.25], ["h", 0.06], ["bg", COLOR_PALE_GREEN]]],
	["BR"],

	["INPUT_AREA", "", [["tag", "ia_content"], ["h", 0.5]]],
	["BR"],
	["LABEL", ""],
	["BUTTON", "Copy", {
		params ["_dialogCOB"];
		dzn_gear_HistoryComponent call [F(onCopy), [_dialogCOB]];
	}, [], [["w", 0.25],["bg", COLOR_PALE_GREEN]]],
	["OnDraw", {
		params["_dialogCOB"];
		dzn_gear_HistoryComponent call [F(renderEntitiesList), [_dialogCOB]];
	}]
];

_menu call dzn_fnc_ShowAdvDialog2;