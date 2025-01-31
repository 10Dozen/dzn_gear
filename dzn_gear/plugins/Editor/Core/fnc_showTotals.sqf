#include "defines.h"
#define DBG_FUNC_PREFIX "showTotals"

params [["_display", findDisplay 46]];

#define COLOR_ITEM "#aaaaaa"
#define COLOR_MAG "#959c7b"

#define FMT_MARK "<t color='#059CED' align='left' size='0.8'>%2:</t><t align='right' size='0.8'>%1</t>"
#define FMT_MARK2 "<t color='#3F738F' align='left' size='0.8'>%2:</t><t align='right' size='0.8'>%1</t>"

#define FMT_TITLE(X,TITLE) format [FMT_MARK, X call dzn_fnc_getItemDisplayName, TITLE]
#define FMT_TITLE2(X,TITLE) format [FMT_MARK2, X call dzn_fnc_getItemDisplayName, TITLE]
#define FMT_LINE(X) format ["<t color='#aaaaaa' size='0.8'>    %1</t>", X call dzn_fnc_getItemDisplayName]
#define FMT_COUNT_LINE(X,COUNT,COLOR) \
    format [\
        "<t color='#aaaaaa' size='0.8'>    %2x <t color='%3'>%1</t></t>", \
        X call dzn_fnc_getItemDisplayName, COUNT, COLOR \
    ]

private _lines = [
    "<t color='#FFD000' size='1' align='center'>GEAR TOTALS</t>"
];

private ["_item", "_color"];

// -- Guns
{
    _x params ["_item", "_attaches", "_title"];
    if (_item == "") then { continue; };

    _lines pushBack FMT_TITLE(_item,_title);
    { _lines pushBack FMT_LINE(_x); } forEach (_attaches select { _x != "" });
} forEach [
    [primaryWeapon player, primaryWeaponItems player, "Primary"],
    [secondaryWeapon player, secondaryWeaponItems player, "Launcher"],
    [handgunWeapon player, handgunItems player, "Handgun"]
];


// -- Misc
{
    _x params ["_item","_title"];
    if (_item == "") then { continue; };
    _lines pushBack FMT_TITLE2(_item,_title);
} forEach [
	[headgear player, "Headgear"],
	[goggles player, "Facewear"]
];


// -- Uni, Vest & Backpack
{
    _x params ["_item", "_itemList", "_title"];
    if (_item == "") then { continue; };

    _lines pushBack FMT_TITLE2(_item,_title);
    {
        _x params ["_classname", "_count"];
        (_classname call BIS_fnc_itemType) params ["_category"];
        _color = [COLOR_ITEM, COLOR_MAG] select (_category == "Magazine");
        _lines pushBack FMT_COUNT_LINE(_classname,_count,_color);
    } forEach (_itemList call bis_fnc_consolidateArray);
} forEach [
    [uniform player, uniformItems player, "Uniform"],
    [vest player, vestItems player, "Vest"],
    [backpack player, backpackItems player, "Backpack"]
];

// -- Assigned items
_lines pushBack format [FMT_MARK2, "", "Assigned items:"];
_lines pushBack format [
    "<t color='#aaaaaa' size='0.8'>    %1</t>",
    ((assignedItems player) apply { _x call dzn_fnc_getItemDisplayName }) joinString ", "
];

private _totalText = _lines joinString "<br/>";

if (_self get Q(TotalsShown)) exitWith {
    // Update
    DBG_ "Modify!" EOL;
    ["MODIFY", _display, TOTALS_LABEL_TAG, [
        ["title", _totalText]
    ]] call dzn_fnc_HandleControl;
};

DBG_ "Show!" EOL;
[
    "ADD",_display, TOTALS_LABEL_TAG,
    ["LABEL", _totalText, [
        ["h", 2],
        ["w", 0.4],
        ["x", 0.8],
        ["y", -0.1],
        ["bg", [0,0,0,0.75]]
    ]]
] call dzn_fnc_HandleControl;

_self set [Q(TotalsShown), true];