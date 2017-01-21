// ******** Gear Zeus Compatibility Plug-in ************
// ****************************************************
//
//
// ******************** Settings **********************



// ********************** FNC ************************
dzn_fnc_gear_zc_initialize = {
	dzn_gear_zc_keyIsDown = false;
	dzn_gear_zc_displayEH = nil;
	dzn_gear_zc_KitsList = [];	
	
	dzn_gear_zc_canCollectKits = true;
	dzn_gear_zc_waitAncCheck = { dzn_gear_zc_canCollectKits = false; sleep count(allUnits); dzn_gear_zc_canCollectKits = true; };
	["GearZeusCompatibility", "onEachFrame", {	
		if (dzn_gear_zc_canCollectKits) then {
			[] spawn dzn_gear_zc_waitAncCheck;
			[] spawn dzn_fnc_gear_zc_collectKitNames;
		};
		
		if (!isNull (findDisplay 312) && isNil "dzn_gear_zc_displayEH") then {		
			dzn_gear_zc_displayEH = (findDisplay 312) displayAddEventHandler [
				"KeyDown"
				, "_handled = _this call dzn_fnc_gear_zc_onKeyPress"
			];
		} else {
			if (isNull (findDisplay 312) && !isNil "dzn_gear_zc_displayEH") then {
				dzn_gear_zc_displayEH = nil;
			};
		};
	}] call BIS_fnc_addStackedEventHandler;
};

dzn_fnc_gear_zc_collectKitNames = {
	{
		private _kitname = _x getVariable ["dzn_gear", ""];
		if ( (_kitname != "") && !(_kitname in dzn_gear_zc_KitsList) ) then {
			dzn_gear_zc_KitsList pushBack _kitname;
		};
		
		sleep 1;
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
			dzn_gear_zc_keyIsDown = true;
			[] spawn dzn_fnc_gear_zc_processMenu;
			_handled = true;
		};
	};

	[] spawn { sleep 1; dzn_gear_zc_keyIsDown = false; };
	_handled
};

dzn_fnc_gear_zc_processMenu = {
	private _unitsSelected = curatorSelected select 0; // [[Objects],[Groups],[Waypoints],[Markers]]
	// private _groupsSelected = curatorSelected select 1; // [[Objects],[Groups],[Waypoints],[Markers]]
	
	if (_unitsSelected isEqualTo []) exitWith {
		hint parseText "<t size='1' color='#FFD000' shadow='1'>Zeus Gear Tool:</t><br />No Unit Selected!";
	};
	
	private _units = [];
	{
		if (_x isKindOf "CAManBase") then {
			_units  pushBack _x
		};
	} forEach _unitsSelected;
	
	private _kitlist = if (dzn_gear_zc_KitsList isEqualTo []) then { [""] } else { dzn_gear_zc_KitsList };
	private _Result = [
		"dzn_Gear Zeus Tool"
		, [
			["Kits", _kitlist]
			, ["Custom", []]
		]
	] call dzn_fnc_ShowChooseDialog;

	waitUntil {!dialog};
	if (count _Result == 0) exitWith {};
	
	private _kitname = if ( typename (_Result select 1) != "STRING") then {
		dzn_gear_zc_KitsList select (_Result select 0);
	} else {
		_Result select 1;		
	};
	
	if (isNil {call compile _kitname}) exitWith {
		hint parseText format [
			"<t size='1' color='#FFD000' shadow='1'>Zeus Gear Tool:</t>
			<br />There is no kit named '%1'"
			, _kitname
		];
	};
	
	{
		[_x, _kitname] call dzn_fnc_gear_assignKit;
	} forEach _units;
	
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Zeus Gear Tool:</t>
		<br /> Kit '%1' was assigned"
		, _kitname
	];
};


// ********************** Init ************************
waitUntil { time > 30 };
[] spawn dzn_fnc_gear_zc_initialize;
