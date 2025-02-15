#include "defines.h"

params["_unit", "_identity"];

DBG_ "Params: %1", _this EOL;

_identity params ["", "_face", "_voice", "_name"];

_face = selectRandom ([[_face], _face] select (_face isEqualType []));
if (_face isNotEqualTo "") then { _unit setFace _face };

_voice = selectRandom ([[_voice], _voice] select (_voice isEqualType []));
if (_voice isNotEqualTo "") then { _unit setSpeaker _voice };

/*  Not working for some reason =(
private _name = getItem( (_identity select 3) );
if (_name != "") then {
	if (count (_name splitString " ") < 2) then { _name = format ["%1 %1", _name]; };
	_unit setName [
		_name splitString " " joinString " "
		, (_name splitString " ") select 0
		, (_name splitString " ") select 1
	];
};
*/
