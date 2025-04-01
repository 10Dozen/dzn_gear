#include "defines.h"


params ["_ad"];
private _vals = _ad call ["GetTaggedValues"];
if ((_vals get "i_filter") == "") exitWith {};

private _filterBy = compile (((_vals get "i_filter") splitString ",") apply {
    format ["(_x select [0, count ""%1""] == ""%1"")", trim _x]
} joinString " || ");


DBG_ "_filterBy: %1", _filterBy EOL;
private _kits = dzn_gear_personalKits select _filterBy apply {
    (missionNamespace getVariable _x)
} select { !(_x isEqualType []) }; // Filter out random kits [kit1,kit2,kit3]
DBG_ "Filtered: %1", _kits EOL;

private _composed = _self call [F(compose), [
    _kits,
    (_vals get "s_weaponCount") # 0,
    (_vals get "s_magazineCount") # 0,
    (_vals get "s_itemCount") # 0,
    (_vals get "s_backpackCount") # 0
]];

private _name = _vals getOrDefault ["i_name","cargo_kit_test"];

ECOB(Editor,Core) call [
    F(composeCargoKit),
    ["Cargo", _name, "#34bdeb", _composed, true]
];
