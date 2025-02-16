#include "defines.h"

params ["_unit"];

#define COLOR_ITEM "#cccccc"
#define COLOR_MAG "#a7b37b"
#define COLOR_MAG_FAV "#96ad3e"
#define COLOR_THROWABLE "#d9b5a0"

#define ITEM_CLICKABLE(ITEM) format ['<execute expression="dzn_gear_NotesComponent call [''fnc_showItemInfo'', ''%1'']">%2</execute>', ITEM, ITEM call dzn_fnc_getItemDisplayName]

#define FMT_MARK "<font color='#059CED' align='left' >%2:</font> <font align='right' color='#dddddd'>%1</font>"
#define FMT_MARK2 "<font color='#059CED' align='left' >%2:</font> <font align='right' color='#dddddd'>%1</font>"

#define FMT_TITLE(X,TITLE) format [FMT_MARK, ITEM_CLICKABLE(X), TITLE]
#define FMT_TITLE2(X,TITLE) format [FMT_MARK2, ITEM_CLICKABLE(X), TITLE]
#define FMT_LINE(X) format ["<font color='#cccccc' >    %1</font>", ITEM_CLICKABLE(X)]
#define FMT_PREFIX_LINE(PREFIX,X) \
    format [\
        "<font color='#cccccc'>    <font size='10' color='#888888'>%2</font> <font align='right'>%1</font></font>",\
        ITEM_CLICKABLE(X), PREFIX\
    ]
#define FMT_PREFIX_MAG_LINE(X) \
    format [ \
        "<font color='" + COLOR_MAG_FAV + "'>    <font size='10'>MAG</font> <font align='right'>%1</font></font>",\
        ITEM_CLICKABLE(X)\
    ]
#define FMT_COUNT_LINE(X,COUNT,COLOR) \
    format [\
        "<font color='#cccccc'>    %2x <font color='%3'>%1</font></font>", \
        ITEM_CLICKABLE(X), COUNT, COLOR \
    ]

DBG_ "Params: %1", _this EOL;

// -- Prepare content
private _favoriteMags = ["","",""];
private _lines = [
    format [
        "<font color='#FFD000' align='center' size='16'>%1</font>",
        [name player, trim (roleDescription _unit)] select (roleDescription _unit != "")
    ]
];

// -- Total weights
private _load = parseNumber (MASS_TO_KG(loadAbs _unit));
_lines pushBack format [
    "<font>Общий вес: %1 кг</font>",
    _load
];
_lines pushBack "<font color='#cccccc'>------</font>";

// -- Guns
{
    _x params ["_title", "_item", "_attaches", "_mag"];
    if (_item == "") then { continue; };

    _lines pushBack FMT_TITLE(_item,_title);

    if (_mag isNotEqualTo []) then {
        _lines pushBack FMT_PREFIX_MAG_LINE(_mag select 0);
        _favoriteMags set [_forEachIndex, (_mag select 0)];
    };

    private "_attach";
    {
        private _attach = _attaches # _forEachIndex;
        if (_attach == "") then { continue };
        _lines pushBack FMT_PREFIX_LINE(_x,_attach);
    } forEach ["MZL", "PTR", "OPT", "BPD"];

    // { _lines pushBack FMT_PREFIX_LINE(_x); } forEach (_attaches select { _x != "" });
} forEach [
    ["Primary", primaryWeapon _unit, primaryWeaponItems _unit, primaryWeaponMagazine _unit],
    ["Launcher", secondaryWeapon _unit, secondaryWeaponItems _unit, secondaryWeaponMagazine _unit],
    ["Handgun", handgunWeapon _unit, handgunItems _unit, handgunMagazine _unit]
];


_lines pushBack "<font color='#aaaaaa'>------</font>";
// -- Misc
{
    _x params ["_item","_title"];
    if (_item == "") then { continue; };
    _lines pushBack FMT_TITLE2(_item,_title);
} forEach [
	[headgear _unit, "Headgear"],
	[goggles _unit, "Facewear"]
];

// -- Uni, Vest & Backpack
{
    _x params ["_item", "_itemList", "_title"];
    if (_item == "") then { continue; };

    _lines pushBack FMT_TITLE2(_item,_title);
    private "_color";
    {
        _x params ["_classname", "_count"];

        (_classname call BIS_fnc_itemType) params ["_category", "_subcategory"];
        _color = COLOR_ITEM;

        if (_category isEqualTo "Magazine") then {
            private _favedMagIdx = _favoriteMags find (_x # 0);
            DBG_ "Fav mags: %1, _x=%2, _favedMagIdx=%3", _favoriteMags, _x , _favedMagIdx EOL;

            _color = [
                [COLOR_MAG, COLOR_MAG_FAV] select (_favedMagIdx > -1),
                COLOR_THROWABLE
            ] select (_subcategory in ["Grenade", "SmokeShell"]);

            _lines pushBack FMT_COUNT_LINE(_classname,_count,_color);
            continue;
        };

        _lines pushBack FMT_COUNT_LINE(_classname,_count,_color);
    } forEach (_itemList call bis_fnc_consolidateArray);
} forEach [
    [vest _unit, vestItems _unit, "Vest"],
    [backpack _unit, backpackItems _unit, "Backpack"],
    [uniform _unit, uniformItems _unit, "Uniform"]
];

// -- Assigned items
_lines pushBack format [FMT_MARK2, "", "Assigned items"];
_lines pushBack format [
    "<font color='#aaaaaa'>    %1</font>",
    ((assignedItems _unit) apply { ITEM_CLICKABLE(_x) }) joinString ", "
];

(_lines joinString "<br/>")



