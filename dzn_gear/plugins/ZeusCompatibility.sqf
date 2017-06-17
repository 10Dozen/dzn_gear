// ******** Gear Zeus Compatibility Plug-in ************
// ****************************************************
//
//
// ******************** Settings **********************

[
	[0, "HEADER", "dzn_GEAR ZEUS TOOL"]
	, [1, "LABEL", ""]
	
	, [2, "LABEL", "KITS"]
	, [2, "DROPDOWN", ["kit_usmc_sl"]]
	, [2, "INPUT"]

	, [3, "BUTTON", "COPY GEAR"]
	, [3, "BUTTON", "APPLY GEAR"]
	, [3, "BUTTON", "ASSIGN KIT"]
	
	, [4, "HEADER", ""]
	, [5, "LABEL", "ITEMS"]
	, [5, "DROPDOWN", ["NVG","Gun Flashlight", "BLUFOR LR Radio", "OPFOR LR Radio", "Weapon Optics"]]
	, [5, "BUTTON", "ADD ITEM"]
	, [6, "LABEL", ""]
	, [6, "LABEL", ""]
	, [6, "BUTTON", "REMOVE"]
	
	, [7, "BUTTON", "ARSENAL"]
	, [7, "LABEL", ""]
	, [7, "BUTTON", "CLEAR ITEMS"]
] call dzn_fnc_ShowAdvDialog;



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
		_kitname call dzn_fnc_gear_zc_addToKitList;		
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
			if (_ctrl) then { [] call dzn_fnc_gear_zc_copyKit; };
			if (_alt) then { [] call dzn_fnc_gear_zc_applyKit; };
			if (_shift) then { [] call dzn_fnc_gear_zc_getKit; };
			if !(_ctrl || _alt || _shift) then { [] spawn dzn_fnc_gear_zc_processMenu; };
			
			_handled = true;
		};
	};

	[] spawn { sleep 1; dzn_gear_zc_keyIsDown = false; };
	_handled
};

dzn_fnc_gear_zc_processMenu = {
	dzn_gear_zc_unitsSelected = call dzn_fnc_gear_zc_getSelectedUnits;
	if (dzn_gear_zc_unitsSelected isEqualTo []) exitWith { ["No units selected!", "fail"] call dzn_fnc_gear_zc_showNotif; };	
	
	private _kitlist = if (dzn_gear_zc_KitsList isEqualTo []) then { [""] } else { dzn_gear_zc_KitsList };
	[
		[0, "HEADER", "dzn_GEAR ZEUS TOOL"]
		, [0, "LABEL", ""]
		, [0, "LABEL", ""]
		, [0, "LABEL", ""]
		, [0, "BUTTON", "CLOSE", { closeDialog 2; }]
		
		, [1, "LABEL", "<t align='right'>Units selected:</t>"]
		, [1, "LABEL", format ["<t align='left'>%1</t>", count dzn_gear_zc_unitsSelected]]
		
		, [2, "LABEL", "KITS"]
		, [2, "DROPDOWN", _kitlist, _kitlist]
		, [2, "INPUT"]

		, [3, "BUTTON", "COPY GEAR", { call dzn_fnc_gear_zc_copyKit; }]
		, [3, "BUTTON", "APPLY COPIED GEAR", { call dzn_fnc_gear_zc_applyKit; }]
		, [3, "BUTTON", "ASSIGN KIT", {
			params["_kitDropdown","_kitInput",""];
			closeDialog 2;
		
			private _kitname = if ((_kitInput select 0) == "") then {
				dzn_gear_zc_KitsList select (_kitDropdown select 0)
			} else {
				_kitInput select 0				
			};
			
			XC = [_kitname, _kitDropdown, _kitInput];
			
			if (isNil {call compile _kitname}) exitWith { [format["There is no kit named '%1'", _kitname], "fail"] call dzn_fnc_gear_zc_showNotif; };
			
			{ 
				if (local _x) then {
					[_x, _kitname] call dzn_fnc_gear_assignKit; 
				} else {
					[_x, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _x];
				};
			} forEach dzn_gear_zc_unitsSelected;
			[format ["Kit '%1' was assigned", _kitname], "success"] call dzn_fnc_gear_zc_showNotif;
		}]
		
		, [4, "HEADER", ""]
		, [5, "LABEL", "ITEMS"]
		, [5, "DROPDOWN", ["NVG","Gun Flashlight", "BLUFOR LR Radio", "OPFOR LR Radio", "Weapon Optics"]]
		, [5, "BUTTON", "ADD ITEM"]
		, [6, "LABEL", ""]
		, [6, "LABEL", ""]
		, [6, "BUTTON", "REMOVE"]
		
		, [7, "BUTTON", "ARSENAL", { 
			if (count dzn_gear_zc_unitsSelected == 1) then {
				closeDialog 2;
				["Open",[true,objnull, dzn_gear_zc_unitsSelected select 0]] call bis_fnc_arsenal;
			} else {
				["Select single unit to open Arsenal", "fail"] call dzn_fnc_gear_zc_showNotif;
			};
		}]
		, [7, "LABEL", ""]
		, [7, "BUTTON", "CLEAR ITEMS"]
	] call dzn_fnc_ShowAdvDialog;
	
};

