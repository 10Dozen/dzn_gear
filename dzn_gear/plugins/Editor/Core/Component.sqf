#include "defines.h"

#define DBG_FUNC_PREFIX "ComponentConstructor"

params ["_settings"];

private _convertKeysToDatatypes = {
	_this deleteAt "#SOURCE";
	_this deleteAt "#ERRORS";
	private _toDelete = [];
	{
		if (_x isEqualType "") then {
			_this set [parseNumber _x, _y];
			_toDelete pushBack _x;
		};
	} forEach _this;
	{ _this deleteAt _x } forEach _toDelete;
	_this
};

private _keybinds = (["dzn_gear\plugins\Editor\Core\Keybinding.yml","PREPROCESS_FILE"] call dzn_fnc_parseSFML) call _convertKeysToDatatypes;
private _messages = (["dzn_gear\plugins\Editor\Core\Messages.yml","PREPROCESS_FILE"] call dzn_fnc_parseSFML) call _convertKeysToDatatypes;

private _declaration = [
	[Q(Settings), _settings],
	[Q(OverrideUniformItems), ""],
	[Q(OverrideAssignedItems), ""],

	[Q(TotalsTargetDisplay), displayNull],

	[Q(Keybinds), _keybinds],
	[Q(Messages), _messages],

    // -- Public
	PREP_COMPONENT_FUNCTION(InitEvents),

    PREP_COMPONENT_FUNCTION(Notify),
	PREP_COMPONENT_FUNCTION(ShowKeybinds),
	PREP_COMPONENT_FUNCTION(ShowTotals),

	PREP_COMPONENT_FUNCTION(CreateKit),
	PREP_COMPONENT_FUNCTION(FormatKit),
	PREP_COMPONENT_FUNCTION(ClearGear),

	PREP_COMPONENT_FUNCTION(onKeyPressed),
	PREP_COMPONENT_FUNCTION(composeUnitKit),
	PREP_COMPONENT_FUNCTION(composeCargoKit)
];

private _cob = createHashMapObject [_declaration];

_cob
