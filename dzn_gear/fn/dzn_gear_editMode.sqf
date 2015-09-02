// **************************
// EDIT MODE
// **************************

dzn_fnc_gear_editMode_showAsStructuredList = {
	//@List stucturedText = @Array of values call dzn_fnc_gear_editMode_showAsStructuredList
	private["_arr","_result"];
	_arr = if (typename _this == "STRING") then { [_this] } else { _this };
	_result = "";
	
	{
		_result = if (_forEachIndex == 0) then {
			format ["%1", _x]
		} else {
			format ["%1<br />%2", _result, _x]
		};	
	} forEach _arr;
	
	_result
};

dzn_fnc_gear_editMode_onKeyPress = {
	if (!alive player) exitWith {};
	
	private["_key","_shift","_crtl","_alt"];	
	_key = _this select 1; 
	_shift = _this select 2; 
	_ctrl = _this select 3; 
	_alt = _this select 4;
	
	switch _key do {
		case 35: {
			call dzn_fnc_gear_editMode_showKeybinding;
		};
		
		case 57: {
			if (_alt) then {			[] spawn {sleep 0.5; ["Open", true] call BIS_fnc_arsenal;}; };
			if (_shift) then {
				hint "COPY UNIT'S GEAR";
			};
			if (_ctrl) then {
				hint "COPY MY GEAR";
			};
		};	
		
		case 2: {
			if (_alt) then {			"ALT" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};		
			if (_ctrl) then {		"CTRL" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};
			if (_shift) then {		"SHIFT" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};
			if !(_ctrl || _alt || _shift) then {	"NONE" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};
		};		
	};

	false
};

dzn_fnc_gear_editMode_getCurrentPrimaryWeapon = {
	// @Option call dzn_fnc_gear_editMode_getCurrentWeapon	
	// @Option :: 	"NONE", "ALT", "CTRL", "SHIFT"
	private["_actionName","_action","_list","_weapon","_magazine","_owner"];
	
	_actionName = ""; _action = ""; _actionMag = ""; _list = ""; _magList = "";
	/*
	switch (_this select 0) do {
		case "PRIMARY": { 
			_actionName = "Primary weapon";
			_action = "primaryWeapon";
			_actionMag = "primaryWeaponMagazine";
			_list = "dzn_gear_editMode_primaryWeaponList";
			_magList = "dzn_gear_editMode_primaryWeaponMagList";
		};
		case "SECONDARY": { 
			_actionName = "Secondary weapon";
			_action = "secondaryWeapon";
			_actionMag = "secondaryWeaponMagazine";
			_list = "dzn_gear_editMode_secondaryWeaponList";
		};
		case "HANDGUN": {
			_actionName = "Handgun";
			_action = "handgunWeapon";
			_actionMag = "handgunMagazine";
			_list = "dzn_gear_editMode_hangunWeaponList";
		};
	};
	*/
	_getPrimaryWeaponAndMags = {
		if (count dzn_gear_editMode_primaryWeaponList > 1) then {
			[ dzn_gear_editMode_primaryWeaponList , dzn_gear_editMode_primaryWeaponMagList];
		} else {
			[ dzn_gear_editMode_primaryWeaponList select 0 , dzn_gear_editMode_primaryWeaponMagList select 0];		
		};
	};
	
	_ownerUnit = if (isNull cursorTarget) then { player } else { cursorTarget }; 
	_owner = if (isNull cursorTarget) then { "Player" } else { "Unit" };
	_weapon = primaryWeapon _ownerUnit;
	_magazine = (primaryWeaponMagazine _ownerUnit) select 0;
	
	
	switch (_this) do {
		case "SHIFT": {
			// Set
			hint parseText format ["<t color='#6090EE' size='1.1'>Primary weapon of %1 is COPIED</t><br />%2", _owner,_weapon];
			dzn_gear_editMode_primaryWeaponList = [_weapon];
			copyToClipboard str(call _getPrimaryWeaponAndMags);
		};
		case "CTRL": {
			// Add
			hint parseText format ["<t color='#6090EE' size='1.1'>Primary weapon of %1 is ADDED to list</t><br />%2", _owner, _weapon];
			if !(_weapon in dzn_gear_editMode_primaryWeaponList) then {
				dzn_gear_editMode_primaryWeaponList pushBack _weapon;
			};
			if !(_magazine in dzn_gear_editMode_primaryWeaponMagList) then {
				dzn_gear_editMode_primaryWeaponMagList pushBack _magazine
			};
			copyToClipboard str(call _getPrimaryWeaponAndMags);
		};
		case "ALT": {
			// Clear
			hint parseText "<t color='#6090EE' size='1.1'>Primary weapon is CLEARED</t>";
			dzn_gear_editMode_primaryWeaponList = [];
			dzn_gear_editMode_primaryWeaponMagList = [];
		};		
		default {
			// Show	
			hint parseText format [
				"<t color='#6090EE' size='1.1'>Primary weapon list:</t><br /><t size='0.6' color='#FFD000'>Weapon</t><br />%1<br /><t size='0.6' color='#FFD000'>Magazines</t><br />%2" 
				, ((call _getPrimaryWeaponAndMags) select 0) call dzn_fnc_gear_editMode_showAsStructuredList
				, ((call _getPrimaryWeaponAndMags) select 1) call dzn_fnc_gear_editMode_showAsStructuredList
			];
			copyToClipboard str(call _getPrimaryWeaponAndMags);	
		};
	};
	
	false
};




