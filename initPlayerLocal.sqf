// dzn_gear: 
// Waiting until dzn_gear is initialized and then, if player is JIP - wait for "dzn_gear" variable is assigned to change kit
[] spawn {
	waitUntil { sleep 1; !isNil "dzn_gear_initialized" };
	if (didJIP) then {
		waitUntil { sleep 1; !isNil { player getVariable "dzn_gear" } };
		[player, player getVariable "dzn_gear"] spawn dzn_fnc_gear_assignKit;
	};
};
