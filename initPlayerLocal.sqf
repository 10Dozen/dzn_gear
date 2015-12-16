[] spawn {
	if (didJIP) then {
		waitUntil { sleep 1; !isNil "dzn_gear_initialized" && !isNil { player getVariable "dzn_gear" } };
		[player, player getVariable "dzn_gear"] spawn dzn_fnc_gear_assignKit;
	};
};
