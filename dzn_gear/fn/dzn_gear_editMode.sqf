/* TODO:
	[ok] - Export kit in missionNamespace
	[ok] - highlight roles in list that already was used
	- Finish ammo bearier exporter page
		- Need to create component to track vars and stuff...
	- Page with all copied kits / composed elements to extract it again
*/


// **************************
// EDIT MODE
// **************************
#define DBG_PREFIX "(dzn_gear) "
#define DBG_ diag_log format [DBG_PREFIX +
#define EOL ]

#define Q(X) #X
#define SQ(X) 'X'
#define _F(X) fnc_##X
#define F(X) Q(_F(X))

#define COLOR_PALE_GREEN [0.54, 0.63, 0.44, 1]
#define COLOR_PALE_RED   [0.63, 0.54, 0.44, 1]
#define COLOR_STEEL_BLUE [0.24, 0.29, 0.34, 0.8]

#define COLOR_DARK_GREEN [0.5, 0.7, 0.6, 1]
#define COLOR_WHITE      [1,1,1,1]
#define COLOR_BLACK      [0,0,0,1]
#define COLOR_GOLD       [0.92, 0.81, 0, 1]

#define COLOR_HEX_GOLD   SQ(#FFD000)
#define COLOR_HEX_LIGHT_BLUE SQ(#84b0f0)
#define COLOR_HEX_LIGHT_GREEN SQ(#acdb8b)
#define COLOR_HEX_LIME SQ(#7bbf37)
#define COLOR_HEX_AQUA SQ(#12C4FF)
#define COLOR_HEX_BRICK_RED SQ(#eb4f34)

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
		<br />
		<br /><t %1>[{1...6}]</t><t %2> - Show item list and copy</t>
		<br /><t %1>[SHIFT + {1...6}]</t><t %2> - Set current item list and copy list</t>
		<br /><t %1>[CTRL + {1...6}]</t><t %2> - Add item to list and copy</t>
		<br /><t %1>[ALT + {1...6}]</t><t %2> - Clear item list</t>
		<br /><t align='left' size='0.8'>where
		<br />1 or C -- Primary weapon and magazine
		<br />2 or U -- Uniform
		<br />3 or H -- Headgear
		<br />4 or G -- Goggles
		<br />5 or V -- Vest
		<br />6 or B -- Backpack
		<br />7 or P -- Pistol and magazine
		<br />8 or L -- Secondary weapon and magazine
		<br /><t %1>CTRL + I</t><t %2> - copy unit/player identity settings</t>
		<br />
		<br /><t %1>PGUP/PGDOWN</t><t %2> - standard uniform/assigned items On/Off</t>
		<br /><t %1>DEL/CTRL + DEL</t><t %2> - clear current unit's gear</t>
		<br /><t %1>CTRL + F2/F2</t><t %2> - get/set Ammo Bearer backpack items</t>
		"
		, "align='left' color='#3793F0' size='0.9'"
		, "align='right' size='0.8'"
	];
};

