/* TODO:
	[ok] - Export kit in missionNamespace
	[ok] - highlight roles in list that already was used
	[ok] - Finish ammo bearier exporter page
		- Need to create component to track vars and stuff...
	[ok] - Page with all copied kits / composed elements to extract it again
	[ok]	- Cargo Kit history
	[ok]	- Ammo Bearer composed
	[ok]	- Cargo kit composed
	[  ]    - Handle Arsenal and add BUTTONS!
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

#define HISTORY_PERSONAL_KIT "PERSONAL_KIT"
#define HISTORY_CARGO_KIT "CARGO_KIT"
#define HISTORY_COMPOSED "COMPOSED"

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





// *****************************
//	Initialization
// *****************************


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
		dzn_gear_ArsenalComponent set [
			Q(ACEOpenedEH),
			["ace_arsenal_displayOpened", {
				params ["_display"];
				dzn_gear_ArsenalComponent call [F(OnACEArsenalOpened), [_display]];
			}] call CBA_fnc_addEventHandler
		];

		dzn_gear_ArsenalComponent set [
			Q(ACEClosedEH),
			["ace_arsenal_displayClosed", {
				dzn_gear_ArsenalComponent call [F(OnACEArsenalClosed), [_display]];
			}] call CBA_fnc_addEventHandler
		];


		/*
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
		*/
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