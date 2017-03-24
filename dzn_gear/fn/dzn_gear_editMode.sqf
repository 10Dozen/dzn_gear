// **************************
// EDIT MODE
// **************************

// ******************
// Functions
// ******************

dzn_fnc_gear_editMode_showKeybinding = {
	hint parseText format["<t size='2' color='#FFD000' shadow='1'>dzn_gear</t>
		<br /><br /><t size='1.45' color='#3793F0' underline='true'>Keybinding:</t>
		<br /><br /><t %1>[F1]</t><t %2> - Show keybinding</t>
		<br />
		<br /><t %1>[SPACE]</t><t %2> - Open Arsenal</t>  
		<br /><t %1>[CTRL + SPACE]</t><t %2> - Copy gear of player or cursorTarget and add it to action list</t>
		<br /><t %1>[SHIFT + SPACE]</t><t %2> - Copy gear of player or cursorTarget without adding new action</t>
		<br />
		<br /><t %1>[{1...6}]</t><t %2> - Show item list and copy</t>
		<br /><t %1>[SHIFT + {1...6}]</t><t %2> - Set current item list and copy list</t>
		<br /><t %1>[CTRL + {1...6}]</t><t %2> - Add item to list and copy</t>		
		<br /><t %1>[ALT + {1...6}]</t><t %2> - Clear item list</t>
		<br /><t align='left' size='0.8'>where
		<br />1 -- Primary weapon and magazine 
		<br />2 or U -- Uniform
		<br />3 or H -- Headgear
		<br />4 or G -- Goggles
		<br />5 or V -- Vest
		<br />6 or B -- Backpack
		<br />7 or P -- Pistol and magazine
		<br /><t %1>CTRL + I</t><t %2> - copy unit/player identity settings</t>
		<br />
		<br /><t %1>PGUP/PGDOWN</t><t %2> - standard uniform/assigned items On/Off</t>
		<br /><t %1>DEL</t><t %2> - clear current unit's gear</t>
		"
		, "align='left' color='#3793F0' size='0.9'"
		, "align='right' size='0.8'"
	];
};

#define SET_KEYDOWN	dzn_gear_editMode_keyIsDown = true
#define SET_HANDLED	_handled = true
#define GET_EQUIP_CALL(MODE) \
	if (_alt) then { [MODE,"ALT"] call dzn_fnc_gear_editMode_getEquipItems;};	\
	if (_ctrl) then { [MODE,"CTRL"] call dzn_fnc_gear_editMode_getEquipItems;};	\
	if (_shift) then { [MODE,"SHIFT"] call dzn_fnc_gear_editMode_getEquipItems;};	\
	if !(_ctrl || _alt || _shift) then { [MODE,"NONE"] call dzn_fnc_gear_editMode_getEquipItems;}

	
