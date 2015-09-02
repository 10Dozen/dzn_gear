// **************************
// FUNCTIONS
// **************************


dzn_fnc_gear_getGear = {
	// @Kit = @Unit call dzn_fnc_gear_getGear
	// Return:	Kit, Formatted Kit in clipboard
	private["_g","_kit","_str","_formatedString","_lastId","_i"];

	#define NG			_g = []
	#define AddGear(ACT)	_g pushBack (ACT)
	#define AddToKit		_kit pushBack _g
	#define WeaponMag(X)	if ((X) isEqualTo []) then { "" } else { X select 0 }
	_kit = [];
	
	NG;
	{AddGear(_x);} forEach [
		"<EQUIPEMENT >>  "
		,uniform _this
		,vest _this
		,backpack _this
		,headgear _this
		,goggles _this
	];	
	AddToKit;
	
	// Primary
	NG;
	_priMag = WeaponMag(primaryWeaponMagazine _this);
	{AddGear(_x);} forEach [
		"<PRIMARY WEAPON >>  "
		,primaryWeapon _this
		,_priMag
		,primaryWeaponItems  _this
	];
	AddToKit;

	// Secondary
	NG;
	_secMag = WeaponMag(secondaryWeaponMagazine _this);
	{AddGear(_x)} forEach [
		"<LAUNCHER WEAPON >>  "
		,secondaryWeapon _this
		,_secMag
		,secondaryWeaponItems _this
	];
	AddToKit;
	
	// Handgun
	NG;
	_handMag = WeaponMag(handgunMagazine _this);
	{AddGear(_x)} forEach [
		"<HANDGUN WEAPON >>  "
		,handgunWeapon _this
		,_handMag
		,handgunItems _this
	];
	AddToKit;
	
	// Assigned Items
	_g = ["<ASSIGNED ITEMS >>  "] + assignedItems _this;
	AddToKit;
	
	// Equiped Items and magazines
	{
		NG;
		_items = _x call BIS_fnc_consolidateArray;
		{
			switch (_x select 0) do {
				case _priMag: 	{ _x set [0, "PRIMARY MAG"] };
				case _secMag: 	{ _x set [0, "SECONDARY MAG"] };
				case _handMag: 	{ _x set [0, "HANDGUN MAG"] };		
			};		
		} forEach _items;
		
		{ AddGear(_x) } forEach [
			switch (_forEachIndex) do {
				case 0: {"<UNIFORM ITEMS >> "};
				case 1: {"<VEST ITEMS >> "};
				case 2: {"<BACKPACK ITEMS >> "};
			}			
			,_items
		];
		
		AddToKit;	
	} forEach [
		uniformItems _this
		,vestItems _this
		,backpackItems _this	
	];
	
	
	if (dzn_gear_editModeEnabled) then {
		// Format of output
		_str = str(_kit);
		_formatedString = "kit_NewKitName =";
		_lastId = 0;	
		for "_i" from 0 to ((count _str) - 1) do {
			if (_str select [_i,3] == "[""<") then {		
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
		
		copyToClipboard _formatedString;
	};
	_kit
};

dzn_fnc_gear_getCargoGear = {
	/*
		Return structured array of gear (kit) of given box/vehicle
		EXAMPLE: BOX call dzn_fnc_gear_getCargoGear;
		INPUT:
			0: OBJECT	- Box or vehicle
		OUTPUT:	ARRAY (kitArray), Copied to clipboard kit
	*/	
	private ["_kit", "_classnames", "_count", "_cargo", "_categoryKit","_str","_formatedString","_lastId","_i"];
	
	_kit = [];
	_cargo = [getWeaponCargo _this, getMagazineCargo _this, getItemCargo _this, getBackpackCargo _this];
	{
		_classnames = _x select 0;
		_count = _x select 1;
		_categoryKit = [];
		{
			_categoryKit = _categoryKit + [ [_x, (_count select _forEachIndex)] ];
		} forEach _classnames;		
		
		_kit pushBack _categoryKit;
	} forEach _cargo;
	
	if (dzn_gear_editModeEnabled) then {
		// Format of output
		_str = str(_kit);
		_formatedString = ""; 
		_lastId = 0;
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
		_formatedString = format ["kit_NewCargoKitName = %1", [_formatedString,4] call BIS_fnc_trimString];
		copyToClipboard _formatedString;
	};
	_kit
};

dzn_fnc_gear_assignGear = {
	// [@Unit, @GearArray] spawn dzn_fnc_gear_assignGear;
	private["_ctg","_unit","_gear","_magClasses","_r","_act","_item"];
	_unit = _this select 0;
	_gear = _this select 1;	
	_ctg = [];
	_unit setVariable ["BIS_enableRandomization", false];
	
	// Clear Gear
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;
	removeAllAssignedItems _unit;
	removeAllWeapons _unit;
	waitUntil { (items _unit) isEqualTo [] };
	
	
	#define SET_CAT(CIDX)				_ctg = _gear select CIDX
	#define cItem(IDX)				(_ctg select IDX)
	#define IsItem(ITEM)				(typename (ITEM) == "STRING")
	#define getItem(ITEM)				if IsItem(ITEM) then {ITEM} else {ITEM call BIS_fnc_selectRandom}
	
	// ADD WEAPONS
	// Backpack to add first mag for all weapons
	_unit addBackpack dzn_gear_defaultBackpack;
	_magClasses = [];
	
	for "_i" from 1 to 3 do {
		SET_CAT(_i);		
		_r = if IsItem(cItem(1)) then { -1 } else { round(random((count cItem(1) - 1))) };
		
		if (_r == -1) then { 
			_unit addMagazine cItem(2);
			_unit addWeaponGlobal cItem(1);
			_magClasses pushBack cItem(2);
		} else {			
			_unit addMagazine (cItem(2) select _r);
			_unit addWeaponGlobal (cItem(1) select _r);
			_magClasses pushBack (cItem(2) select _r);
		};
		
		{
			call compile format [
				"_unit %1 '%2';"
				, switch (_i) do {
					case 1: { "addPrimaryWeaponItem" };
					case 2: { "addSecondaryWeaponItem" };
					case 3: { "addHandgunItem" };
				}
				, getItem(_x)
			];
		} forEach cItem(3);
	};	
	removeBackpack _unit;
	
	// ADD EQUP
	SET_CAT(0);
	{
		//B_Kitbag_cbr
		player sideChat str(cItem(_forEachIndex + 1));
		call compile format [
			"_unit %1 '%2'"
			, _x
			, getItem(cItem(_forEachIndex + 1))
		];
	} forEach ["forceAddUniform","addVest","addBackpackGlobal","addHeadgear","addGoggles"];
		
	// ADD ASSIGNED ITEMS
	SET_CAT(4);
	for "_i" from 1 to ((count _ctg) - 1) do {
		_unit addWeapon (if IsItem(cItem(_i)) then {cItem(_i)} else {cItem(_i) call BIS_fnc_selectRandom});	
	};
	
	// ADD GEAR
	{		
		SET_CAT(_forEachIndex + 5);
		_act = _x;
		{
			// ["Aid", 2]
			_item = "";
			if ((_x select 0) in ["PRIMARY MAG","SECONDARY MAG","HANDGUN MAG"]) then {
				_item = switch (_x select 0) do {
					case "PRIMARY MAG": { _magClasses select 0 };
					case "SECONDARY MAG": { _magClasses select 1 };
					case "HANDGUN MAG": { _magClasses select 2 };
				};				
			} else {			
				_item = getItem(_x select 0);
			};			
			
			call compile format [
				"for '_j' from 1 to (_x select 1) do { _unit %1 '%2'; }"
				, _act
				, _item
			];			
		} forEach cItem(1);
	} forEach ["addItemToUniform","addItemToVest","addItemToBackpack"];	
};

dzn_fnc_gear_assignCargoGear = {
	/*
		Change gear of given box or vehicle with given gear set	
		EXAMPLE:	[ @Unit, @Gear set ] spawn dzn_fnc_gear_assignCargoGear;
		INPUT:
			0: OBJECT	- Vehicle or box for which gear will be set
			1: ARRAY	- Set of gear
		OUTPUT: NULL
	*/

	private["_box","_category"];
	_box = _this select 0;
	
	// Clear boxes
	clearWeaponCargoGlobal _box;
	clearMagazineCargoGlobal _box;
	clearBackpackCargoGlobal _box;
	clearItemCargoGlobal _box;
	
	// Add items to box
	// Weapons
	_category = (_this select 1) select 0;
	{_box addWeaponCargoGlobal _x;} forEach _category;
	
	// Add Magazines
	_category = (_this select 1) select 1;
	{_box addMagazineCargoGlobal _x;} forEach _category;
	
	// Add Items
	_category = (_this select 1) select 2;
	{_box addItemCargoGlobal _x;} forEach _category;
	
	// Add Backpacks
	_category = (_this select 1) select 3;
	{_box addBackpackCargoGlobal _x;} forEach _category;
	
	_box setVariable ["dzn_gear_done", true, true];
};

dzn_fnc_gear_assignKit = {
	/*
		Resolve given kit and call function to assign existing kit to unit.	
		EXAMPLE:	[ unit, gearSetName, isBox ] spawn dzn_gearSetup;
		INPUT:
			0: OBJECT		- Unit for which gear will be set
			1: ARRAY or STRING	- List of Kits for assignment
			2: BOOLEAN		- Is given unit a box?
		OUTPUT: NULL
	*/
	private ["_kit","_randomKit"];
	
	_kit = [];
	
	#define checkKitIsArray(PAR)	(typename (PAR) == "ARRAY")
	#define assignKitByType(KIT)	if ( !isNil {_this select 2} && { _this select 2 } ) then { [_this select 0, KIT] call dzn_fnc_gear_assignCargoGear; } else {	[_this select 0, KIT] call dzn_fnc_gear_assignGear;};
	#define checkIfKitExists(PAR)	(!isNil {call compile (PAR)})
	#define convertKitnameToAKit(PAR)	call compile (PAR)
	
	// Resolve kit by type	
	if (checkKitIsArray(_this select 1) && { checkKitIsArray((_this select 1) select 0) }) then {
		// Assign kitArray [ARRAY]
		assignKitByType(_this select 1)		
	} else {
		// Assign kit by kitname [STRING]
		if checkIfKitExists(_this select 1) then {
			_kit = convertKitnameToAKit(_this select 1);
			
			// Checks if given kit is array of kits (check first item of array - for kitArray it is array) 
			// selects a random kit name from given array
			if !checkKitIsArray(_kit select 0) then {
				_randomKit =  (_kit call BIS_fnc_selectRandom);
				(_this select 0) setVariable ["dzn_gear", _randomKit, true];
				
				// Convert from name(string) to kitArray(array)
				_kit = convertKitnameToAKit(_randomKit);	
			};
			
			assignKitByType(_kit)
		} else {
			// If given kit name wasn't resolved
			diag_log format ["There is no kit with name %1", (_this select 1)];
			player sideChat format ["There is no kit with name %1", (_this select 1)];
		};
	};
};



// **************************
// AEROSAN'S GET/SET LOADOUT
// **************************
aerosan_fnc_getLoadout = compile preprocessFileLineNumbers "dzn_gear\fn\aerosan\get_loadout.sqf";
aerosan_fnc_setLoadout = compile preprocessFileLineNumbers "dzn_gear\fn\aerosan\set_loadout.sqf";

dzn_fnc_gear_getPreciseGear = {
	// @SimpleGear = @Unit call dzn_gear_getSimpleGear
	[_this, ["ammo"]] call aerosan_fnc_getLoadout;
};

dzn_fnc_gear_setPreciseGear = {
	// [@Unit, @SimpleGear] call dzn_fnc_gear_setSimpleGear
	[_this select 0, _this select 1, ["ammo"]] call aerosan_fnc_setLoadout;
};