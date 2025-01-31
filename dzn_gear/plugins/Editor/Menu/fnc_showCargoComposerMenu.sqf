#include "defines.h"


params ["_menuNavbar"];


#define MENU_CARGO_COMPOSER_WIDTH 0.3
#define MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH 0.075
private _menu = _menuNavbar + [
	["LABEL", "<t size='0.9'>Enter full name of the personal kit or prefix (like ""kit_usmc_"") to generate cargo kit.</t>"],
	["BR"],
	["LABEL", "<t size='0.9'>You can also enter several names using comma.</t>"],
	["BR"],
	["LABEL", format [
		"<t size='0.9'><t color='%1'>Note:</t> Uniform items will be ignored for session-generated kits.</t>",
		COLOR_HEX_BRICK_RED
	]],
	["BR"],

	["LABEL", format [
		"<t color='%1'>Filter (personal kits)*</t>",
		COLOR_HEX_LIGHT_BLUE
	], [["w", MENU_CARGO_COMPOSER_WIDTH], ["bg", COLOR_STEEL_BLUE]]],
	["INPUT", "", [["tag", "i_filter"]]],
	["BR"],
	["LABEL", "Export name", [["w", MENU_CARGO_COMPOSER_WIDTH], ["bg", COLOR_STEEL_BLUE]]],
	["INPUT", "cargo_kit_test", [["tag", "i_name"], ["tooltip", "Name of the generated cargo kit"]]],
	["BR"],

	["LABEL", "Weapons count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
	["LABEL", "<t align='right'>x2</t>", [["tag", "l_counterW"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
	["SLIDER", [1,30,1], 2, [["tag", "s_weaponCount"], ["tooltip", "Number of weapons in generated kit"]], [
		["SliderPosChanged", _onSliderChanged, "l_counterW"]
	]],
	["BR"],

	["LABEL", "Magazines count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
	["LABEL", "<t align='right'>x20</t>", [["tag", "l_counterM"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
	["SLIDER", [1,30,1], 20, [["tag", "s_magazineCount"], ["tooltip", "Number of magazines in generated kit"]], [
		["SliderPosChanged", _onSliderChanged, "l_counterM"]
	]],
	["BR"],

	["LABEL", "Item count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
	["LABEL", "<t align='right'>x10</t>", [["tag", "l_counterI"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
	["SLIDER", [1,30,1], 10, [["tag", "s_itemCount"], ["tooltip", "Number of items in generated kit"]], [
		["SliderPosChanged", _onSliderChanged, "l_counterI"]
	]],
	["BR"],

	["LABEL", "Backpack count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
	["LABEL", "<t align='right'>x1</t>", [["tag", "l_counterB"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
	["SLIDER", [1,30,1], 1, [["tag", "s_backpackCount"], ["tooltip", "Number of backpacks in generated kit"]], [
		["SliderPosChanged", _onSliderChanged, "l_counterB"]
	]],
	["BR"],

	["LABEL"],["BR"],
	["LABEL"],
	["BUTTON", "<t align='center'>Compose</t>", _onButtonClick, [],[["w", 0.25], ["bg", COLOR_PALE_GREEN]]]
];
_menu call dzn_fnc_ShowAdvDialog2;