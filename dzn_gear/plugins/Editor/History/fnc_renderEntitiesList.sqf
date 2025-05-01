#include "defines.h"
#define DBG_FUNC_PREFIX "renderEntitiesList"

DBG("Invoked");
params ["_dialogCOB"];
private _filters = _self get Q(Filters);
DBG_1("_filters=%1", _filters);

private _ctrl = _dialogCOB call ["GetByTag", "d_entities"];
lbClear _ctrl;

private _values = [];
{
    _x params ["_type", "_title", "_time", "_content"];

    DBG_1("_x=%1", _x);
    if !(_filters get _type) then {
        DBG("Fileted out!");
        continue;
    };

    (_self get Q(TypeNames) get _type) params ["_typeName", "_typeColor"];
    _values pushBack _content;

    DBG("Adding entity!");
    private _idx = _ctrl lbAdd format [
        "%1 > %2",
        [_time/3600, "HH:MM:SS"] call BIS_fnc_timeToString,
        _title
    ];

    _ctrl lbSetTextRight [_idx, _typeName];
    _ctrl lbSetColorRight [_idx, _typeColor];
} forEach (_self get Q(History));
_ctrl lbSetCurSel -1;

DBG_1("_values=%1", _values);
_ctrl setVariable [Q(listValues), _values];
