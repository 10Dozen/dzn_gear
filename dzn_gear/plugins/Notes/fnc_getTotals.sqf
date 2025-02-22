#include "defines.h"

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
params ["_name", "_role", "_loadout"];

// -- Prepare content
private _lines = [
    format [
        "<font size='16'><font color='#FFD000'>%1</font> (%2)</font>",
        _name,
        trim (_role)
    ]
];

// -- Total weights
private _load = parseNumber (MASS_TO_KG(_loadout # 10));
_lines pushBack format [
    TOTALS_WEIGHT_F,
    _load
];
_lines pushBack "<font color='#cccccc'>------</font>";

// -- Guns
private ["_gun", "_mag", "_attaches", "_attach"];
{
    _x params ["_title", "_wd"];
    if (_wd isEqualTo []) then { continue; };

    _attaches = [_wd # 1, _wd # 2, _wd # 3, _wd # 6];
    (_wd # 4) params [["_mag", ""]];
    _gun = _wd # 0;

    _lines pushBack FMT_TITLE(_gun,_title);

    DBG_ "_mag = %1", _mag EOL;
    if (_mag isNotEqualTo "") then {
        _lines pushBack FMT_PREFIX_MAG_LINE(_mag);
    };

    {
        _attach = _attaches # _forEachIndex;
        if (_attach == "") then { continue };
        _lines pushBack FMT_PREFIX_LINE(_x,_attach);
    } forEach ["MZL", "PTR", "OPT", "BPD"];
} forEach [
    [TOTALS_PRIMARY, _loadout # 0],
    [TOTALS_SECONDARY, _loadout # 1],
    [TOTALS_HANDGUN, _loadout # 2]
];


_lines pushBack "<font color='#aaaaaa'>------</font>";
// -- Misc
{
    _x params ["_title", "_item"];
    if (_item == "") then { continue; };
    _lines pushBack FMT_TITLE2(_item,_title);
} forEach [
    [TOTALS_HEADGEAR, _loadout # 6],
    [TOTALS_FACEWEAR, _loadout # 7]
];

// -- Uni, Vest & Backpack
{
    _x params ["_title", "_eq"];
    if (_eq isEqualTo []) then { continue; };
    _eq params ["_eqCls", "_items"];

    _lines pushBack FMT_TITLE2(_eqCls,_title);
    private "_color";
    {
        _x params ["_classname", "_count"];

        (_classname call BIS_fnc_itemType) params ["_category", "_subcategory"];

        if (_category isEqualTo "Magazine") then {
            _color = [
                COLOR_MAG,
                COLOR_THROWABLE
            ] select (_subcategory in ["Grenade", "SmokeShell","UnknownMagazine"]);

            _lines pushBack FMT_COUNT_LINE(_classname,_count,_color);
            continue;
        };

        _lines pushBack FMT_COUNT_LINE(_classname,_count,COLOR_ITEM);
    } forEach _items;
} forEach [
    [TOTALS_VEST, _loadout # 4],
    [TOTALS_BACKPACK, _loadout # 5],
    [TOTALS_UNIFORM, _loadout # 3]
];

// -- Assigned items
_lines pushBack format [FMT_MARK2, "", TOTALS_ASSIGNED];
_lines pushBack format [
    "<font color='#aaaaaa'>    %1</font>",
    (((_loadout # 9) + (_loadout # 8)) select { _x != "" } apply { ITEM_CLICKABLE(_x) }) joinString ", "
];

(_lines joinString "<br/>")