/*
dzn_fnc_gear_editMode_onKeyPress = {
	if (!alive player) exitWith {};
	
	private["_key","_shift","_crtl","_alt"];	
	_key = _this select 1; 
	_shift = _this select 2; 
	_ctrl = _this select 3; 
	_alt = _this select 4;
	
	switch _key do {
		case 35: {
			call dzn_fnc_gear_editMode_showKeybinding;
		};
		
		case 57: {
			if (_alt) then {			[] spawn {sleep 0.5; ["Open", true] call BIS_fnc_arsenal;}; };
			if (_shift) then {
				hint "COPY UNIT'S GEAR";
			};
			if (_ctrl) then {
				hint "COPY MY GEAR";
			};
		};	
		
		case 2: {
			if (_alt) then {			["PRIMARY", "ALT"] call dzn_fnc_gear_editMode_getCurrentWeapon;};		
			if (_ctrl) then {		["PRIMARY", "CTRL"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
			if (_shift) then {		["PRIMARY", "SHIFT"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
			if !(_ctrl || _alt || _shift) then {	["PRIMARY", "NONE"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
		};
		case 3: {
			if (_alt) then {			["SECONDARY", "ALT"] call dzn_fnc_gear_editMode_getCurrentWeapon;};		
			if (_ctrl) then {		["SECONDARY", "CTRL"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
			if (_shift) then {		["SECONDARY", "SHIFT"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
			if !(_ctrl || _alt || _shift) then {	["SECONDARY", "NONE"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
		};
		case 4: {
			if (_alt) then {			["HANDGUN", "ALT"] call dzn_fnc_gear_editMode_getCurrentWeapon;};		
			if (_ctrl) then {		["HANDGUN", "CTRL"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
			if (_shift) then {		["HANDGUN", "SHIFT"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
			if !(_ctrl || _alt || _shift) then {	["HANDGUN", "NONE"] call dzn_fnc_gear_editMode_getCurrentWeapon;};
		}
		
	};

	false
};


dzn_fnc_gear_editMode_getCurrentWeapon = {
	// [@Type, @Option ] call dzn_fnc_gear_editMode_getCurrentWeapon
	// @Type :: 	"PRIMARY", "SECONDARY", "HANDGUN"
	// @Option :: 	"NONE", "ALT", "CTRL", "SHIFT"
	private["_actionName","_action","_list","_weapon","_magazine","_owner"];
	
	_actionName = ""; _action = ""; _actionMag = ""; _list = ""; _magList = "";
	
	switch (_this select 0) do {
		case "PRIMARY": { 
			_actionName = "Primary weapon";
			_action = "primaryWeapon";
			_actionMag = "primaryWeaponMagazine";
			_list = "dzn_gear_editMode_primaryWeaponList";
			_magList = "dzn_gear_editMode_primaryWeaponMagList";
		};
		case "SECONDARY": { 
			_actionName = "Secondary weapon";
			_action = "secondaryWeapon";
			_actionMag = "secondaryWeaponMagazine";
			_list = "dzn_gear_editMode_secondaryWeaponList";
		};
		case "HANDGUN": {
			_actionName = "Handgun";
			_action = "handgunWeapon";
			_actionMag = "handgunMagazine";
			_list = "dzn_gear_editMode_hangunWeaponList";
		};
	};
	
	_owner = if (isNull cursorTarget) then { "Player" } else { "Unit" };
	_weapon = call compile format ["%1 (if (isNull cursorTarget) then { player } else { cursorTarget })", _action];
	_magazine = call compile format ["%1 (if (isNull cursorTarget) then { player } else { cursorTarget }) select 0", _actionMag];
	
	
	switch (_this select 1) do {
		case "CTRL": {
			// Add
			call compile format [     
				"hint parseText ""<t color='#6090EE' size='1.1'>%1 of %2 is ADDED to list</t>"";
				if (typename %3 == 'STRING') then { 
					%3 = [_weapon]; 
					%4 = [_magazine];
				} else { 
					%3 pushBack _weapon;
					%4 pushBack _magazine;
				};				
				copyToClipboard str([%3, %4]);" 
				, _actionName
				, _owner
				, _list
				, _magList
			];
		};
		case "ALT": {
			// Clear
			call compile format [
				"hint parseText ""<t color='#6090EE' size='1.1'>%1 is CLEARED</t>"";
				%2 = [];"
				,_actionName,_list
			];	
		};
		case "SHIFT": {
			// Set
			call compile format [
				"hint parseText ""<t color='#6090EE' size='1.1'>%1 of %4 is COPIED</t>"";
				%3 = _weapon;
				copyToClipboard str(%3);"
				,_actionName
				,_action
				,_list
				,_owner
			];	
		};
		default {
			// Show			
			call compile format [
				"hint parseText (""<t color='#6090EE' size='1.1'>%1 list:</t><br />"" + '%2'); 
				copyToClipboard str([%3, %4]);"
				,_actionName
				,call compile _list
				,_list
				,_magList
			];		
		};
	};
	
	false
};
*/


