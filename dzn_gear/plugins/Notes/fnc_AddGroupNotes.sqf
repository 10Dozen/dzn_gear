#include "defines.h"

DBG_ "Params: %1", _this EOL;
params ["_units"];

private _output = [
	format ["<t size='14' color='%2'>%1</t>", groupId group player, COLOR_HEX_GOLD],
	""
];

private _notes = _self get Q(SharedNotes);
private ["_role", "_name", "_noteIdx"];
{
	_role = ((roleDescription _x) splitString "@") # 0;
	_name = name _x;
	
	_noteIdx = _notes pushBack (_x getVariable [Q(dzn_gear_Note), []]);

	_output pushBack format [
		"<t color='%'>%1</t> - %2 (%3) [See more]",
		_role, 
		_name,
		_noteIdx,
		COLOR_HEX_LIGHT_GREEN
	];
} forEach _units;
private _output = _self call [F(getTotals), [player]];

player createDiaryRecord ["Diary", [_self get Q(Settings) get Q(Group) get Q(title), _output]];