#define SET_KEYDOWN	dzn_gear_editMode_keyIsDown = true; hint "";
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
		// F2 button
		case 60: {
			SET_KEYDOWN;
			if (_ctrl) then {
				[] spawn dzn_fnc_gear_editMode_showAmmoBearerGetterMenu;
			} else {
				[] spawn dzn_fnc_gear_editMode_showAmmoBearerSetterMenu;
			};
			SET_HANDLED;
		};

		// Space
		case 57: {
			SET_KEYDOWN;
			if (_ctrl) exitWith {
				dzn_fnc_gear_editMode_navBarIdx = 0; // -- Reset to Create Kit page
				[] call dzn_fnc_gear_editMode_handleMenu;
				SET_HANDLED;
			};

			if !(_ctrl || _alt || _shift) then {
				[] spawn {
					["#(argb,8,8,3)color(0,0,0,1)",false,nil,0.1,[0,0.5]] spawn bis_fnc_textTiles;
					sleep 0.3;
					if (dzn_gear_UseACEArsenalOnEdit) then {
						[player, player, true] call ace_arsenal_fnc_openBox;
					} else {
						["Open", true] call BIS_fnc_arsenal;
					};
				};
			};
			SET_HANDLED;
		};
		// 1 or C button - Primary weapon
		case 2;
		case 46:{
			SET_KEYDOWN;
			if (_shift) then {		["Primary", "SHIFT"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if (_ctrl) then {		["Primary", "CTRL"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if (_alt) then {		["Primary", "ALT"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if !(_ctrl || _alt || _shift) then { ["Primary", "NONE"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			SET_HANDLED;
		};
		// 7 or P button - Pistol
		case 8;
		case 25: {
			SET_KEYDOWN;
			if (_shift) then {		["Handgun", "SHIFT"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if (_ctrl) then {		["Handgun", "CTRL"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if (_alt) then {		["Handgun", "ALT"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if !(_ctrl || _alt || _shift) then { ["Handgun", "NONE"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			SET_HANDLED;
		};
		// 8 or L button - Launcher
		case 9;
		case 38: {
			SET_KEYDOWN;
			if (_shift) then {		["Secondary", "SHIFT"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if (_ctrl) then {		["Secondary", "CTRL"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if (_alt) then {		["Secondary", "ALT"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
			if !(_ctrl || _alt || _shift) then { ["Secondary", "NONE"] call dzn_fnc_gear_editMode_getCurrentWeapon; };
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

	[] spawn { uisleep 0.05; dzn_gear_editMode_keyIsDown = false; };
	_handled
};


// *****************************
//	Kit Getters
// *****************************

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

	if (dzn_gear_UseACEArsenalOnEdit) exitWith {
		[_text, "TOP", [0,0,0,.8], 5] call dzn_fnc_ShowMessage;
	};

	if (isNull ( uinamespace getvariable "RSCDisplayArsenal" )) then {
		hint parseText  _text;
	} else {
		[
			_text
			, "TOP"
			, [0,0,0,.8]
			, 5
		] call dzn_fnc_ShowMessage;
	};
};

dzn_fnc_gear_editMode_getCurrentWeapon = {
	params ["_type", "_key"];

	private _ownerUnit = if (isNull cursorTarget) then { player } else { driver cursorTarget };
	private _owner = if (isNull cursorTarget) then { "Player" } else { "Unit" };

	private ["_weaponList","_magList","_weapon","_magazine","_text"];
	switch toLower(_type) do {
		case "primary": {
			_weaponList = dzn_gear_editMode_primaryWeaponList;
			_magList = dzn_gear_editMode_primaryWeaponMagList;
			_weapon = primaryWeapon _ownerUnit;
			_magazine = (primaryWeaponMagazine _ownerUnit) select 0;
		};
		case "secondary": {
			_weaponList = dzn_gear_editMode_secondaryWeaponList;
			_magList = dzn_gear_editMode_secondaryWeaponMagList;
			_weapon = secondaryWeapon _ownerUnit;
			_magazine = (secondaryWeaponMagazine _ownerUnit) select 0;
		};
		case "handgun": {
			_weaponList = dzn_gear_editMode_handgunWeaponList;
			_magList = dzn_gear_editMode_handgunWeaponMagList;
			_weapon = handgunWeapon _ownerUnit;
			_magazine = (handgunMagazine _ownerUnit) select 0;
		};
	};

	private _wpnAndMag = {
		params ["_weaponList","_magList"];
		if (count _weaponList > 1) then {
			[_weaponList , _magList];
		} else {
			[ _weaponList select 0 , _magList select 0];
		};
	};

	switch (_key) do {
		case "SHIFT": {
			// Set
			_text = format ["<t color='#6090EE' size='1.1'>%3 weapon of %1 is COPIED</t><br />%2", _owner, _weapon, _type];
			_weaponList deleteRange [0, count _weaponList];
			_magList deleteRange [0, count _magList];

			_weaponList pushBack _weapon;
			_magList pushBack _magazine;

			copyToClipboard str([_weaponList, _magList ] call  _wpnAndMag);
		};
		case "CTRL": {
			// Add
			_text = format ["<t color='#6090EE' size='1.1'>%3 weapon of %1 is ADDED to list</t><br />%2", _owner, _weapon, _type];
			if !(_weapon in dzn_gear_editMode_primaryWeaponList) then {
				_weaponList pushBack _weapon;
				_magList pushBack _magazine;
			};
			copyToClipboard str([_weaponList, _magList ] call  _wpnAndMag);
		};
		case "ALT": {
			// Clear
			_text = format ["<t color='#6090EE' size='1.1'>%1 weapon is CLEARED</t>", _type];
			_weaponList deleteRange [0, count _weaponList];
			_magList deleteRange [0, count _magList];
		};
		default {
			// Show
			_text = format [
				"<t color='#6090EE' size='1.1'>%3 weapon list:</t><br /><t size='0.6' color='#FFD000'>Weapon</t><br />%1<br /><t size='0.6' color='#FFD000'>Magazines</t><br />%2"
				, [(([_weaponList, _magList ] call  _wpnAndMag) select 0), true] call dzn_fnc_gear_editMode_showAsStructuredList
				, [(([_weaponList, _magList ] call  _wpnAndMag) select 1), true] call dzn_fnc_gear_editMode_showAsStructuredList
				, _type
			];
			copyToClipboard str([_weaponList, _magList ] call  _wpnAndMag);
		};
	};


	if (dzn_gear_UseACEArsenalOnEdit) exitWith {
		[_text, "TOP", [0,0,0,.8], 5] call dzn_fnc_ShowMessage;
	};

	if (isNull ( uinamespace getvariable "RSCDisplayArsenal" )) then {
		hint parseText _text;
	} else {
		[
			_text
			, "TOP"
			, [0,0,0,.8]
			, 5
		] call dzn_fnc_ShowMessage;
	};
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

	private _name = _this;
	#define GetColors ["F","C","B","3","6","9"] call BIS_fnc_selectRandom
	private _colorString = format [
		"#%1%2%3%4%5%6", GetColors, GetColors, GetColors, GetColors, GetColors, GetColors
	];

	private _addKitAction = {
		// @ColorString, @Kit call _addKitAction
		params ["_name", "_color", "_kit"];

		player addAction [
			format [
				"<t color='%3'>%1 (at %2)</t>",
				_name,
				[time/3600, "HH:MM:SS"] call BIS_fnc_timeToString,
				_color
			],
			{
				params ["", "", "", "_kitArg"];
				if (isNull cursorTarget) exitWith {
					[player, _kitArg] call dzn_fnc_gear_assignGear;
				};
				if (cursorTarget isKindOf "CAManBase") then {
					[cursorTarget, _kitArg] call dzn_fnc_gear_assignGear;
				};
			},
			_kit ,0
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
		/* [@Kit(ARRAY), @Name(STRING)] call _formatAndCopyKit
		 * Formats and exports kit to copypaste into Kits.sqf
		 */
		params ["_kit", "_name"];
		private _newLine = "," + toString[10,32,32,32,32];
		private _str = format [
			"%1 = [" + toString[10,32,32,32,32] + "%2" + toString[10] + "];",
			_name,
			(_kit joinString _newLine)
		];

		copyToClipboard _str;
	};

	private _copyUnitKit = {
		params ["_title", "_kit", "_name", "_colorString"];

		_kit call _replaceDefaultMagazines;
		[_name, _colorString, +_kit] call _addKitAction;
		_kit call _useStandardItems;
		[_kit, _name] call _formatAndCopyKit;

		missionNamespace setVariable [_name, _kit];

		["KIT_COPIED", [_title, _colorString]] call dzn_fnc_gear_editMode_showNotif;
	};

	private _copyCargoKit = {
		params ["_title", "_kit", "_name", "_colorString"];

		// Format of output
		private _str = str(_kit);
		private _formatedString = "";
		private _lastId = 0;
		for "_i" from 0 to ((count _str) - 1) do {
			if (_str select [_i,2] in ["[[","[]"]) then {
				_formatedString = format[
						"%1
	%2"
					, _formatedString
					, _str select [_lastId, _i - _lastId]
				];
				_lastId = _i;
			};

			if (_i == ((count _str) - 1)) then {
				_formatedString = format[
					"%1
	%2
];"
					, _formatedString
					, _str select [_lastId, _i - _lastId]
				];
			};
		};

		_formatedString = format ["cargo_%1 = %2", _name, [_formatedString,4] call BIS_fnc_trimString];
		copyToClipboard _formatedString;

		[_colorString, _kit] call _addCargoKitAction;
		["KIT_COPIED", ["Cargo", _colorString]] call dzn_fnc_gear_editMode_showNotif;
	};

	if (isNull cursorTarget) then {
		// Player
		["Player's", player call dzn_fnc_gear_getGear, _name, _colorString] call _copyUnitKit;
		// [_colorString, (player call dzn_fnc_gear_getGear)] call _addKitAction; };
	} else {
		if (cursorTarget isKindOf "CAManBase") then {
			// Unit
			["Unit's", cursorTarget call dzn_fnc_gear_getGear, _name, _colorString] call _copyUnitKit;
			// [_colorString, (cursorTarget call dzn_fnc_gear_getGear)] call _addKitAction;
		} else {
			// Vehicle
			["Vehicle's", cursorTarget call dzn_fnc_gear_getCargoGear, _name, _colorString] call _copyCargoKit;
		};
	};
};

dzn_fnc_gear_editMode_formatCargoKit = {
	params ["_name", "_kit"];

	private _output = [
		format ["%1 = [", _name],
        	(_kit apply { format ["    %1", _x] }) joinString toString[44,13,10],
        	 "];"
        ];

	_output joinString toString[10]
};


// --- Menu
dzn_fnc_gear_editMode_navBarIdx = 0;
dzn_fnc_gear_editMode_navBarPages = [
	createHashMapFromArray [
		["title", "Main"],
		["renderer", 'dzn_fnc_gear_editMode_showMenu_Main'],
		["description", "Allows to export player or cursor unit/vehicle/box kit to clipboard."]
	],
	createHashMapFromArray [
		["title", "Cargo Kit Composer"],
		["renderer", 'dzn_fnc_gear_editMode_showMenu_CargoKitComposer'],
		["description", "Tool to compose cargo kit from multiple personal kits."]
	],
	createHashMapFromArray [
		["title", "Ammo Bearer Composer"],
		["renderer", 'dzn_fnc_gear_editMode_showMenu_AmmoCarrierComposer'],
		["description", "Tool to prepare backpack loadout for ammo beariers based on current weapon or weapon from other kit."]
	]
];

dzn_fnc_gear_editMode_handleMenu = {
	params [["_paginationDirection", 0]];

	private _targetPageIdx = dzn_fnc_gear_editMode_navBarIdx + _paginationDirection;
	private _maxIdx = (count dzn_fnc_gear_editMode_navBarPages) - 1;
	private _getInRangeIndex = {
		params ["_idx"];
		[
			[_idx, 0] select (_idx > _maxIdx),
			_maxIdx
		] select (_idx < 0)
	};

	dzn_fnc_gear_editMode_navBarIdx = [_targetPageIdx] call _getInRangeIndex;

	private _targetPage = dzn_fnc_gear_editMode_navBarPages # dzn_fnc_gear_editMode_navBarIdx;
	private _prevPage = dzn_fnc_gear_editMode_navBarPages # ([_targetPageIdx - 1] call _getInRangeIndex);
	private _nextPage = dzn_fnc_gear_editMode_navBarPages # ([_targetPageIdx + 1] call _getInRangeIndex);

	private _menu = [
		["HEADER", "dzn_Gear Menu"],
		[
			"BUTTON",
			"<t align='center'>&lt;</t>",
			{
				params ["_ad"];
				[-1] call dzn_fnc_gear_editMode_handleMenu;
			}, [],
			[["w", 0.25], ["size", 0.05], ["tooltip", _prevPage get "title"]]
		],
		[
			"LABEL",
			format ["<t align='center'>%1</t>", _targetPage get "title"],
			[
				["bg", [0,0,0,1]],
				["size", 0.05],
				["tooltip", _targetPage get "description"]
			]
		],
		[
			"BUTTON",
			"<t align='center'>&gt;</t>",
			{
				params ["_ad"];
				[+1] call dzn_fnc_gear_editMode_handleMenu;
			}, [],
			[["w", 0.25], ["size", 0.05], ["tooltip", _nextPage get "title"]]
		],
		["BR"]
	];

	[_menu] call (missionNamespace getVariable (_targetPage get "renderer"));
};


dzn_fnc_gear_editMode_showMenu_Main = {
	params ["_menuNavbar"];

	private _options = [
		["None", "no", [["tooltip", "No overrides"]]],
		["Standard", "standard", [["tooltip", "Overrides with standard items (defined in Settings file)"]]],
		["Squad Leader", "leader", [["tooltip", "Overrides with leader items (defined in Settings file)"]]]
	];
	private _assignedItemsCurSel = _options findIf {dzn_gear_UseStandardAssignedItems == _x # 1};
	private _uniformItemsCurSel = _options findIf {dzn_gear_UseStandardUniformItems == _x # 1};

	// -- Higlight kits that already exists with current key + role
	private _roles = dzn_gear_kitRoles apply {
		[_x # 0, _x # 1, [
			[
				"color", [
					COLOR_WHITE, COLOR_DARK_GREEN
				] select (!isNil format ["kit_%1_%2", dzn_gear_kitKey, _x # 1])
			],
			["tooltip", _x # 1]
		]]
	};

	private _menu = _menuNavbar + [
		[
			"LABEL",
			"<t size='0.9'>Kit name should be in format: kit_usmc_ar, where ""usmc"" is a key to faction and ""ar"" is a role."
		],
		["BR"],

		["LABEL", "<t size='0.9'>On pressing ""GET"" button - formatted kit will be copied to the clipboard"],
		["BR"],["LABEL"],["BR"],

		["LABEL"],
		["LABEL", "Key"],
		["LABEL", "Role"],
		["BR"],

		["LABEL", "Set kit by role: <t align='right'>kit_</t>"],
		["INPUT", dzn_gear_kitKey, [["tag", "i_kitKey"]], [
			["EditChanged", {
				params ["_eventData", "_dialogCOB", "_args"];
				private _ctrl = _dialogCOB call ["GetByTag", "d_rolename"];
				{
					_ctrl lbSetColor [
						_forEachIndex,
						[
							COLOR_WHITE, COLOR_DARK_GREEN
						] select (!isNil format ["kit_%1_%2", _eventData # 1, _x # 1])
					];
				} forEach dzn_gear_kitRoles;
			}]
		]],
		["DROPDOWN", _roles /* dzn_gear_kitRoles */, dzn_gear_kitRolesId, [["tag", "d_rolename"]]],
		["BR"],

		["LABEL", "or"],
		["BR"],

		["LABEL", "Set custom name: <t align='right'>kit_</t>"],
		["INPUT", "", [["tag", "i_customName"]]],
		["LABEL", "<t size='0.8' color='#ff3333'>No special symbols/spaces!</t>"],
		["BR"],

		["LABEL"],["BR"],

		[
			"LABEL",
			"<t size='0.9'>Option to override ASSIGNED_ITEMS and UNIFORM_ITEMS by presets defined in Settings</t>",
			[["bg", COLOR_STEEL_BLUE]]
		],
		["BR"],

		["LABEL", "Assigned items"],
		["LISTBOX", _options, _assignedItemsCurSel, [["tag", "l_assignedItems"]]],
		["BR"],

		["LABEL", "Uniform items"],
		["LISTBOX", _options, _uniformItemsCurSel, [["tag", "l_uniformItems"]]],
		["BR"],

		["LABEL", ""],
		["BUTTON", "<t align='center'>GET</t>", {
			params ["_ad"];
			private _vals = _ad call ["GetTaggedValues"];

			dzn_gear_UseStandardAssignedItems = (_vals get "l_assignedItems") # 2;
			dzn_gear_UseStandardUniformItems = (_vals get "l_uniformItems") # 2;
			dzn_gear_kitRolesId = (_vals get "d_rolename") # 0;

			private _customName = _vals get "i_customName";
			private _name = format ["kit_%1", _customName];
			if (_customName == "") then {
				dzn_gear_kitKey = _vals get "i_kitKey";
				_name = format [
					"kit_%1_%2",
					dzn_gear_kitKey,
					(_vals get "d_rolename") # 2
				];
			};
			_ad call ["Close"];
			_name call dzn_fnc_gear_editMode_createKit;
		}, [], [["w",0.25], ["bg", COLOR_PALE_GREEN]]]
	];

	_menu call dzn_fnc_ShowAdvDialog2;
};

dzn_fnc_gear_editMode_showMenu_AmmoCarrierComposer = {
	/*
		Menu to select ammo from current's unit gear or from given kit name
	*/
	params ["_menuNavbar"];

	private _menu = _menuNavbar + [
		["LABEL", "Find and load kit by name or use your current loadout"],
		["BR"],

		[
			"INPUT", "",
			[
				["tag", "i_kitname"],
				["tooltip", "(optional) Load kit's weapon/launcher. On loading empty - current gear will be used."]
			],
			[
				[
					"EditChanged",
					{
						params ["_eventData", "_dialogCOB", "_args"];
						(_eventData # 0) ctrlSetTextColor (
							[COLOR_WHITE, COLOR_DARK_GREEN] select (!isNil (_eventData # 1))
						);
					}
				]
			]
		],
		["BUTTON", "Load kit", {
			params ["_dialogCOB"];
			dzn_gear_AmmoBearearComponent call [F(onKitLoad), [_dialogCOB, _kit]];
		}, [], [["bg", COLOR_STEEL_BLUE]]],
		["BR"],

		["LABEL"], ["BR"],

		["BUTTON", "Primary Weapon", {
			params ["_dialogCOB"];
			dzn_gear_AmmoBearearComponent call [F(onWeaponSelected), [_dialogCOB, 0]];
		}, [], [["tag", "btn_primary"], ["h", 0.12]]],
		["BUTTON", "Launcher Weapon", {
			params ["_dialogCOB"];
			dzn_gear_AmmoBearearComponent call [F(onWeaponSelected), [_dialogCOB, 1]];
		}, [], [["tag", "btn_launcher"], ["h", 0.12]]],
		["BR"],

		["LABEL", "Total magazines count: 0", [["bg", COLOR_STEEL_BLUE], ["tag", "lbl_magTotalCount"]]],
		["BR"],

		["DROPDOWN", _allMags, 0, [["tag", "d_maglist"],["w", 0.75], ["h", 0.1]]],
		["BUTTON", "<t align='center' size='2' color='#000000'>+</t>", {
			params ["_dialogCOB"];
			dzn_gear_AmmoBearearComponent call [F(onMagazineAdd), [_dialogCOB, 1]];
		},[],[["bg", COLOR_PALE_GREEN], ["h", 0.1]]],
		["BUTTON", "<t align='center' size='2' color='#000000'>—</t>", {
			params ["_dialogCOB"];
			dzn_gear_AmmoBearearComponent call [F(onMagazineRemove), [_dialogCOB, 1]];
		},[],[["bg", COLOR_PALE_RED], ["h", 0.1]]],
		["BR"],
		["LABEL", "",[["h",0.02]]], ["BR"],

		["LABEL","",[["tag", "lbl_magInfo"], ["h", 0.23], ["x",0.1], ["w",0.9]]],
		["BR"],

		["BUTTON", "<t align='center'>Clear</t>", {
			params ["_dialogCOB"];
			dzn_gear_AmmoBearearComponent call [F(onClear), [_dialogCOB]];
		}, [], [["bg", COLOR_PALE_RED], ["tooltip", "Clears selected pool of magazines."]]],

		["BUTTON", "<t align='center'>Apply to self</t>", {
			dzn_gear_AmmoBearearComponent call [F(composeAndExport), [true]];
		}, [], [["bg", COLOR_PALE_GREEN], ["tooltip", "Puts selected pool of magazines to your backpack."]]],

		["BUTTON", "<t align='center'>Compose</t>", {
			dzn_gear_AmmoBearearComponent call [F(composeAndExport), [false]];
		}, [], [["bg", COLOR_PALE_GREEN], ["tooltip", "Exports composed line to clipboard."]]],

		["BR"],
		["OnDraw", {
			params ["_dialogCOB"];
			dzn_gear_AmmoBearearComponent call [F(onKitLoad), [_dialogCOB]];
		}]

	];
	_menu call dzn_fnc_ShowAdvDialog2;
};

dzn_fnc_gear_editMode_showMenu_CargoKitComposer = {
	params ["_menuNavbar"];

	private _onButtonClick = {
		params ["_ad"];
		private _vals = _ad call ["GetTaggedValues"];
		if ((_vals get "i_filter") == "") exitWith {};
		private _filterBy = compile ((
			(_vals get "i_filter") splitString ","
		) apply {
			format ["(_x select [0, count ""%1""] == ""%1"")", trim _x]
		} joinString " || ");

		private _kits = (allVariables missionNamespace) select _filterBy apply {
			missionNamespace getVariable _x
		} select { (_x # 0) isEqualType [] };
		DBG_ "Filtered: %1", _kits EOL;

		private _composed = [
			_kits,
			(_vals get "s_weaponCount") # 0,
			(_vals get "s_magazineCount") # 0,
			(_vals get "s_itemCount") # 0,
			(_vals get "s_backpackCount") # 0
		] call dzn_fnc_gear_editMode_composeCargoItemsFromKits;
		private _exported = [
			_vals getOrDefault ["i_name","cargo_kit_test"],
			_composed
		] call dzn_fnc_gear_editMode_formatCargoKit;
		copyToClipboard _exported;

		["KIT_COPIED", ["Cargo", "#FFCC00"]] call dzn_fnc_gear_editMode_showNotif;
	};

	private _onSliderChanged = {
		params ["_eventArgs", "_ad", "_args"];
		_eventArgs params ["", "_newValue"];
		(_ad call ["GetByTag", _args]) ctrlSetStructuredText parseText format ["<t align='right'>x%1</t>", _newValue];
	};

	#define MENU_CARGO_COMPOSER_WIDTH 0.3
	#define MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH 0.075
	private _menu = _menuNavbar + [
		["LABEL", "<t size='0.9'>Enter full name of the personal kit or prefix (like ""kit_usmc_"") to generate cargo kit.</t>"],
		["BR"],
		["LABEL", "<t size='0.9'>You can also enter several names using comma.</t>"],
		["BR"],
		["LABEL", format [
			"<t size='0.9'><t color='%1'>Note:</t> Uniform items will be ignored for session-generated kits.</t>",
			COLOR_HEX_BRICK_RED
		]],
		["BR"],

		["LABEL", format [
			"<t color='%1'>Filter (personal kits)*</t>",
			COLOR_HEX_LIGHT_BLUE
		], [["w", MENU_CARGO_COMPOSER_WIDTH], ["bg", COLOR_STEEL_BLUE]]],
		["INPUT", "", [["tag", "i_filter"]]],
		["BR"],
		["LABEL", "Export name", [["w", MENU_CARGO_COMPOSER_WIDTH], ["bg", COLOR_STEEL_BLUE]]],
		["INPUT", "cargo_kit_test", [["tag", "i_name"], ["tooltip", "Name of the generated cargo kit"]]],
		["BR"],

		["LABEL", "Weapons count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
		["LABEL", "<t align='right'>x2</t>", [["tag", "l_counterW"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
		["SLIDER", [1,30,1], 2, [["tag", "s_weaponCount"], ["tooltip", "Number of weapons in generated kit"]], [
			["SliderPosChanged", _onSliderChanged, "l_counterW"]
		]],
		["BR"],

		["LABEL", "Magazines count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
		["LABEL", "<t align='right'>x20</t>", [["tag", "l_counterM"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
		["SLIDER", [1,30,1], 20, [["tag", "s_magazineCount"], ["tooltip", "Number of magazines in generated kit"]], [
			["SliderPosChanged", _onSliderChanged, "l_counterM"]
		]],
		["BR"],

		["LABEL", "Item count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
		["LABEL", "<t align='right'>x10</t>", [["tag", "l_counterI"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
		["SLIDER", [1,30,1], 10, [["tag", "s_itemCount"], ["tooltip", "Number of items in generated kit"]], [
			["SliderPosChanged", _onSliderChanged, "l_counterI"]
		]],
		["BR"],

		["LABEL", "Backpack count", [["w", MENU_CARGO_COMPOSER_WIDTH]]],
		["LABEL", "<t align='right'>x1</t>", [["tag", "l_counterB"], ["w", MENU_CARGO_COMPOSER_SLIDER_INDICATOR_WIDTH]]],
		["SLIDER", [1,30,1], 1, [["tag", "s_backpackCount"], ["tooltip", "Number of backpacks in generated kit"]], [
			["SliderPosChanged", _onSliderChanged, "l_counterB"]
		]],
		["BR"],

		["LABEL"],["BR"],
		["LABEL"],
		["BUTTON", "<t align='center'>Compose</t>", _onButtonClick, [],[["w", 0.25], ["bg", COLOR_PALE_GREEN]]]
	];
	_menu call dzn_fnc_ShowAdvDialog2;
};


// *****************************
//	Options
// *****************************
dzn_fnc_gear_editMode_setOptions = {
	/* [@Option] call dzn_fnc_gear_editMode_setOptions
	 *	Options:
	 *		UseStandardUniformItems
	 *		UseStandardAssignedItems
	 */
	switch toLower(_this select 0) do {
		case toLower("UseStandardUniformItems"): {
			dzn_gear_UseStandardUniformItems = switch (toLower(dzn_gear_UseStandardUniformItems)) do {
				case "no": {"standard"};
				case "standard": {"leader"};
				case "leader": {"no"};
			};
			["OPTION_UNIFORM", [toUpper(dzn_gear_UseStandardUniformItems)]] call dzn_fnc_gear_editMode_showNotif;
		};
		case toLower("UseStandardAssignedItems"): {
			dzn_gear_UseStandardAssignedItems = switch (toLower(dzn_gear_UseStandardAssignedItems)) do {
				case "no": {"standard"};
				case "standard": {"leader"};
				case "leader": {"no"};
			};
			["OPTION_ASSIGNED", [toUpper(dzn_gear_UseStandardAssignedItems)]] call dzn_fnc_gear_editMode_showNotif;
		};
	};
};

// *****************************
//	Ammo Bearer Items
// *****************************
dzn_fnc_gear_editMode_showAmmoBearerGetterMenu = {
	private _menu = [
		[0, "HEADER", "GET AMMO BEARER ITEMS"]
		, [1, "LABEL", "NAME"]
		, [1, "INPUT"]
	];
	private _lineNo = 2;
	dzn_gear_editMode_addMagazineTypes = [false,false];

	if (primaryWeapon player != "") then {
		_menu pushBack [_lineNo, "LABEL", "PRIMARY WEAPON MAGAZINES"];
		_lineNo = _lineNo + 1;

		private _listOfMags = [""] + getArray(configFile >> "CfgWeapons" >> primaryWeapon player >> "magazines");

		for "_i" from 1 to 4 do {
			_menu = _menu + [
				[ _lineNo, "LABEL", format ["<t align='right'>TYPE #%1</t>", _i]]
				, [ _lineNo, "DROPDOWN", _listOfMags apply { _x call dzn_fnc_getItemDisplayName }, _listOfMags]
				, [ _lineNo, "SLIDER", [0,8,0]]
			];
			_lineNo = _lineNo + 1;
		};

		dzn_gear_editMode_addMagazineTypes set [0, true];
	};

	if (secondaryWeapon player != "") then {
		_menu pushBack [_lineNo, "LABEL", "LAUNCHER MAGAZINES"];
		_lineNo = _lineNo + 1;

		private _listOfMags = [""] +  getArray(configFile >> "CfgWeapons" >> secondaryWeapon player >> "magazines");

		for "_i" from 1 to 4 do {
			_menu = _menu + [
				[ _lineNo, "LABEL", format ["<t align='right'>TYPE #%1</t>", _i]]
				, [ _lineNo, "DROPDOWN", _listOfMags apply { _x call dzn_fnc_getItemDisplayName }, _listOfMags]
				, [ _lineNo, "SLIDER", [0,8,0]]
			];
			_lineNo = _lineNo + 1;
		};

		dzn_gear_editMode_addMagazineTypes set [0, true];
	};

	_menu = _menu + [
		[_lineNo,"LABEL", ""]
		,[_lineNo + 1,"BUTTON", "CANCEL", { closeDialog 2; }]
		,[_lineNo + 1,"LABEL", ""]
		,[_lineNo + 1,"LABEL", ""]
		,[_lineNo + 1,"BUTTON", "SAVE", {
			private _name = (_this select 0) select 0;
			private _magList = [];

			if (true in dzn_gear_editMode_addMagazineTypes) then {
				for "_i" from 1 to (count _this) step 2 do {
					if ((_this select _i) select 0 != 0) then {
						_magList pushBack [
							((_this select _i) select 2) select ((_this select _i) select 0)
							, ((_this select (_i + 1)) select 0)
						];
					};
				};
			};

			dzn_gear_editMode_ammoBearerItemsKits pushBack [
				if (_name == "") then { format ["Bearer #%1", (count dzn_gear_editMode_ammoBearerItemsKits) + 1] } else { _name }
				, _magList
			];
			closeDIalog 2;
			["BEARER_SAVED"] call dzn_fnc_gear_editMode_showNotif;
		}]
	];

	if (_lineNo == 2) then {
		_menu = [
			[0, "HEADER", "GET AMMO BEARER ITEMS"]
			, [1, "LABEL", "<t align='center'>NO WEAPONS</t>"]
			, [1, "BUTTON", "CLOSE", { closeDialog 2; }]
		];
	};

	_menu call dzn_fnc_ShowAdvDialog;
};

dzn_fnc_gear_editMode_showAmmoBearerSetterMenu = {
	[
		[0, "HEADER", "SET AMMO BEARER ITEMS"]
		, [1, "LABEL", "BEARER ITEMS LIST"]
		, [2, "LABEL", ""]
		, [2, "DROPDOWN", dzn_gear_editMode_ammoBearerItemsKits apply { _x select 0 }, []]
		, [2, "LABEL", ""]
		, [3, "LABEL", ""]
		, [4, "BUTTON", "CANCEL", { closeDialog 2; }]
		, [4, "BUTTON", "COPY", {
			copyToClipboard str( ((dzn_gear_editMode_ammoBearerItemsKits select { (_x select 0) == (_this select 0) select 1 }) select 0) select 1 );
			["BEARER_COPIED"] call dzn_fnc_gear_editMode_showNotif;
		}]
		, [4, "BUTTON", "APPLY", {
			closeDialog 2;
			if (backpack player == "") exitWith { hint "You have no backpack to add ammo set!"; };

			{ player removeItemFromBackpack _x; } forEach (backpackItems player);
			private _mags = ((dzn_gear_editMode_ammoBearerItemsKits select { (_x select 0) == (_this select 0) select 1 }) select 0) select 1;
			{
				private _mag = _x select 0;
				private _count = _x select 1;

				for "_i" from 1 to _count do { player addItemToBackpack _mag;	};
			} forEach _mags;

			["BEARER_ADDED"] call dzn_fnc_gear_editMode_showNotif;
		}]
	] call dzn_fnc_ShowAdvDialog;
};

// *****************************
//	Cargo kit composer menu
// *****************************

dzn_fnc_gear_editMode_composeCargoItemsFromKits = {
	params [
		["_kits", nil, [[]]],
		["_weaponCount", 1, [0]],
		["_magazineCount", 1, [0]],
		["_itemCount", 1, [0]],
		["_backpackCount", 1, [0]]
	];

	private _items = [];
	// -- Gather list of items all over the kits
	{
		DBG_ "(composeCargoItems) Kit=%1", _x EOL;
		_x params [
			["_equip", nil, [[]]], "_pw", "_sw", "_hw",
			"",
			"_uniform","_vest","_backpack"
		];
		DBG_ "(composeCargoItems) Equip=%1", _equip EOL;
		DBG_ "(composeCargoItems) _pw=%1", _pw EOL;
		DBG_ "(composeCargoItems) _sw=%1", _sw EOL;
		DBG_ "(composeCargoItems) _sw=%1", _sw EOL;

		// In case kit created and accessed in runtime and uniform items macro was used
		if (_uniform isEqualType "") then {
			_uniform = ["",[]];
		};

		{
			// -- Handle randomized items declaration
			if (_x isEqualType []) then {
				{ _items pushBackUnique _x; } forEach _x;
				continue;
			};
			// -- Add plain item declaration
			_items pushBackUnique _x
		} forEach [
			// -- Backpack
			_equip # 3,
			// -- Primary weapon and mag
			_pw # 1, _pw # 2,
			// -- Secondary weapon and mag
			_sw # 1, _sw # 2,
			// -- Handgun magazine
			_hw # 2
		]
		// -- Items in uniform, vest and backpack
		+ ((_uniform # 1) apply { _x # 0 })
		+ ((_vest # 1) apply { _x # 0 })
		+ ((_backpack # 1) apply { _x # 0 });
	} forEach _kits;

	// -- Compose Cargo kit from it
	private _cargoWeapons = [];
	private _cargoMagazines = [];
	private _cargoItems = [];
	private _cargoBackpacks = [];

	private _cfgWeapons = configFile >> "CfgWeapons";
	private _cfgMagazines = configFile >> "CfgMagazines";
	private _cfgBackpacks = configFile >> "CfgVehicles";

	{
		if (_x in ["", "PRIMARY MAG", "SECONDARY MAG", "HANDGUN MAG"]) then { continue; };
		if (getArray (_cfgWeapons >> _x >> "muzzles") isNotEqualTo []) then {
			_cargoWeapons pushBack [_x, _weaponCount];
			continue;
		};
		if (isClass(_cfgMagazines >> _x)) then {
			_cargoMagazines pushBack [_x, _magazineCount];
			continue;
		};
		if (isClass(_cfgBackpacks >> _x)) then {
			_cargoBackpacks pushBack [_x, _backpackCount];
			continue;
		};
		_cargoItems pushBack [_x, _itemCount];
	} forEach _items;

	[_cargoWeapons, _cargoMagazines, _cargoItems, _cargoBackpacks];
};

// *****************************
//	Items Display functions
// *****************************
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
	switch (true) do {
		case ( isText (configFile >> "CfgWeapons" >> _this >> "displayName") ): {
			getText(configFile >> "CfgWeapons" >> _this >> "displayName")
		};
		case ( isText (configFile >> "CfgMagazines" >> _this >> "displayName") ): {
			getText(configFile >> "CfgMagazines" >> _this >> "displayName")
		};
		case ( isText (configFile >> "CfgVehicles" >> _this >> "displayName") ): {
			getText(configFile >> "CfgVehicles" >> _this >> "displayName")
		};
		case ( isText (configFile >> "CfgGlasses" >> _this >> "displayName") ): {
			getText(configFile >> "CfgGlasses" >> _this >> "displayName")
		};
		default {
			""
		};
	}
};

dzn_fnc_gear_editMode_getVehicleName = {
	// @Name = @Classname call dzn_fnc_gear_editMode_getVehicleName
	getText(configFile >>  "CfgVehicles" >> _this >> "displayName")
};

dzn_fnc_gear_editMode_showGearTotals = {
	// @ArrayOfTotals call dzn_fnc_gear_editMode_showGearTotals
	private _headlineItems = [
		uniform player
		, vest player
		, backpack player
		, headgear player
		, goggles player
		, primaryWeapon player
		, secondaryWeapon player
		, handgunWeapon player
	] apply { _x call dzn_fnc_gear_editMode_getItemName };

	private _wpnItems = [];
	private _wpnItemTemplate = "<t color='#AAAAAA' align='left' size='0.8'>[%1] %2</t>";
	{
		private _arr = _x select 0;
		private _label = _x select 1;

		_wpnItems = _wpnItems + (
			_arr apply {
				private _name = _x call dzn_fnc_gear_editMode_getItemName;
				if (_name != "") then {
					parseText (format [_wpnItemTemplate, _label, _name])
				} else { "" }
			}
		);
	} forEach [
		[ (primaryWeaponItems player), "Primary" ]
		,[ (secondaryWeaponItems player), "Secondary" ]
		,[ (handgunItems player), "Handgun" ]
	];

	private _itemsAndMagazines = (((
		(assignedItems player)
		+ (itemsWithMagazines player)
	) call bis_fnc_consolidateArray) apply {
		private _name = (_x select 0) call dzn_fnc_gear_editMode_getItemName;
		private _line = "";
		if ((_x select 0) != "") then {
			_line = if (_x select 1 > 1) then {
				parseText (format ["<t color='#AAAAAA' align='left' size='0.8'>x%1 %2</t>", _x select 1, _name])
			} else {
				parseText (format ["<t color='#AAAAAA' align='left' size='0.8'>%1</t>", _name])
			}
		};

		_line
	});

	#define	IFNAME(X)	if ((_headlineItems select X) == "") then { "-no-" } else { _headlineItems select X }
	private _stringsToShow = [
		parseText "<t color='#FFD000' size='1' align='center'>GEAR TOTALS</t>"
		, parseText format ["<t color='#3F738F' align='left' size='0.8'>Uniform:</t><t align='right' size='0.8'>%1</t>", IFNAME(0) ]
		, parseText format ["<t color='#3F738F' align='left' size='0.8'>Vest:</t><t align='right' size='0.8'>%1</t>", IFNAME(1)]
		, parseText format ["<t color='#3F738F' align='left' size='0.8'>Backpack:</t><t align='right' size='0.8'>%1</t>", IFNAME(2)]
		, parseText format ["<t color='#3F738F' align='left' size='0.8'>Headgear:</t><t align='right' size='0.8'>%1</t>", IFNAME(3)]
		, parseText format ["<t color='#3F738F' align='left' size='0.8'>Goggles:</t><t align='right' size='0.8'>%1</t>", IFNAME(4)]
		, parseText format ["<t color='#059CED' align='left' size='0.8'>Primary:</t><t align='right' size='0.8'>%1</t>", IFNAME(5)]
		, parseText format ["<t color='#059CED' align='left' size='0.8'>Secondary:</t><t align='right' size='0.8'>%1</t>", IFNAME(6)]
		, parseText format ["<t color='#059CED' align='left' size='0.8'>Handgun:</t><t align='right' size='0.8'>%1</t>", IFNAME(7)]
	];

	[
		_stringsToShow + _wpnItems + _itemsAndMagazines - [""]
		, [35.2,-7.1, 35, 0.03]
		, dzn_gear_GearTotalsBG_RGBA
		, dzn_gear_editMode_arsenalTimerPause
	] call dzn_fnc_ShowMessage;
};


// *****************************
//	Utilities
// *****************************
dzn_fnc_gear_editMode_showNotif = {
	params ["_type", ["_msgParams", []]];

	private _msg = switch toUpper(_type) do {
		case "OPTION_UNIFORM": {
			format ["<t align='right' font='PuristaBold' size='1'>Use Uniform Items override: <t color='#FFD000'>%1</t></t>", _msgParams select 0];
		};
		case "OPTION_ASSIGNED": {
			format ["<t align='right' font='PuristaBold' size='1'>Use Assigned Items override: <t color='#FFD000'>%1</t></t>", _msgParams select 0];
		};
		case "OPTION_SAVED": {
			[
				format ["<t align='right' font='PuristaBold' size='1'>Use Assigned Items override: <t color='#FFD000'>%1</t></t>", _msgParams select 0],
				format ["<t align='right' font='PuristaBold' size='1'>Use Uniform Items override: <t color='#FFD000'>%1</t></t>", _msgParams select 1]
			] joinString "<br/>"
		};
		case "BEARER_COPIED": {
			"<t align='right' font='PuristaBold' size='1'>Ammo Bearer Items were <t color='#FFD000'>copied</t></t>";
		};
		case "BEARER_ADDED": {
			"<t align='right' font='PuristaBold' size='1'>Ammo Bearer Items were <t color='#FFD000'>set to backpack</t></t>";
		};
		case "KIT_COPIED": {
			format ["<t align='right' font='PuristaBold' size='1.1'><t color='%2'>%1</t> kit copied</t>", _msgParams select 0, _msgParams select 1];
		};
	};

	[parseText _msg, true, nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
};


// *****************************
//	Initialization
// *****************************

dzn_gear_AmmoBearearComponent = createHashMapObject [[
	[Q(CurrentWeapons), []],
	[Q(CurrentWeaponsMags), []],
	[Q(CurrentMode), [false, false]],
	[Q(CurrentMagPool), createHashMap],
	[Q(CurrentSelectedMagazine), ""],
	[Q(TotalMagCount), 0],

	// -- UI events
	[F(onKitLoad), {
		params ["_dialogCOB"];
		DBG_ "(ABC.onKitLoad) Invoked" EOL;
		_self call [F(resetControls), [_dialogCOB]];

		private _kitname = _dialogCOB call ["GetValueByTag", "i_kitname"];
		_self call [F(loadKitData), [_kitname]];

		// -- Update UI
		_self call [F(render), [_dialogCOB]];
	}],
	[F(onWeaponSelected), {
		params ["_dialogCOB", "_weaponId"];
		DBG_ "(ABC.onWeaponSelected) Invoked. _weaponId=%1", _weaponId EOL;

		// -- Update state
		private _mode = _self getOrDefault [Q(CurrentMode), [false, false]];
		_mode set [_weaponId, !(_mode # _weaponId)];
		DBG_ "(ABC.onWeaponSelected) Mode after = %1", _mode EOL;

		private _currentDropdwonItem = "";
		private _lbCtrl = _dialogCOB call ["GetByTag", "d_maglist"];
		private _lbCurSel = lbCurSel _lbCtrl;
		if (_lbCurSel > -1 && (_lbCtrl getVariable Q(listValues)) isNotEqualTo []) then {
			DBG_ "(ABC.onWeaponSelected) listValues = %1", _lbCtrl getVariable Q(listValues) EOL;
			DBG_ "(ABC.onWeaponSelected) _lbCurSel = %1", _lbCurSel EOL;

			_currentDropdwonItem = (_lbCtrl getVariable Q(listValues)) select _lbCurSel;
		};
		_self set [Q(CurrentSelectedMagazine), _currentDropdwonItem];
		DBG_ "(ABC.onWeaponSelected) _currentDropdwonItem = %1", _currentDropdwonItem EOL;

		// -- Update UI
		_self call [F(renderWeaponTypeButtons), [_dialogCOB]];
		_self call [F(renderMagazinesListDropdown), [_dialogCOB]];
	}],
	[F(onMagazineAdd), {
		params ["_dialogCOB", "_count"];
		DBG_ "(ABC.onMagazineAdd) Invoked. _count=%1", _count EOL;
		private _magClass = (_dialogCOB call ["GetValueByTag", "d_maglist"]) # 2;
		_self call [F(addMagazine), [_magClass, _count]];
		_self set [Q(CurrentSelectedMagazine), _magClass];
		// -- Update UI
		_self call [F(render), [_dialogCOB]];
	}],
	[F(onMagazineRemove), {
		params ["_dialogCOB", "_count"];
		DBG_ "(ABC.onMagazineRemove) Invoked. _count=%1", _count EOL;
		private _magClass = (_dialogCOB call ["GetValueByTag", "d_maglist"]) # 2;
		_self call [F(removeMagazine), [_magClass, _count]];
		_self set [Q(CurrentSelectedMagazine), _magClass];
		// -- Update UI
		_self call [F(render), [_dialogCOB]];
	}],
	[F(onClear), {
		params ["_dialogCOB"];
		DBG_ "(ABC.onClear) Invoked" EOL;
		_self call [F(clear), []];
		// -- Update UI
		_self call [F(render), [_dialogCOB]];
	}],
	[F(composeAndExport), {
		params [["_applyToPlayer", false, [false]]];
		DBG_ "(ABC.composeAndExport) Invoked. Params: %1", _this EOL;
		private _data = (_self get Q(CurrentMagPool)) toArray false;

		DBG_ "(ABC.composeAndExport) _data: %1", _data EOL;
		if (_applyToPlayer) then {
			DBG_ "(ABC.composeAndExport) Applying to player backpack" EOL;
			private _bp = backpackContainer player;
			{ _bp addMagazineCargo _x; } forEach _data;
		};

		private _str = _data joinString ", ";
		DBG_ "(ABC.composeAndExport) String : %1", _str EOL;

		forceUnicode 0;
		copyToClipboard (_str);
		forceUnicode -1;

		[["BEARER_COPIED", "BEARER_ADDED"] select _applyToPlayer] call dzn_fnc_gear_editMode_showNotif;
	}],

	// -- UI render functions
	[F(resetControls), {
		params ["_dialogCOB"];
		DBG_ "(ABC.resetControls) Invoked" EOL;
		_self set [Q(CurrentWeapons), []];
		_self set [Q(CurrentWeaponsMags), []];

		{
			private _btn = _dialogCOB call ["GetByTag", _x];
			_btn ctrlSetText "";
			_btn ctrlSetTooltip "";
			_btn ctrlSetBackgroundColor [0,0,0,1];
		} forEach ["btn_primary", "btn_launcher"];

		private _magazinesListCtrl = _dialogCOB call ["GetByTag", "d_maglist"];
		lbClear _magazinesListCtrl;
		_magazinesListCtrl lbSetCurSel -1;
		_magazinesListCtrl setVariable [Q(listValues), []];
	}],
	[F(render), {
		params ["_dialogCOB"];
		DBG_ "(ABC.render) Invoked" EOL;
		_self call [F(renderWeaponTypeButtons), [_dialogCOB]];
		_self call [F(renderMagazinesListDropdown), [_dialogCOB]];
		_self call [F(renderMagazinesInfoLabels), [_dialogCOB]];
	}],
	[F(renderWeaponTypeButtons), {
		params ["_dialogCOB"];
		DBG_ "(ABC.renderWeaponTypeButtons) Invoked" EOL;
		(_self get Q(CurrentWeapons)) params ["_primary", "_launcher"];
		(_self get Q(CurrentMode)) params ["_primarySelected", "_launcherSelected"];
		{
			_x params ["_tag", "_class", "_isSelected"];
			private _icon = "<t color='#333333' align='center' size='2.5'>N/A</t>";
			private _text = "No launcher";
			private _cfg = configFile >> "CfgWeapons" >> _class;
			if (!isNull _cfg) then {
				_icon = format [
					"<t align='center'><img size=3 image='%1' /></t>",
					getText(_cfg >> "picture")
				];
				_text = format [
					"%1\nclass: %2",
					getText(_cfg >> "displayName"),
					_class
				];
			};

			private _btn = _dialogCOB call ["GetByTag", _tag];
			_btn ctrlSetStructuredText parseText _icon;
			_btn ctrlSetTooltip _text;
			_btn ctrlSetBackgroundColor ([COLOR_BLACK, COLOR_PALE_GREEN] select _isSelected);
		} forEach [
			["btn_primary", _primary, _primarySelected],
			["btn_launcher", _launcher, _launcherSelected]
		];
	}],
	[F(renderMagazinesListDropdown), {
		params ["_dialogCOB"];
		DBG_ "(ABC.renderMagazinesListDropdown) Invoked" EOL;
		(_self get Q(CurrentMode)) params ["_addPrimaryMags", "_addLauncherMags"];
		(_self get Q(CurrentWeapons)) params ["_primary", "_launcher"];
		(_self get Q(CurrentWeaponsMags)) params ["_primaryPreferredMag", "_launcherPreferredMag"];

		private _selectedMags = keys (_self get Q(CurrentMagPool));
		DBG_ "(ABC.renderMagazinesListDropdown) Prefered mags=%1", (_self get Q(CurrentWeaponsMags)) EOL;

		private _allMags = _selectedMags;
		if (_addPrimaryMags) then {
			private _primaryMags = (compatibleMagazines _primary) - [_primaryPreferredMag] - _selectedMags;
			if (_primaryPreferredMag isNotEqualTo "" && !(_primaryPreferredMag in _selectedMags)) then {
				_allMags pushBack _primaryPreferredMag;
			};
			_allMags append _primaryMags;
		};
		if (_addLauncherMags) then {
			private _launcherMags = (compatibleMagazines _launcher) - [_launcherPreferredMag] - _selectedMags;;
			if (_launcherPreferredMag isNotEqualTo "" && !(_launcherPreferredMag in _selectedMags)) then {
				_allMags pushBack _launcherPreferredMag;
			};
			_allMags append _launcherMags;
		};

		DBG_ "(ABC.renderMagazinesListDropdown) _allMags=%1", _allMags EOL;

		private _currentSelectedMags = _self get Q(CurrentMagPool);
		private _ctrl = _dialogCOB call ["GetByTag", "d_maglist"];

		private _currentSelectedItem = _self get Q(CurrentSelectedMagazine);
		/*if (lbCurSel _ctrl > -1 && (_ctrl getVariable Q(listValues)) isNotEqualTo []) then {
			_currentSelectedItem = (_ctrl getVariable Q(listValues)) select (lbCurSel _ctrl);
		};
		*/
		DBG_ "(ABC.renderMagazinesListDropdown) _currentSelectedItem: %1", _currentSelectedItem EOL;
		lbClear _ctrl;
		{
			private _count = _currentSelectedMags getOrDefault [_x, 0];
			DBG_ "(ABC.renderMagazinesListDropdown) _x: %1, _count: %2", _x, _count EOL;

			_ctrl lbAdd format [
				"%1%2",
				getText(configFile >> "CfgMagazines" >> _x >> "displayName"),
				[format [" x%1", _count], ""] select (_count == 0)
			];
			_ctrl lbSetTooltip [_forEachIndex, _x];
			_ctrl lbSetPicture [
				_forEachIndex,
				getText(configFile >> "CfgMagazines" >> _x >> "picture")
			];
			_ctrl lbSetColor [
				_forEachIndex,
				[
					COLOR_DARK_GREEN,
					[
						COLOR_WHITE, COLOR_GOLD
					] select (_x in (_self get Q(CurrentWeaponsMags)))
				] select (_count == 0)
			];
			if (_x isEqualTo _currentSelectedItem) then {

				DBG_ "(ABC.renderMagazinesListDropdown) %3) _x vs _currentSelectedItem = %1 vs %2", _x, _currentSelectedItem, _forEachIndex EOL;
				_ctrl lbSetCurSel _forEachIndex;
			};
		} forEach _allMags;

		// Update data for dialogCOB
		_ctrl setVariable [Q(listValues), _allMags];
	}],
	[F(renderMagazinesInfoLabels), {
		params ["_dialogCOB"];
		DBG_ "(ABC.renderMagazinesInfoLabels) Invoked" EOL;

		private _totalMass = 0;
		private _totalCount = 0;
		private _lines = [];
		{
			_totalCount = _totalCount + _y;
			_totalMass = _totalMass + _y * getNumber(configFile >> "CfgMagazines" >> _x >> "mass");

			_lines pushBack format [
				"<t color='%4'>x%3</t> <img image='%1' /img><t color='%4'>%2</t>",
				getText(configFile >> "CfgMagazines" >> _x >> "picture"),
				getText(configFile >> "CfgMagazines" >> _x >> "displayName"),
				_y,
				["", COLOR_HEX_GOLD] select (_x in (_self get Q(CurrentWeaponsMags)))
			];
		} forEach (_self get Q(CurrentMagPool));

		(_dialogCOB call ["GetByTag", "lbl_magTotalCount"]) ctrlSetText format [
			"Total magazines count: %1 (%2 kg)",
			_totalCount,
			[_totalMass * 0.1 * 0.453592, 2] call BIS_fnc_cutDecimals
		];
		(_dialogCOB call ["GetByTag", "lbl_magInfo"]) ctrlSetStructuredText parseText (_lines joinString "<br />");
	}],

	// --
	[F(loadKitData), {
		// Loads data from kit (if given and exists) or from current loadout (if kitname is empty). Does nothing if kitname not exists.
		params ["_kitname"];
		DBG_ "(ABC.loadKitData) Invoked. Params: %1", _this EOL;

		private _weapons = [primaryWeapon player, secondaryWeapon player];
		private _magazines = ["", ""];

		private _primaryMagArr = primaryWeaponMagazine player;
		if (_primaryMagArr isNotEqualTo []) then {
			_magazines set [0, _primaryMagArr # 0];
		};

		private _secondaryMagArr = secondaryWeaponMagazine player;
		if (_secondaryMagArr isNotEqualTo []) then {
			_magazines set [1, _secondaryMagArr # 0];
		};

		if (_kitname != "") then {
			private _kit = missionNamespace getVariable [_kitname, []];
			if (_kit isEqualTo []) exitWith {};
			DBG_ "(ABC.loadKitData) Using Kit weapons" EOL;

			// -- Weapon/magazine may be a randomized array, so pick first item
			_weapons = [_kit # 1 # 1, _kit # 2 # 1] apply {
				if (_x isEqualType []) then {
					_x # 0
				} else {
					_x
				}
			};
			_magazines = [_kit # 1 # 2, _kit # 2 # 2] apply {
				if (_x isEqualType []) then {
					_x # 0
				} else {
					_x
				}
			};
		};

		_self set [Q(CurrentWeapons), _weapons];
		_self set [Q(CurrentWeaponsMags), _magazines];
	}],
	[F(clear), {
		params [];
		DBG_ "(ABC.clear) Invoked. Params: %1", _this EOL;
		_self set [Q(CurrentMagPool), createHashMap];
		_self set [Q(TotalMagCount), 0];
	}],
	[F(addMagazine), {
		DBG_ "(ABC.addMagazine) Invoked. Params: %1", _this EOL;
		params ["_magClass", "_count"];
		private _pool = _self get Q(CurrentMagPool);
		_pool set [_magClass, _count + (_pool getOrDefault [_magClass, 0])];

		_self set [Q(TotalMagCount), (_self get Q(TotalMagCount)) + _count];
	}],
	[F(removeMagazine), {
		DBG_ "(ABC.removeMagazine) Invoked. Params: %1", _this EOL;
		params ["_magClass", "_count"];
		private _pool = _self get Q(CurrentMagPool);
		private _currentCount = (_pool getOrDefault [_magClass, 0]) - _count;
		if (_currentCount < 1) exitWith {
			_pool deleteAt _magClass;
		};
		_pool set [_magClass, _currentCount];
		_self set [Q(TotalMagCount), (_self get Q(TotalMagCount)) - _count];
	}]
]];


dzn_fnc_gear_editMode_initialize = {
	waitUntil { !(isNull (findDisplay 46)) };
	(findDisplay 46) displayAddEventHandler ["KeyDown", "_handled = _this call dzn_fnc_gear_editMode_onKeyPress"];

	dzn_gear_editMode_keyIsDown = false;
	#define SET_GEAR_IF_EMPTY(ACT)	if (ACT player == "") then { [] } else { [ACT player] };
	dzn_gear_editMode_primaryWeaponList = SET_GEAR_IF_EMPTY(primaryWeapon);
	dzn_gear_editMode_primaryWeaponMagList = primaryWeaponMagazine player;
	dzn_gear_editMode_handgunWeaponList  = SET_GEAR_IF_EMPTY(handgunWeapon);
	dzn_gear_editMode_handgunWeaponMagList = handgunMagazine player;
	dzn_gear_editMode_secondaryWeaponList  = SET_GEAR_IF_EMPTY(secondaryWeapon);
	dzn_gear_editMode_secondaryWeaponMagList = secondaryWeaponMagazine player;

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

	dzn_gear_editMode_ammoBearerCurrentMags = createHashMap; // [MagName 2 Count map]
	// dzn_gear_editMode_ammoBearerItemsKits = [];

	dzn_gear_editMode_controlsOverArsenalEH = -1;
	dzn_gear_editMode_notif_pos = [.9,0,.4,1];
	dzn_gear_editMode_lastInventory = [];

	bis_fnc_arsenal_fullArsenal = true;
	//["Preload"] call BIS_fnc_arsenal;

	hint parseText format["<t size='2' color='#FFD000' shadow='1'>dzn_gear</t>
		<br /><br /><t size='1.35' color='#3793F0' underline='true'>EDIT MODE</t>
		<br /><t %1>This is an Edit mode where you can create gear kits for dzn_gear.</t>
		<br /><br /><t size='1.35' color='#3793F0' underline='true'>WORKFLOW</t>
		<br /><t %1>Use <t color='#3793F0'>[SPACE]</t> to access Arsenal and choose your gear. Then copy it via <t color='#3793F0'>[CTRL + SPACE]</t> and paste to dzn_gear_kits.sqf file.</t>
		<br /><br /><t size='1.25' color='#3793F0' underline='true'>KEYBINDING</t>
		<br /><t %1>Use <t color='#3793F0'>[F1]</t> button to see all keybinds.</t>
		"
		, "align='left' size='0.9'"
	];

	if (!dzn_gear_ShowGearTotals || isNil "dzn_fnc_ShowMessage") exitWith {};
	waitUntil { time > 0 };
	nil call dzn_fnc_ShowMessage;

	if (dzn_gear_UseACEArsenalOnEdit) exitWith {
		dzn_gear_arsenalEventHandlerID = addMissionEventHandler ["EachFrame", {
			if !(isNil "ace_arsenal_currentAction") then {
				// ACE arsenal opened
				if (dzn_gear_editMode_canCheck_ArsenalDiff) then {
					dzn_gear_editMode_canCheck_ArsenalDiff = false;
					[] spawn dzn_gear_editMode_waitToCheck_ArsenalDiff;
					[] spawn dzn_fnc_gear_editMode_showGearTotals;
				};

				if (dzn_gear_editMode_controlsOverArsenalEH < 0) then {
					with uiNamespace do {
						private _handlerId = (findDisplay 1127001) displayAddEventHandler [
							"KeyDown", "_handled = _this call dzn_fnc_gear_editMode_onKeyPress"
						];

						missionNamespace setVariable ["dzn_gear_editMode_controlsOverArsenalEH", _handlerId];
					};
				};
			} else {
				// ACE arsenal closed
			};
		}];
	};

	waitUntil { isNull ( uinamespace getvariable "RSCDisplayArsenal") };

	dzn_gear_arsenalEventHandlerID = addMissionEventHandler ["EachFrame", {
		if !(isNull ( uinamespace getvariable "RSCDisplayArsenal")) then {
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
	}];
};

[] spawn dzn_fnc_gear_editMode_initialize;