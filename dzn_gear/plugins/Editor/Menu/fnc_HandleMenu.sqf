#include "defines.h"
/*
    Handles menu open/change.

    Params:
    0: _paginationDirection -- direction of pagination. Optional, defaults to 0 (stay on last page).

    Returns:
    nothing
*/

params [["_paginationDirection", 0]];

private _maxIdx = count (_self get Q(Pages)) - 1;
private _getInRangeIndex = {
    params ["_idx"];
    [
        [_idx, 0] select (_idx > _maxIdx),
        _maxIdx
    ] select (_idx < 0)
};


private _targetPageIdx = [(_self get Q(PageIdx)) + _paginationDirection] call _getInRangeIndex;
_self set [Q(PageIdx), _targetPageIdx];

private _targetPage = (_self get Q(Pages)) # _targetPageIdx;
private _prevPage = (_self get Q(Pages)) # ([_targetPageIdx - 1] call _getInRangeIndex);
private _nextPage = (_self get Q(Pages)) # ([_targetPageIdx + 1] call _getInRangeIndex);

private _menu = [
    ["DIALOG", [["dialogShowTime", [0, 0.15] select (_paginationDirection == 0)]]],
    ["HEADER", "dzn_Gear Menu"],
    [
        "BUTTON",
        "<t align='center'>&lt;</t>",
        {
            params ["_ad"];
            ThisCOB call [F(HandleMenu), [-1]];
        }, [],
        [["w", 0.25], ["size", 0.05], ["tooltip", _prevPage get "title"]]
    ],
    [
        "LABEL",
        format ["<t align='center'>%1</t>", _targetPage get "title"],
        [
            ["bg", [0,0,0,1]],
            ["size", 0.05],
            ["tooltip", _targetPage get "description"]
        ]
    ],
    [
        "BUTTON",
        "<t align='center'>&gt;</t>",
        {
            params ["_ad"];
            ThisCOB call [F(HandleMenu), [+1]];
        }, [],
        [["w", 0.25], ["size", 0.05], ["tooltip", _nextPage get "title"]]
    ],
    ["BR"]
];

_self call [(_targetPage get "renderer"), [_menu]];