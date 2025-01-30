#include "defines.h"


params ["_ad"];
private _vals = _ad call ["GetTaggedValues"];
if ((_vals get "i_filter") == "") exitWith {};
private _filterBy = compile ((
	(_vals get "i_filter") splitString ","
) apply {
	format ["(_x select [0, count ""%1""] == ""%1"")", trim _x]
} joinString " || ");

private _kits = (allVariables missionNamespace) select _filterBy apply {
	missionNamespace getVariable _x
} select { (_x # 0) isEqualType [] };
DBG_ "Filtered: %1", _kits EOL;

private _composed = [
	_kits,
	(_vals get "s_weaponCount") # 0,
	(_vals get "s_magazineCount") # 0,
	(_vals get "s_itemCount") # 0,
	(_vals get "s_backpackCount") # 0
] call dzn_fnc_gear_editMode_composeCargoItemsFromKits;
private _name = _vals getOrDefault ["i_name","cargo_kit_test"];
private _exported = [_name, _composed ] call dzn_fnc_gear_editMode_formatCargoKit;
copyToClipboard _exported;

dzn_gear_HistoryComponent call [F(add), [HISTORY_COMPOSED, _name, _exported]];

["KIT_COPIED", ["Cargo", "#FFCC00"]] call dzn_fnc_gear_editMode_showNotif;
	