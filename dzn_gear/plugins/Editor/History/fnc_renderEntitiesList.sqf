#include "defines.h"
#define DBG_FUNC_PREFIX "renderEntitiesList"

DBG_ "Invoked" EOL;
params ["_dialogCOB"];
private _filters = _self get Q(Filters);
DBG_ "_filters=%1", _filters EOL;

private _ctrl = _dialogCOB call ["GetByTag", "d_entities"];
lbClear _ctrl;

private _values = [];
{
	_x params ["_type", "_title", "_time", "_content"];

	DBG_ "_x=%1", _x EOL;
	if !(_filters get _type) then {
		DBG_ "Fileted out!", _x EOL;
		continue;
	};

	(_self get Q(TypeNames) get _type) params ["_typeName", "_typeColor"];
	_values pushBack _content;

	DBG_ "Adding entity!", _x EOL;
	private _idx = _ctrl lbAdd format [
		"%1 > %2",
		[_time/3600, "HH:MM:SS"] call BIS_fnc_timeToString,
		_title
	];
	
	_ctrl lbSetTextRight [_idx, _typeName];
	_ctrl lbSetColorRight [_idx, _typeColor];
} forEach (_self get Q(History));
_ctrl lbSetCurSel -1;

DBG_ "_values=%1", _values EOL;
_ctrl setVariable [Q(listValues), _values];