dzn_fnc_gear_zc_copyKit = {
	private _unitsSelected = call dzn_fnc_gear_zc_getSelectedUnits;
	if (_unitsSelected isEqualTo []) exitWith { ["No units selected!", "fail"] call dzn_fnc_gear_zc_showNotif; };
	if (count _unitsSelected > 1) exitWith { ["Select single unit to copy kit", "fail"] call dzn_fnc_gear_zc_showNotif; };
	
	dzn_gear_zc_BufferedKit = (_unitsSelected select 0) call dzn_fnc_gear_getGear;	
	["Kit were copied!", "success"] call dzn_fnc_gear_zc_showNotif;
};

dzn_fnc_gear_zc_getKit = {
	private _unitsSelected = call dzn_fnc_gear_zc_getSelectedUnits;
	if (_unitsSelected isEqualTo []) exitWith { ["No units selected!", "fail"] call dzn_fnc_gear_zc_showNotif; };
	if (count _unitsSelected > 1) exitWith { ["Select single unit to copy kit", "fail"] call dzn_fnc_gear_zc_showNotif; };
	
	dzn_gear_zc_GetKit = (_unitsSelected select 0) call dzn_fnc_gear_getGear;
	private _kitname = format ["kit_%1_%2", uniform (_unitsSelected select 0), primaryWeapon (_unitsSelected select 0)];
	if (_kitname in dzn_gear_zc_KitsList) then { _kitname = format ["%1_%2", _kitname, round(time)]; };
	
	call compile format [
		"%1 = dzn_gear_zc_GetKit; '%1' call dzn_fnc_gear_zc_addToKitList;"
		, _kitname
	];
	["Kit were added to list!", "success"] call dzn_fnc_gear_zc_showNotif;
};

dzn_fnc_gear_zc_applyKit = {
	if (isNil "dzn_gear_zc_BufferedKit") exitWith { ["No kit has been copied!", "fail"] call dzn_fnc_gear_zc_showNotif; };
	private _unitsSelected = call dzn_fnc_gear_zc_getSelectedUnits;
	if (_unitsSelected isEqualTo []) exitWith { ["No units selected!", "fail"] call dzn_fnc_gear_zc_showNotif; };	
	
	{
		if (local _x) then {
			[_x, dzn_gear_zc_BufferedKit] call dzn_fnc_gear_assignGear; 
		} else {
			[_x, dzn_gear_zc_BufferedKit] remoteExec ["dzn_fnc_gear_assignGear", _x];
		};
	} forEach _unitsSelected;
	
	["Kit were applied!", "success"] call dzn_fnc_gear_zc_showNotif;
};

dzn_fnc_gear_zc_getSelectedUnits = {
	private _unitsSelected = curatorSelected select 0;
	private _units = [];
	{
		if (_x isKindOf "CAManBase") then {
			_units pushBack _x
		};
	} forEach _unitsSelected;
	
	_units
};

dzn_fnc_gear_zc_showNotif = {
	// [@Text, @Success/Fail/Info] call dzn_fnc_gear_zc_showNotif
	params["_text",["_type", "success"]];
	
	private _displayText = format [
		"<t shadow='2'color='%2' align='center' font='PuristaBold' size='1.1'>%1</t>"
		, _text
		, switch toLower(_type) do {
			case "success": 	{ "#2cb20e" };
			case "fail":		{ "#b2290e" };
			case "info":		{ "#e6c300" };
		}
	];
	
	[parseText _displayText, [0,.7,1,1], nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
};

dzn_fnc_gear_zc_addToKitList = {
	// @Kit call dzn_fnc_gear_zc_addToKitList
	if ( 
		(_this != "") 
		&& !isNil {call compile _this} 
		&& !(_this in dzn_gear_zc_KitsList)
	) then {
		dzn_gear_zc_KitsList pushBack _this;
	};
};


// ********************** Init ************************
[] spawn dzn_fnc_gear_zc_initialize;
