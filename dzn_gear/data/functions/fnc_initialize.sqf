/* ----------------------------------------------------------------------------
Function: dzn_gear_fnc_initialize

Description:
	Initialize core dzn_Gear and run process of kit assignment

Parameters:
	nothing

Returns:
	nothing

Examples:
    (begin example)
		[] call dzn_gear_fnc_initialize;
    (end)

Author:
	10Dozen
---------------------------------------------------------------------------- */

#import "..\macro.hpp"

// --- Wait for player to be initialized
if (hasInterface && isMultiplayer) exitWith {
	[
		{ !isNull player && {local player} }
		, { [] call FUNC(initialize) }
	] call CBA_fnc_waitUntilAndExecute;
};

[] call FUNC(processGameLogics);
[] call FUNC(processEntities);

GVAR(initDone) = true;
if (isServer) then {
	GVAR(serverInitDone) = true;
	publicVariable SVAR(serverInitDone);
};

// TODO: Indentity loop?