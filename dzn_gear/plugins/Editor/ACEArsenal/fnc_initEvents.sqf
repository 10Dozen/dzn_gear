#include "defines.h"

ThisCOB set [
	Q(OpenedEH),
	["ace_arsenal_displayOpened", {
		params ["_display"];
		ThisCOB call [F(onArsenalOpened), [_display]];
	}] call CBA_fnc_addEventHandler
];