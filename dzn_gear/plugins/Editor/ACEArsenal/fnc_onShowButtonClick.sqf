#include "defines.h"

params ["_isMainCategory"];

DBG_ "Params: %1", _this EOL;

private _display = _self get Q(Display);

private _category = _self get Q(CurrentCategory);
private _classname = _self get Q(CurrentItemSelected);
private _dialogID = DIALOG_ID_ITEM_POOL;
if (!_isMainCategory) then {
    _category = _category * (_self get Q(CurrentSubCategory));
    _classname = _self get Q(CurrentSelectedRightItem);
    _dialogID = DIALOG_ID_SUBCAT_ITEM_POOL;
};

private _categoryTitle = (_self get Q(Categories)) getOrDefault [_category, ""];
if (_categoryTitle == "") then {
    _categoryTitle = format [
        "%1 - %2",
        (_self get Q(Categories)) get (_self get Q(CurrentCategory)),
        (_self get Q(Categories)) get (_self get Q(CurrentSubCategory))
    ]
};

private _items = _self get Q(ItemPools) getOrDefault [_category, []];
private _itemsShare = [];
private _totalCount = count _items;

DBG_ "Items to display: %1", _items EOL;

private _menu = [
    ["DIALOG", [["dialog", _display],["w", 0.6],["x", 0.2],["dialogShowTime", 0],["dialogID", _dialogID]]],
    ["HEADER", format ["%1 (%2 items)", _categoryTitle, _totalCount]]
];


// -- Plain list items to format of 33% Itemname
{
    DBG_ "%1", _x EOL;
    _x params ["_classname", "_count"];
    _itemsShare pushBack [
        _classname,
        _count,
        format [
            "<t color='#cccccc'>%1</t> %2",
            (_count / _totalCount * 100 toFixed 0) + "%",
            [
                _self call [F(getItemData), [_category, _classname]],
                "&lt; no item &gt;"
            ] select (_classname isEqualType "" && {_classname == ""})
        ]
    ];
} forEach (_items call BIS_fnc_consolidateArray);


DBG_ "Composing menu" EOL;
{
    DBG_ "%1", _x EOL;
    _x params ["_classname", "_count", "_itemTitle"];

    _menu pushBack ["LABEL", _itemTitle, [
        ["w", 0.8],
        ["adjustHeight", true],
        ["tooltip", "TBD: Mod name goes here!"]
    ]];

    _menu pushBack ["BUTTON", "<t align='center'>+</t>", {
        params ["_dialogCOB", "_args"];
        _args params ["_isMainCategory", "_categoryAndItem"];
        ThisCOB call [F(addItemToPool), _categoryAndItem];
        ThisCOB call [F(onShowButtonClick), [_isMainCategory]];

    }, [_isMainCategory, [_category, _classname]], [["h", 0.08]]];

    _menu pushBack ["BUTTON",
        "<t align='center'>-</t>",
        {
            params ["_dialogCOB", "_args"];
            _args params ["_isMainCategory", "_categoryAndItem"];
            ThisCOB call [F(removeItemFromPool), _categoryAndItem];
            ThisCOB call [F(onShowButtonClick), [_isMainCategory]];
        },
        [_isMainCategory, [_category, _classname]],
        [["bg", [COLOR_PALE_RED, COLOR_BLACK] select (_count > 1)], ["h", 0.08]]
    ];
    _menu pushBack ["BR"];
} forEach _itemsShare;


if (_items isEqualTo []) then {
    _menu pushBack ["LABEL"];
} else {
    _menu pushBack ["LABEL", ""];
    _menu pushBack ["BR"];
    _menu pushBack ["BUTTON", "<t align='center'>Reset</t>", {
        params ["", "_args"];
        ThisCOB call [F(onResetButtonClick), _args];
    }, [_isMainCategory], [["w",0.25], ["bg", COLOR_PALE_RED], ["tooltip", "Reset item pool!"]]];
    _menu pushBack ["LABEL", ""];
    _menu pushBack ["BUTTON", "<t align='center'>Copy</t>", {
        params ["", "_args"];
        ThisCOB call [F(onExportButtonClick), _args];
    }, [_isMainCategory], [["w",0.25], ["bg", COLOR_PALE_GREEN]]];
};

_menu call dzn_fnc_ShowAdvDialog2;
