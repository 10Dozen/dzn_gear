/* ----------------------------------------------------------------------------
Function: dzn_gear_fnc_processGameLogics

Description:
	Process all mission placed GameLogics, reads set up kits and assign kits 
	to entities (units, vics) synced with this logics.

	Function runs on both server and clients to decrease network load 
	on mission start if logics are local to players.

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		[] call dzn_gear_fnc_processGameLogics;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#import "..\macro.hpp"

#define PREFIX_OFFSET_GEAR  9
#define PREFIX_OFFSET_CARGO 15

{
	private _logic = _x;
	// -- Check for both infantry and cargo kits
	{
		_x params ["_varNamePrefix","_offset"];

		// -- Get kitname from GameLogic's property or varname
		private _kit = _logic getVariable [_varNamePrefix, nil];
		if (isNil _kit && [_varNamePrefix, str(_logic), false] call BIS_fnc_inString) then {
			_kit = str(_logic) select [_offset];
		};

		// -- Apply found kit to local synced entities
		if (!isNil _kit) then {
			((synchronizedObjects _logic) select { 
				local _x && {isNil (_x getVariable [_varNamePrefix, nil])}}
			) apply {
				_x setVariable [_varNamePrefix, _kit, true];
			};
		};
	} forEach [["dzn_gear", PREFIX_OFFSET_GEAR], ["dzn_gear_cargo", PREFIX_OFFSET_CARGO]];
} forEach (entities "Logic");

#undef PREFIX_OFFSET_GEAR
#undef PREFIX_OFFSET_CARGO
