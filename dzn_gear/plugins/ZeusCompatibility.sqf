// ******** Gear Zeus Compatibility Plug-in ************
// ****************************************************
//
//
// ******************** Settings **********************



// ********************** FNC ************************
dzn_fnc_gear_zc_initialize = {
	dzn_gear_zc_keyIsDown = false;
	
	dzn_gear_zc_KitsList = [];
	[true] spawn dzn_fnc_gear_zc_collectKitNames;
	
	waitUntil { !(isNull (findDisplay 312)) };	
	(findDisplay 312) displayAddEventHandler ["KeyDown", "_handled = _this call dzn_fnc_gear_zc_onKeyPress"];
};

dzn_fnc_gear_zc_collectKitNames = {
	private _delay = if (!isNil {_this select 0} && {_this select 0}) then { 1 } else { 0 };
	
	{
		private _kitname = _x getVariable ["dzn_gear", ""];
		if ( (_kitname != "") && !(_kitname in dzn_gear_zc_KitsList) ) then {
			dzn_gear_zc_KitsList pushBack _kitname;
		};
		
		sleep _delay;
	} forEach allUnits;
};

dzn_fnc_gear_zc_onKeyPress = {
	[] spawn dzn_fnc_gear_zc_collectKitNames;
	if (dzn_gear_zc_keyIsDown) exitWith {};
	
	private["_key","_shift","_crtl","_alt","_handled"];	
	_key = _this select 1; 
	_shift = _this select 2; 
	_ctrl = _this select 3; 
	_alt = _this select 4;
	_handled = false;
	
	switch _key do {
		// See for key codes -- https://community.bistudio.com/wiki/DIK_KeyCodes
		// G1 button
		case 34: {
			SET_KEYDOWN;
			call dzn_fnc_gear_editMode_showKeybinding;
			SET_HANDLED;
		};
	};

	[] spawn { sleep 1; dzn_gear_zc_keyIsDown = false; };
	_handled
};

dzn_fnc_gear_zc_showMenu = {
	
	private _result = [
		"dzn_Gear Zeus Tool"
		, [
			["Kits", dzn_gear_zc_KitsList]
			, ["Custom", ""]
		]
	] call dzn_fnc_ShowChooseDialog;

	waitUntil {!dialog};
	
};
