#include "defines.h"

private _cob = ThisCOB;

_cob set [
	Q(OpenedEH),
	["ace_arsenal_displayOpened", {
		params ["_display"];
		ThisCOB call [F(onArsenalOpened), [_display]];
	}] call CBA_fnc_addEventHandler
];

_cob set [
	Q(ClosedEH),
	["ace_arsenal_displayClosed", {
		// params ["_display"];
		ECOB(Editor,Core) call [F(SetCurrentDisplay), [findDisplay 46]];
		ECOB(Editor,Core) call [F(ShowTotals)];
		if (!isNil "dzn_AdvDialog2") then {
			dzn_AdvDialog2 set [Q(DialogID), ""];
		};
	}] call CBA_fnc_addEventHandler
];