dzn_fnc_gear_editMode_onKeyPress = {
	if (!alive player || dzn_gear_editMode_keyIsDown) exitWith {};	
	private["_key","_shift","_crtl","_alt","_handled"];	
	_key = _this select 1; 
	_shift = _this select 2; 
	_ctrl = _this select 3; 
	_alt = _this select 4;
	_handled = false;
	
	
	switch _key do {
		// See for key codes -- https://community.bistudio.com/wiki/DIK_KeyCodes
		// F1 button
		case 59: {
			SET_KEYDOWN;
			call dzn_fnc_gear_editMode_showKeybinding;
			SET_HANDLED;
		};
		// Space
		case 57: {
			SET_KEYDOWN;			
			if (_ctrl) then {		true spawn dzn_fnc_gear_editMode_createKit; };
			if (_shift) then {		false spawn dzn_fnc_gear_editMode_createKit; };
			if !(_ctrl || _alt || _shift) then { 
				[] spawn {
					["#(argb,8,8,3)color(0,0,0,1)",false,nil,0.1,[0,0.5]] spawn bis_fnc_textTiles;
					sleep 0.3; 
					["Open", true] call BIS_fnc_arsenal;
				}; 
			};
			SET_HANDLED;
		};
		// 1 button - Primary weapon
		case 2: {
			SET_KEYDOWN;
			if (_alt) then {			"ALT" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};		
			if (_ctrl) then {		"CTRL" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};
			if (_shift) then {		"SHIFT" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};
			if !(_ctrl || _alt || _shift) then {	"NONE" call dzn_fnc_gear_editMode_getCurrentPrimaryWeapon;};
			SET_HANDLED;
		};
		// 7 or P button - Pistol
		case 8;
		case 25: {
			SET_KEYDOWN;
			if (_alt) then {			"ALT" call dzn_fnc_gear_editMode_getCurrentHandgun;};
			if (_ctrl) then {		"CTRL" call dzn_fnc_gear_editMode_getCurrentHandgun;};
			if (_shift) then {		"SHIFT" call dzn_fnc_gear_editMode_getCurrentHandgun;};
			if !(_ctrl || _alt || _shift) then {	"NONE" call dzn_fnc_gear_editMode_getCurrentHandgun;};
			SET_HANDLED;
		};
		// 2 or U button - Uniform
		case 22;
		case 3: {
			SET_KEYDOWN;
			GET_EQUIP_CALL("UNIFORM");
			SET_HANDLED;
		};
		// 3 or H button - Headgear
		case 35;
		case 4: {
			SET_KEYDOWN;
			GET_EQUIP_CALL("HEADGEAR");
			SET_HANDLED;
		};
		// 4 or G -- Goggles
		case 34;
		case 5: {
			SET_KEYDOWN;
			GET_EQUIP_CALL("GOGGLES");
			SET_HANDLED;
		};
		// 5 or V -- Vest
		case 47;
		case 6: {
			SET_KEYDOWN;
			GET_EQUIP_CALL("VEST");
			SET_HANDLED;
		};
		// 6 or B -- Backpack
		case 48;
		case 7: {
			SET_KEYDOWN;
			GET_EQUIP_CALL("BACKPACK");
			SET_HANDLED;
		};
		// I
		case 23: {
			SET_KEYDOWN;
			if (_ctrl) then { 
				call dzn_fnc_gear_editMode_getCurrentIdentity;				
			};
			SET_HANDLED;
		};
		
		// PGUP
		case 201: {
			SET_KEYDOWN;
			["UseStandardUniformItems"] call dzn_fnc_gear_editMode_setOptions;
			SET_HANDLED;
		};
		
		// PGDOWN
		case 209: {
			SET_KEYDOWN;
			["UseStandardAssignedItems"] call dzn_fnc_gear_editMode_setOptions;
			SET_HANDLED;
		};
		
		// DELETE
		case 211: {
			SET_KEYDOWN;
			if (_ctrl) then {
				clearAllItemsFromBackpack player;
				{player removeItemFromVest _x;} forEach (vestItems player);
				{player removeItemFromUniform _x;} forEach (uniformItems player);
				
				[parseText "<t align='right' font='PuristaBold' size='1'>All items was removed</t>", true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
			} else {
				private _infKit = [["","","","","",""],["","","",["","","",""]],["","","",["","","",""]],["","","",["","","",""]],[""],["",[]],["",[]],["",[]]];
				private _vehKit = [[],[],[],[]];
				private _infMsg = parseText "<t align='right' font='PuristaBold' size='1'>Gear was removed</t>";
				
				if (isNull cursorTarget) then {			
					[player, _infKit] call dzn_fnc_gear_assignGear;
					[_infMsg, true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
				} else {
					if (cursorTarget isKindOf "CAManBase") then {
						[cursorTarget, _infKit] call dzn_fnc_gear_assignGear;
						[_infMsg, true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
					} else {
						[cursorTarget, _vehKit] call dzn_fnc_gear_assignCargoGear;
						[parseText "<t align='right' font='PuristaBold' size='1'>Vehicle Gear was removed</t>", true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
					};
				};
			};
			SET_HANDLED;
		};
	};
	
	[] spawn { sleep 1; dzn_gear_editMode_keyIsDown = false; };
	_handled
};


dzn_fnc_gear_editMode_setOptions = {
	/* [@Option] call dzn_fnc_gear_editMode_setOptions
	 *	Options:	
	 *		UseStandardUniformItems
	 *		UseStandardAssignedItems		
	 */
	 
	 private _showNotif = {
		// [@Text, @ModeText, @Color] call _showNotif	 
		[
			parseText format [ 
				"<t align='right' font='PuristaBold' size='1'>%1 <t color='%3'>%2</t></t>"
				, _this select 0
				, _this select 1
				, _this select 2
			]
		, true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;	
	 };
	 
	 switch toLower(_this select 0) do {
		case toLower("UseStandardUniformItems"): {
			dzn_gear_UseStandardUniformItems = switch (toLower(dzn_gear_UseStandardUniformItems)) do {
				case "no": {"standard"};
				case "standard": {"leader"};
				case "leader": {"no"};
			};
			["Use Uniform Items ", toUpper(dzn_gear_UseStandardUniformItems), "#FFD000"] call  _showNotif;
		};
		case toLower("UseStandardAssignedItems"): {
			dzn_gear_UseStandardAssignedItems = switch (toLower(dzn_gear_UseStandardAssignedItems)) do {
				case "no": {"standard"};
				case "standard": {"leader"};
				case "leader": {"no"};
			};
			["Use Assigned Items ", toUpper(dzn_gear_UseStandardAssignedItems), "#FFD000"] call  _showNotif;
		};
	 };
};


dzn_fnc_gear_editMode_getEquipItems = {
	// [@ItemType,@Option] call dzn_fnc_gear_editMode_getEquipItems	
	// 0	@ItemType :		"UNIFORM","HEADGEAR","GOGGLES","VEST","BACKPACK"
	// 1	@Option :		"NONE", "ALT", "CTRL", "SHIFT"
	private["_mode","_getEquipType","_ownerUnit","_owner","_item"];
	
	#define TEXT_FROM_UPPER(X)	toUpper(X select [0,1])  + toLower(X select [1])
	
	_getEquipType = {
		// @List = @Mode call _getEquipType
		private["_r"];
		_r = call compile format [
			"if (count dzn_gear_editMode_%1List > 1) then {
				dzn_gear_editMode_%1List;
			} else {
				dzn_gear_editMode_%1List select 0;		
			}"
			, toLower(_this)
		];
		
		_r
	};
	
	_mode = _this select 0;
	_ownerUnit = if (isNull cursorTarget) then { player } else { driver cursorTarget }; 
	_owner = if (isNull cursorTarget) then { "Player" } else { "Unit" };
	_item = call compile format ["%1 _ownerUnit", toLower(_mode)];
	private _text = "";
	
	switch (_this select 1) do {
		case "SHIFT": {
			// Set			
			_text = format ["<t color='#6090EE' size='1.1'>%3 of %1 is COPIED</t><br />%2", _owner, _item, TEXT_FROM_UPPER(_mode)];
			copyToClipboard str(_mode call _getEquipType);		
		};
		case "CTRL": {
			// Add
			_text = format ["<t color='#6090EE' size='1.1'>%3 of %1 is ADDED to list</t><br />%2", _owner, _item, TEXT_FROM_UPPER(_mode)];
			call compile format [
				"if !(_item in dzn_gear_editMode_%1List) then {
					dzn_gear_editMode_%1List pushBack _item;				
				};"
				, toLower(_mode)			
			];
			copyToClipboard str(_mode call _getEquipType);
		};
		case "ALT": {
			// Clear
			_text = format ["<t color='#6090EE' size='1.1'>%1 is CLEARED</t>", TEXT_FROM_UPPER(_mode)];
			call compile format [
				"dzn_gear_editMode_%1List = [];"
				, toLower(_mode)
			];
		};		
		default {
			// Show	
			_text = format [
				"<t color='#6090EE' size='1.1'>%2 list:</t><br /><t size='0.6' color='#FFD000'>Item</t><br />%1" 
				, [(_mode call _getEquipType), true] call dzn_fnc_gear_editMode_showAsStructuredList
				, TEXT_FROM_UPPER(_mode)
			];
			copyToClipboard str(_mode call _getEquipType);
		};
	};
	
	if (isNil {uinamespace getvariable "RSCDisplayArsenal"}) then {
		hint parseText  _text;
	} else {		
		[
			_text
			, "TOP"
			, [0,0,0,.8]
			, 5
		] call dzn_fnc_ShowMessage;
	};
	
	false	
};

dzn_fnc_gear_editMode_getCurrentPrimaryWeapon = {
	// @Option call dzn_fnc_gear_editMode_getCurrentWeapon	
	// @Option :: 	"NONE", "ALT", "CTRL", "SHIFT"
	private["_ownerUnit","_owner","_weapon","_magazine","_getPrimaryWeaponAndMags"];
	
	_getPrimaryWeaponAndMags = {
		if (count dzn_gear_editMode_primaryWeaponList > 1) then {
			[ dzn_gear_editMode_primaryWeaponList , dzn_gear_editMode_primaryWeaponMagList];
		} else {
			[ dzn_gear_editMode_primaryWeaponList select 0 , dzn_gear_editMode_primaryWeaponMagList select 0];		
		};
	};
	
	_ownerUnit = if (isNull cursorTarget) then { player } else { driver cursorTarget }; 
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
				dzn_gear_editMode_primaryWeaponMagList pushBack _magazine;			
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
				, [((call _getPrimaryWeaponAndMags) select 0), true] call dzn_fnc_gear_editMode_showAsStructuredList
				, [((call _getPrimaryWeaponAndMags) select 1), true]call dzn_fnc_gear_editMode_showAsStructuredList
			];
			copyToClipboard str(call _getPrimaryWeaponAndMags);	
		};
	};
	
	false
};

