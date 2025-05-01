#include "defines.h"
#define DBG_FUNC_PREFIX "fnc_showTotals"

params [];

#define COLOR_ITEM "#cccccc"
#define COLOR_MAG "#a7b37b"
#define COLOR_MAG_FAV "#96ad3e"
#define COLOR_THROWABLE "#d9b5a0"

#define FMT_MARK "<t color='#059CED' align='left' size='0.8'>%2:</t><t align='right' size='0.8' color='#a0d0eb'>%1</t>"
#define FMT_MARK2 "<t color='#0270ab' align='left' size='0.8'>%2:</t><t align='right' size='0.8' color='#a0d0eb'>%1</t>"

#define FMT_TITLE(X,TITLE) format [FMT_MARK, X call dzn_fnc_getItemDisplayName, TITLE]
#define FMT_TITLE2(X,TITLE) format [FMT_MARK2, X call dzn_fnc_getItemDisplayName, TITLE]
#define FMT_LINE(X) format ["<t color='#cccccc' size='0.8'>    %1</t>", X call dzn_fnc_getItemDisplayName]
#define FMT_PREFIX_LINE(PREFIX,X) \
    format [\
        "<t color='#cccccc' size='0.8'>    <t size='0.6' color='#888888'>%2</t> <t align='right'>%1</t></t>",\
        X call dzn_fnc_getItemDisplayName, PREFIX\
    ]
#define FMT_PREFIX_MAG_LINE(X) \
    format [ \
        "<t color='" + COLOR_MAG_FAV + "' size='0.8'>    <t size='0.6'>MAG</t> <t align='right'>%1</t></t>",\
        X call dzn_fnc_getItemDisplayName\
    ]
#define FMT_COUNT_LINE(X,COUNT,COLOR) \
    format [\
        "<t color='#cccccc' size='0.8'>    %2x <t color='%3'>%1</t></t>", \
        X, COUNT, COLOR \
    ]

DBG_1("Params: %1", _this);

if !(_self get Q(TotalsShow)) exitWith {
    DBG("Totals are disabled - no render");
    ["REMOVE", _self get Q(CurrentDisplay), TOTALS_LABEL_TAG] call dzn_fnc_HandleControl;
};

// -- Prepare content
private _favoriteMags = ["","",""];
private _lines = ["<t color='#FFD000' size='1' align='center'>GEAR TOTALS</t>"];

// -- Total weights
private _load = parseNumber (MASS_TO_KG(loadAbs player));
_lines pushBack format [
    "<t color='%2' align='center' size='1'>%1 kg total</t>",
    _load,
    [
        ["#ff564a", "#fae38e"] select (_load <= 36),
        "#cccccc"
    ] select (_load <= 33)
];

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
    ["Primary", primaryWeapon player, primaryWeaponItems player, primaryWeaponMagazine player],
    ["Launcher", secondaryWeapon player, secondaryWeaponItems player, secondaryWeaponMagazine player],
    ["Handgun", handgunWeapon player, handgunItems player, handgunMagazine player]
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
    private "_color";
    {
        _x params ["_classname", "_count"];

        (_classname call BIS_fnc_itemType) params ["_category", "_subcategory"];
        _color = COLOR_ITEM;

        if (_category isEqualTo "Magazine") then {
            private _favedMagIdx = _favoriteMags find (_x # 0);
            DBG_3("Fav mags: %1, _x=%2, _favedMagIdx=%3", _favoriteMags, _x , _favedMagIdx);

            _color = [
                [COLOR_MAG, COLOR_MAG_FAV] select (_favedMagIdx > -1),
                COLOR_THROWABLE
            ] select (_subcategory in ["Grenade", "SmokeShell","UnknownMagazine"]);

            if (_favedMagIdx == -1) then {
                _classname = _classname call dzn_fnc_getItemDisplayName;
            } else {
                _classname = [MAG_PRIMARY, MAG_LAUNCHER, MAG_HANDGUN] select _favedMagIdx;
            };

            _lines pushBack FMT_COUNT_LINE(_classname,_count,_color);
            continue;
        };

        _lines pushBack FMT_COUNT_LINE(_classname call dzn_fnc_getItemDisplayName,_count,_color);
    } forEach (_itemList call bis_fnc_consolidateArray);
} forEach [
    [uniform player, uniformItems player, "Uniform"],
    [vest player, vestItems player, "Vest"],
    [backpack player, backpackItems player, "Backpack"]
];

// -- Assigned items
_lines pushBack format [FMT_MARK2, "", "Assigned items"];
_lines pushBack format [
    "<t color='#aaaaaa' size='0.8'>    %1</t>",
    ((assignedItems player) apply { _x call dzn_fnc_getItemDisplayName }) joinString ", "
];

private _totalText = _lines joinString "<br/>";

// -- Render
private _display = _self get Q(CurrentDisplay);
DBG_1("Target dispaly: %1", _display);

if !(["EXISTS", _display, TOTALS_LABEL_TAG] call dzn_fnc_HandleControl) exitWith {
    DBG_1("Create new", _this);
    private _positionAttrs = (_self get Q(TotalsRenderSettings)) select (_display isNotEqualTo (findDisplay 46));
    [
        "ADD",_display, TOTALS_LABEL_TAG,
        ["LABEL", _totalText, [
            ["bg", [0,0,0,0.65]],
            // ["h", 2],
            ["w", 0.4],
            ["adjustHeight", true]
        ] + _positionAttrs]
    ] call dzn_fnc_HandleControl;
};

DBG("Modify existing");
["MODIFY", _display, TOTALS_LABEL_TAG, [["title", _totalText]]] call dzn_fnc_HandleControl;
