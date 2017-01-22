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
	dzn_gear_zc_waitAncCheck = { dzn_gear_zc_canCollectKits = false; sleep 30; dzn_gear_zc_canCollectKits = true; };
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
			if !(_ctrl || _alt) then { [] spawn dzn_fnc_gear_zc_processMenu; };
			
			_handled = true;
		};
	};

	[] spawn { sleep 1; dzn_gear_zc_keyIsDown = false; };
	_handled
};

dzn_fnc_gear_zc_processMenu = {
	private _unitsSelected = call dzn_fnc_gear_zc_getSelectedUnits;
	if (_unitsSelected isEqualTo []) exitWith { ["No units selected!", "fail"] call dzn_fnc_gear_zc_showNotif; };	
	
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
	if (isNil {call compile _kitname}) exitWith { [format["There is no kit named '%1'", _kitname], "fail"] call dzn_fnc_gear_zc_showNotif; };
	
	{ [_x, _kitname] call dzn_fnc_gear_assignKit; } forEach _unitsSelected;	
	[format ["Kit '%1' was assigned", _kitname], "success"] call dzn_fnc_gear_zc_showNotif;
};

dzn_fnc_gear_zc_copyKit = {
	private _unitsSelected = call dzn_fnc_gear_zc_getSelectedUnits;
	if (_unitsSelected isEqualTo []) exitWith { ["No units selected!", "fail"] call dzn_fnc_gear_zc_showNotif; };
	if (count _unitsSelected > 1) exitWith { ["Select single unit to copy kit", "fail"] call dzn_fnc_gear_zc_showNotif; };
	
	dzn_gear_zc_BufferedKit = (_unitsSelected select 0) call dzn_fnc_gear_getGear;
	call compile format [
		"kit_%1_%2_%3 = dzn_gear_zc_BufferedKit; 'kit_%1_%2_%3' call dzn_fnc_gear_zc_addToKitList;"
		, uniform (_unitsSelected select 0)
		, primaryWeapon (_unitsSelected select 0)
		, round(time)
	];
	
	["Kit were copied!", "success"] call dzn_fnc_gear_zc_showNotif;
};

dzn_fnc_gear_zc_applyKit = {
	if (isNil "dzn_gear_zc_BufferedKit") exitWith { ["No kit has been copied!", "fail"] call dzn_fnc_gear_zc_showNotif; };
	private _unitsSelected = call dzn_fnc_gear_zc_getSelectedUnits;
	if (_unitsSelected isEqualTo []) exitWith { ["No units selected!", "fail"] call dzn_fnc_gear_zc_showNotif; };	
	
	{
		[_x, dzn_gear_zc_BufferedKit] call dzn_fnc_gear_assignGear;
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