dzn_fnc_gear_editMode_getCurrentHandgun = {
	// @Option call dzn_fnc_gear_editMode_getCurrentHandgun
	// @Option :: 	"NONE", "ALT", "CTRL", "SHIFT"
	private["_ownerUnit","_owner","_weapon","_magazine","_getWeaponAndMags"];

	_getWeaponAndMags = {
		if (count dzn_gear_editMode_handgunList > 1) then {
			[ dzn_gear_editMode_handgunList , dzn_gear_editMode_handgunMagList];
		} else {
			[ dzn_gear_editMode_handgunList select 0 , dzn_gear_editMode_handgunMagList select 0];
		};
	};

	_ownerUnit = if (isNull cursorTarget) then { player } else { driver cursorTarget };
	_owner = if (isNull cursorTarget) then { "Player" } else { "Unit" };
	_weapon = handgunWeapon _ownerUnit;
	_magazine = (handgunMagazine _ownerUnit) select 0;

	switch (_this) do {
		case "SHIFT": {
			// Set
			hint parseText format ["<t color='#6090EE' size='1.1'>Handgun of %1 is COPIED</t><br />%2", _owner,_weapon];
			dzn_gear_editMode_handgunList = [_weapon];
			copyToClipboard str(call _getPrimaryWeaponAndMags);
		};
		case "CTRL": {
			// Add
			hint parseText format ["<t color='#6090EE' size='1.1'>Handgun of %1 is ADDED to list</t><br />%2", _owner, _weapon];
			if !(_weapon in dzn_gear_editMode_handgunList) then {
				dzn_gear_editMode_handgunList pushBack _weapon;
				dzn_gear_editMode_handgunMagList pushBack _magazine;
			};
			copyToClipboard str(call _getPrimaryWeaponAndMags);
		};
		case "ALT": {
			// Clear
			hint parseText "<t color='#6090EE' size='1.1'>Handgun is CLEARED</t>";
			dzn_gear_editMode_handgunList = [];
			dzn_gear_editMode_handgunMagList = [];
		};
		default {
			// Show
			hint parseText format [
				"<t color='#6090EE' size='1.1'>Handung list:</t><br /><t size='0.6' color='#FFD000'>Weapon</t><br />%1<br /><t size='0.6' color='#FFD000'>Magazines</t><br />%2"
				, [((call _getWeaponAndMags) select 0), true] call dzn_fnc_gear_editMode_showAsStructuredList
				, [((call _getWeaponAndMags) select 1), true]call dzn_fnc_gear_editMode_showAsStructuredList
			];
			copyToClipboard str(call _getWeaponAndMags);
		};
	};

	false
};