dzn_fnc_gear_editMode_showKeybinding = {
	hint parseText format["<t size='2' color='#FFD000' shadow='1'>dzn_gear</t>
		<br /><br /><t size='1.45' color='#3793F0' underline='true'>Keybinding:</t>
		<br /><br /><t %1>[H]</t><t %2> - Show keybinding</t>
		<br />
		<br /><t %1>[ALT + SPACE]</t><t %2> - Open Arsenal</t>  
		<br /><t %1>[CTRL + SPACE]</t><t %2> - Copy current gear</t>
		<br /><t %1>[SHIFT + SPACE]</t><t %2> - Copy gear of cursor target</t>
		<br />
		<br /><t %1>[1..3]</t><t %2> - Show Primary, Launcher or Handgun weapon to list and copy</t>
		<br /><t %1>[SHIFT + 1..3]</t><t %2> - Set and copy Primary, Launcher or Handgun weapon</t>
		<br /><t %1>[CTRL + 1..3]</t><t %2> - Add Primary, Launcher or Handgun weapon to list and copy</t>		
		<br /><t %1>[ALT + 1..3]</t><t %2> - Clear Primary, Launcher or Handgun weapon list</t>
		"
		, "align='left' color='#3793F0' size='0.9'"
		, "align='right' size='0.8'"
	];
};

waitUntil { !(isNull (findDisplay 46)) }; 
(findDisplay 46) displayAddEventHandler ["KeyDown", "_handled = _this call dzn_fnc_gear_editMode_onKeyPress;_handled;"];

dzn_gear_editMode_primaryWeaponList = [primaryWeapon player];
dzn_gear_editMode_secondaryWeaponList = [secondaryWeapon player];
dzn_gear_editMode_hangunWeaponList = [handgunWeapon player];

dzn_gear_editMode_primaryWeaponMagList = primaryWeaponMagazine player;

["Open", false] call BIS_fnc_arsenal;
hint parseText format["<t size='2' color='#FFD000' shadow='1'>dzn_gear</t>.
	<br /><br /><t size='1.45' color='#3793F0' underline='true'>EDIT MODE</t>	
	<br /><t %1>This is an Edit mode where you can create gear kits for dzn_gear.</t>	
	<br /><br /><t size='1.45' color='#3793F0' underline='true'>VIRTUAL ARSENAL</t>	
	<br /><t %1>Use arsenal to choose your gear. Then Copy it and paste to dzn_gear_kits.sqf file.</t>
	<br /><br /><t size='1.45' color='#3793F0' underline='true'>KEYBINDING</t>
	<br /><t %1>Close ARSENAL and check keybinding of EDIT MODE by clicking [H] button.</t>
	"
	, "align='left' size='0.9'"
];