dzn_fnc_gear_editMode_getCurrentIdentity = {	
	private _owner = if (!isNull cursorTarget && {cursorTarget isKindOf "CAManBase"}) then { "Unit" } else { "Player" };

	private _unit = if (_owner == "Unit") then { cursorTarget } else { player };
	private _face = face _unit;
	private _voice = speaker _unit;
	private _name = name _unit;	
	
	hint parseText format [
		"<t color='#6090EE' size='1.1'>%1 Identity was copied to clipboard</t><br />Face: %2<br />Speaker: %3<br />Name: %4"
		, _owner
		, _face
		, _voice
		, _name		
	];
	copyToClipboard format[',["<IDENTITY >>", "%1", "%2", ""]', _face, _voice, _name];
};


dzn_fnc_gear_editMode_createKit = {
	// @Add action? call dzn_fnc_gear_editMode_createKit
	// RETURN: 	Copy kit to clipboard, Add action in actin menu, Show notification
	private["_colorString","_kit"];
	#define GetColors ["F","C","B","3","6","9"] call BIS_fnc_selectRandom
	_colorString = format [
		"#%1%2%3%4%5%6", GetColors, GetColors, GetColors, GetColors, GetColors, GetColors
	]; 	

	private _showHint = {
		// [@UnitType("Player","Cargo","Unit"), @ColorString] call _showHint
		hintSilent parseText format[      
			"<t size='1.25' color='%2'>Gear has been copied from <t underline='true'>%1</t> to clipboard</t>"     
			,_this select 0
			,_this select 1			
		];
		
		[
			parseText format [ 
				"<t align='right' font='PuristaBold' size='1.1'><t color='%2'>%1</t> kit copied</t>"
				,_this select 0
				,_this select 1	
			]
		, true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;		
	};
	
	private _addKitAction = {
		// @ColorString, @Kit call _addKitAction
		player addAction [
			
			format [
				"<t color='%1'>Kit with %3 at %2</t>"
				,_this select 0
				,[time/3600, "HH:MM:SS"] call BIS_fnc_timeToString
				,((_this select 1) select 1 select 1) call dzn_fnc_gear_editMode_getItemName
			],
			{
				if (isNull cursorTarget) then {
					[player, _this select 3] call dzn_fnc_gear_assignGear;
				} else {
					if (cursorTarget isKindOf "CAManBase") then {
						[cursorTarget, _this select 3] call dzn_fnc_gear_assignGear;
					};
				};
			},
			_this select 1,0
		];	
	};	
	
	private _addCargoKitAction = {
		// @ColorString, @Kit call _addKitAction
		player addAction [
			format [
				"<t color='%1'>Cargo Kit from %3 at %2</t>"			
				, _this select 0
				, [time/3600, "HH:MM:SS"] call BIS_fnc_timeToString
				, (typeOf cursorTarget) call dzn_fnc_gear_editMode_getVehicleName			
			]
			, {
				if (!isNull cursorTarget && !(cursorTarget isKindOf "CAManBase")) then {
					[cursorTarget, _this select 3] call dzn_fnc_gear_assignCargoGear;
				} else {
					if (vehicle player != player) then {
						[vehicle player, _this select 3] call dzn_fnc_gear_assignCargoGear;
					};
				};
			}
			, _this select 1, 0		
		];
	};	
	
	private _replaceDefaultMagazines = {
		if !(dzn_gear_ReplaceRHSStanagToDefault) exitWith {};
		
		if ((_this select 1) select 2 == "rhs_mag_30Rnd_556x45_Mk318_Stanag") then {
			(_this select 1) set [2, "30Rnd_556x45_Stanag"];
		};
	};
	
	private _useStandardItems = {
		// @Kit call _useStandardItems		
		if (toLower(dzn_gear_UseStandardAssignedItems) != "no") then {
			_this set [
				4
				, switch (toLower(dzn_gear_UseStandardAssignedItems)) do {
					case "standard": { dzn_gear_StandardAssignedItems };
					case "leader": { dzn_gear_LeaderAssignedItems };
				}
			];
		};
		
		if (toLower(dzn_gear_UseStandardUniformItems) != "no") then {
			_this set [
				5
				, switch (toLower(dzn_gear_UseStandardUniformItems)) do {
					case "standard": { dzn_gear_StandardUniformItems };
					case "leader": { dzn_gear_LeaderUniformItems };
				}
			];
		};
	};
	
	private _formatAndCopyKit = {
		/* @Kit call _formatAndCopyKit
		 * Format of output
		 */
		 
		_this pushBack "];";		// closing bracket
		private _lastItemNo = count(_this) - 1;
		
		private _formatedString = "%1 = [";		
		private _name = "";
		private _exit = false;
		
		if (!isNil "dzn_fnc_ShowChooseDialog") then {		
			disableSerialization;
			
			private _kitKeyLabel = if (dzn_gear_kitKey != "") then { format ["Kit key [ %1 ]",dzn_gear_kitKey] } else { "Kit key" };
			private _labels = [];
			{ _labels pushBack (_x select 0) } forEach dzn_gear_kitRoles;
			
			private _answer = ["dzn Gear"
				, [
					[_kitKeyLabel, []]
					,["Kit role", _labels]
					,["or Kitname (w/o spaces)", []]
				]
			] call dzn_fnc_ShowChooseDialog;
			
			/*
				["usmc",5,-1]			// usmc, rifleman, <none>
				[-1,3,-1]			// <none>, rifleman, <none>
				["usmc",5,"RIFFFL"]		// usmc, rifleman, MyROLEMotherfucker
				[-1,5,"KitNameFucker"]		// <none>, rifleman, MyROLEMotherfucker
				[]				// Canceled
			*/
			
			if (_answer isEqualTo []) exitWith { _exit = true; };
			
			if (typename (_answer select 2) == "STRING") then {
				// Custom kit name
				_name = format ["kit_%1", _answer select 2];				
			} else {
				if (typename (_answer select 0) == "STRING") then {
					dzn_gear_kitKey = _answer select 0;
				};
				
				_name = format ["kit_%1_%2", dzn_gear_kitKey, (dzn_gear_kitRoles select (_answer select 1)) select 1]				
			};			
		};		
		if (_exit) exitWith { false };
		
		_formatedString = format [_formatedString, _name];	
		{
			_formatedString = format [
				"%1
%2%3%4"
				, _formatedString
				, if (_forEachIndex != _lastItemNo) then { "	" } else { "" }
				, _x
				, if (_forEachIndex < _lastItemNo - 1) then { "," } else { "" }
			];
		} forEach _this;
		
		copyToClipboard _formatedString;
		true
	};
	
	private _copyUnitKit = {
		// @Kit call _copyUnitKit
		_this call _replaceDefaultMagazines;
		_this call _useStandardItems;
		private _copyDone = _this call _formatAndCopyKit;
		
		_copyDone
	};

	if (isNull cursorTarget) then {
		// Player
		if (_this) then { [_colorString, (player call dzn_fnc_gear_getGear)] call _addKitAction; };
		["Player's", _colorString] call _showHint;		
		private _copyDone = (player call dzn_fnc_gear_getGear) call _copyUnitKit;		
	} else {
		if (cursorTarget isKindOf "CAManBase") then {
			// Unit
			if (_this) then { [_colorString, (cursorTarget call dzn_fnc_gear_getGear)] call _addKitAction; };
			["Unit's", _colorString] call _showHint;
			
			private _copyDone = (cursorTarget call dzn_fnc_gear_getGear) call _copyUnitKit;		
		} else {
			// Vehicle
			private _kit = cursorTarget call dzn_fnc_gear_getCargoGear;
			if (_this) then { [_colorString, _kit] call _addCargoKitAction; };
			["Cargo", _colorString] call _showHint;
		};	
	};
};





// *****************************
//	GEAR TOTALS Functions
// *****************************

dzn_fnc_convertInventoryToLine = {
	// @InventoryArray call dzn_fnc_convertInventoryToLine
	private["_line","_cat","_subCat"];
	#define	linePush(X)		if (_x != "") then {_line pushBack X;};
	_line = [];
	{
		_cat = _x;
		if (typename _cat == "ARRAY") then {
			{
				_subCat = _x;
				if (typename _subCat == "ARRAY") then {
					{
						linePush(_x)
					} forEach _subCat;
				} else {
					linePush(_x)
				};
			} forEach _cat;
		} else {
			linePush(_x)
		};
	} forEach _this;
	
	_line
};

dzn_fnc_gear_editMode_showGearTotals = {
	// @ArrayOfTotals call dzn_fnc_gear_editMode_showGearTotals	
	private["_inv","_items","_stringsToShow","_itemName","_headlineItems","_haedlines"];
	
	_inv = player call BIS_fnc_saveInventory;
	_items = (_inv call dzn_fnc_convertInventoryToLine) call BIS_fnc_consolidateArray;
	
	_stringsToShow = [
		parseText "<t color='#FFD000' size='1' align='center'>GEAR TOTALS</t>"
	];
	
	_headlineItems = [
		(_inv select 0 select 0) call dzn_fnc_gear_editMode_getItemName
		, (_inv select 1 select 0) call dzn_fnc_gear_editMode_getItemName
		, (_inv select 2 select 0) call dzn_fnc_gear_editMode_getItemName
		, (_inv select 3) call dzn_fnc_gear_editMode_getItemName
		, (_inv select 4) call dzn_fnc_gear_editMode_getItemName
		, (_inv select 6 select 0) call dzn_fnc_gear_editMode_getItemName
		, (_inv select 7 select 0) call dzn_fnc_gear_editMode_getItemName
		, (_inv select 8 select 0) call dzn_fnc_gear_editMode_getItemName		
	];
	
	_haedlines = [
		["Uniform:", 	'#3F738F']
		,["Vest:", 		'#3F738F']
		,["Backpack:", 	'#3F738F']
		,["Headgear:", 	'#3F738F']
		,["Goggles:", 	'#3F738F']
		,["Primary:", 	'#059CED']
		,["Secondary:", 	'#059CED']
		,["Handgun:", 	'#059CED']
	];	
	
	{
		_stringsToShow = _stringsToShow + [
			parseText (format [
				"<t color='%2' align='left' size='0.8'>%1</t><t align='right' size='0.8'>%3</t>"
				, toUpper(_x select 0)
				, _x select 1
				, if ((_headlineItems select _forEachIndex) == "") then {"-no-"} else {_headlineItems select _forEachIndex}
			])		
		];		
	} forEach _haedlines;	
	
	{
		
		_itemName = (_x select 0) call dzn_fnc_gear_editMode_getItemName;
		if !(_itemName in _headlineItems) then {
			_stringsToShow = _stringsToShow + [
				if (_x select 1 > 1) then {
					parseText (format ["<t color='#AAAAAA' align='left' size='0.8'>x%1 %2</t>", _x select 1, _itemName])
				} else {
					parseText (format ["<t color='#AAAAAA' align='left' size='0.8'>%1</t>", _itemName])
				}
			];
		};		
	} forEach _items;

	[
		_stringsToShow
		, [35.2,-7.1, 35, 0.03]
		, dzn_gear_GearTotalsBG_RGBA
		, dzn_gear_editMode_arsenalTimerPause
	] call dzn_fnc_ShowMessage;
};


// DISPLAY NAME of Weapon or Gear
dzn_fnc_gear_editMode_showAsStructuredList = {
	//@List stucturedText = [@Array of values, @Show names?] call dzn_fnc_gear_editMode_showAsStructuredList
	private["_arr","_item","_result"];
	_arr = if (typename (_this select 0) == "STRING") then { [_this select 0] } else { _this  select 0 };
	_result = "";
	{		
		_item = if (_this select 1) then { _x call dzn_fnc_gear_editMode_getItemName } else { _x };
		_result = if (_forEachIndex == 0) then {
			format ["%1", _item]
		} else {
			format ["%1<br />%2", _result, _item]
		};	
	} forEach _arr;
	
	_result
};

dzn_fnc_gear_editMode_getItemName = {
	// @Classname call dzn_fnc_gear_editMode_getItemName
	private["_name"];
	
	_name = _this call dzn_fnc_gear_editMode_getEquipDisplayName;
	if (_name == "") then {
		_name = _this call dzn_fnc_gear_editMode_getMagazineDisplayName;
		if (_name == "") then {
			_name = _this call dzn_fnc_gear_editMode_getBackpackDisplayName;
		};
	};

	_name	
};

dzn_fnc_gear_editMode_getMagazineDisplayName = {
	// @Name = @Classname call dzn_fnc_gear_editMode_getMagazineDisplayName
	getText(configFile >>  "cfgMagazines" >> _this >> "displayName")
};

dzn_fnc_gear_editMode_getEquipDisplayName = {
	// @Name = @Classname call dzn_fnc_gear_editMode_getEquipDisplayName
	if (isText (configFile >> "cfgWeapons" >> _this >> "displayName")) then {
		getText(configFile >> "cfgWeapons" >> _this >> "displayName")
	} else {
		getText(configfile >> "CfgGlasses" >> _this >> "displayName")
	}
};

dzn_fnc_gear_editMode_getBackpackDisplayName = {
	// @Name = @Classname call dzn_fnc_gear_editMode_getBackpackDisplayName
	getText(configFile >> "cfgVehicles" >> _this >> "displayName");
};

dzn_fnc_gear_editMode_getVehicleName = {
	// @Name = @Classname call dzn_fnc_gear_editMode_getVehicleName
	getText(configFile >>  "CfgVehicles" >> _this >> "displayName")
};


// ******************
// Init of EDIT MODE
// ******************

waitUntil { !(isNull (findDisplay 46)) }; 
(findDisplay 46) displayAddEventHandler ["KeyDown", "_handled = _this call dzn_fnc_gear_editMode_onKeyPress"];

dzn_gear_editMode_keyIsDown = false;
#define SET_GEAR_IF_EMPTY(ACT)	if (ACT player == "") then { [] } else { [ACT player] };
dzn_gear_editMode_primaryWeaponList = SET_GEAR_IF_EMPTY(primaryWeapon);
dzn_gear_editMode_primaryWeaponMagList = primaryWeaponMagazine player;

dzn_gear_editMode_handgunList  = SET_GEAR_IF_EMPTY(handgunWeapon);
dzn_gear_editMode_handgunMagList = handgunMagazine player;

dzn_gear_editMode_uniformList = SET_GEAR_IF_EMPTY(uniform);
dzn_gear_editMode_headgearList = SET_GEAR_IF_EMPTY(headgear);
dzn_gear_editMode_gogglesList = SET_GEAR_IF_EMPTY(goggles);
dzn_gear_editMode_vestList = SET_GEAR_IF_EMPTY(vest);
dzn_gear_editMode_backpackList = SET_GEAR_IF_EMPTY(backpack);

dzn_gear_editMode_arsenalOpened = false;
dzn_gear_editMode_arsenalTimerPause = 5;
dzn_gear_editMode_canCheck_ArsenalDiff = true;
dzn_gear_editMode_waitToCheck_ArsenalDiff = {
	dzn_gear_editMode_canCheck_ArsenalDiff = false;
	sleep dzn_gear_editMode_arsenalTimerPause;
	dzn_gear_editMode_canCheck_ArsenalDiff = true;
};

dzn_gear_editMode_controlsOverArsenalEH = -1;
dzn_gear_editMode_notif_pos = [.9,0,.4,1];
dzn_gear_editMode_lastInventory = [];

bis_fnc_arsenal_fullArsenal = true;
//["Preload"] call BIS_fnc_arsenal; 

hint parseText format["<t size='2' color='#FFD000' shadow='1'>dzn_gear</t>
	<br /><br /><t size='1.35' color='#3793F0' underline='true'>EDIT MODE</t>	
	<br /><t %1>This is an Edit mode where you can create gear kits for dzn_gear.</t>	
	<br /><br /><t size='1.35' color='#3793F0' underline='true'>VIRTUAL ARSENAL</t>	
	<br /><t %1>Use arsenal to choose your gear. Then Copy it and paste to dzn_gear_kits.sqf file.</t>
	<br /><br /><t size='1.25' color='#3793F0' underline='true'>KEYBINDING</t>
	<br /><t %1>Close ARSENAL and check keybinding of EDIT MODE by clicking [F1] button.</t>
	"
	, "align='left' size='0.9'"
];

[] spawn {
	if (!dzn_gear_ShowGearTotals || isNil "dzn_fnc_ShowMessage") exitWith {};
	waitUntil { time > 0 };
	nil call dzn_fnc_ShowMessage;

	waitUntil { isNull ( uinamespace getvariable "RSCDisplayArsenal") };
	["arsenal", "onEachFrame", {
		private["_inv"];
		if !(isNull ( uinamespace getvariable "RSCDisplayArsenal" )) then {
			if !(dzn_gear_editMode_arsenalOpened) then {
				dzn_gear_editMode_arsenalOpened = true;
			};

			if (dzn_gear_editMode_canCheck_ArsenalDiff) then {
				[] spawn dzn_gear_editMode_waitToCheck_ArsenalDiff;
				call dzn_fnc_gear_editMode_showGearTotals;
			};
			
			if (dzn_gear_editMode_controlsOverArsenalEH < 0) then {
				dzn_gear_editMode_controlsOverArsenalEH = (uinamespace getvariable "RSCDisplayArsenal") displayAddEventHandler [
					"KeyDown"
					, "_handled = _this call dzn_fnc_gear_editMode_onKeyPress"
				];
			};
		} else {
			if (dzn_gear_editMode_arsenalOpened) then {
				dzn_gear_editMode_arsenalOpened = false;
				dzn_gear_editMode_controlsOverArsenalEH = -1;
			};
		};
	}] call BIS_fnc_addStackedEventHandler;
};
