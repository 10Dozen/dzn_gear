// Init of dzn_gear
private["_editMode","_isServerSide"];

// **************************
// EDIT MODE
// **************************
_editMode = _this select 0;
_isServerSide = _this select 1;

if (_editMode) then {
	// FUNCTIONS
	
	dzn_fnc_gear_editMode_getGear = {
		/*
			_units call dzn_fnc_gear_editMode_getGear
			0:	OBJ	Unit to take gear from
			
			OUTPUT: kitArray
		*/
		private[
			"_unit","_item1","_item2","_item3","_item4","_item5","_item6","_items",
			"_pwMags","_swMags","_hgMags","_mag1","_mag2","_mag3","_mag4","_mag5","_mag6",
			"_mags","_magSlot","_pwMag","_swMag","_hgMag",
			"_duplicates","_item","_count","_outputKit"
		];
			
		_unit = _this;
		
		// Нужно получить все айтемы и собрать их в стеки
		_item1 = ["", 0];
		_item2 = ["", 0];
		_item3 = ["", 0];
		_item4 = ["", 0];
		_item5 = ["", 0];
		_item6 = ["", 0];
		
		_items = items _unit;
		_duplicates = [];
		{
			if !(_x in _duplicates) then {
				_item = _x;
				_count = 0;
	
				_duplicates = _duplicates + [_item];
				{
					if (_x == _item) then {
						_count = _count + 1;
					};
				} forEach _items;
				
				if !(count _duplicates > 6) then {
					call compile format [
						"_item%1 = ['%2', %3];",
						count _duplicates,
						_item,
						_count
					];
				} else {
					hint "Maximum of 6 item slots were exceeded";
				};	
			};
		} forEach _items;
		
		// Нужно получить все магазины и собрать их в стеки
		_pwMags = ["", 0];
		_swMags = ["", 0];
		_hgMags = ["", 0];
		_mag1 = ["", 0];
		_mag2 = ["", 0];
		_mag3 = ["", 0];
		_mag4 = ["", 0];
		_mag5 = ["", 0];
		_mag6 = ["", 0];
		
		_mags = magazines _unit;
		_duplicates = [];
		
		_pwMag = if (count (primaryWeaponMagazine _unit) > 0) then {primaryWeaponMagazine _unit  select 0} else { "" };
		_swMag = if (count (secondaryWeaponMagazine _unit) > 0) then {secondaryWeaponMagazine _unit  select 0} else { "" };
		_hgMag = if (count (handgunMagazine _unit) > 0) then {handgunMagazine _unit  select 0} else { "" };
		_magSlot = 1;
		{
			if !(_x in _duplicates) then {
				_item = _x;
				_count = 0;				
				_duplicates = _duplicates + [_item];
				{	
					if (_x == _item) then {
						_count = _count + 1;
					};
				} forEach _mags;
					
				switch (_item) do {
					case _pwMag: {
						_pwMags = [_item, _count + 1];
					};
					case _swMag: {
						_swMags = [_item, _count + 1];
					};
					case _hgMag: {
						_hgMags = [_item, _count + 1];
					};
					default {
						call compile format [
							"_mag%1 = ['%2', %3];",
							_magSlot,
							_item,
							_count
						];
						_magSlot = _magSlot + 1;
					};
				};
			};
		} forEach _mags;
			
		#define hasPrimaryThen(PW)		if (primaryWeapon _unit != "") then {PW} else {""}
		#define hasSecondaryThen(SW)	if (secondaryWeapon _unit != "") then {SW} else {""}
		#define hasHandgunThen(HW)		if (handgunWeapon _unit != "") then {HW} else {""}
		_outputKit = [
			/* Equipment */
			[
				uniform _unit,
				vest _unit,
				backpack _unit,
				headgear _unit,
				goggles _unit
			],
			/* Primary Weapon */
			[
				hasPrimaryThen(primaryWeapon _unit),
				hasPrimaryThen((primaryWeaponItems _unit) select 2),
				hasPrimaryThen((primaryWeaponItems _unit) select 0),
				hasPrimaryThen((primaryWeaponItems _unit) select 1)					
			],
			/* Secondary Weapon */
			[
				hasSecondaryThen(secondaryWeapon _unit)
			],
			/* Handgun Weapon */
			[
				hasHandgunThen(handgunWeapon _unit),
				hasHandgunThen((handgunItems _unit) select 2),
				hasHandgunThen((handgunItems _unit) select 0),
				hasHandgunThen((handgunItems _unit) select 1)
			],
			/* Personal Items */
			assignedItems _unit,
			/* Magazines */
			[
				_pwMags,
				_swMags,
				_hgMags,
				_mag1,
				_mag2,
				_mag3,
				_mag4,
				_mag5,
				_mag6
			],
			/* Items */
			[
				_item1,
				_item2,
				_item3,
				_item4,
				_item5,
				_item6
			],
			/* Person and Insignia */
			/*["Insignia","Face","Voice"]*/
			[]
		];
		
		_outputKit
	};
	
	dzn_fnc_gear_editMode_getBoxGear = {
		/*
			BOX call dzn_fnc_gear_editMode_getBoxGear;
			Return kit of given box
			0: 	OBJ	Box or vehicle
			
			OUTPUT:	kitArray
		*/
		private ["_outputKit", "_classnames", "_count", "_cargo", "_categoryKit"];
		
		_outputKit = [];
		_cargo = [getWeaponCargo _this, getMagazineCargo _this, getItemCargo _this, getBackpackCargo _this];
		{
			_classnames = _x select 0;
			_count = _x select 1;
			_categoryKit = [];
			{
				_categoryKit = _categoryKit + [ [_x, (_count select _forEachIndex)] ];
			} forEach _classnames;		
			
			_outputKit = _outputKit + [_categoryKit];
		} forEach _cargo;
		
		_outputKit
	};
	
	dzn_fnc_gear_editMode_copyToClipboard = {
		/*
			call dzn_fnc_gear_editMode_getGear
			
			OUTPUT: colorString
		*/
		private ["_colorString"];
		
		// Copying to clipboard
		copyToClipboard ("_kitName = " + str(_this) + ";");
	
		// Hint here or title
		#define GetColors ["F","C","B","3","6","9"] call BIS_fnc_selectRandom
		_colorString = format [
			"#%1%2%3%4%5%6", 
			GetColors, GetColors, GetColors, GetColors, GetColors, GetColors
		];
		
		hintSilent parseText format[      
			"<t size='1.25' color='%1'>Gear has been copied to clipboard</t>",     
			_colorString
		];
		
		_colorString
	};
	
	dzn_fnc_gear_editMode_createKit = {
		/*
			call dzn_fnc_gear_editMode_createKit
			0:	OBJ		Source of gear
			1:	BOOLEAN		Is box kit?
			
			OUTPUT: no (take gear from unit, add action with kit, copy kit to clipboard)
		*/
		
		private ["_outputKit","_colorString"];
		
		_outputKit = if (_this select 1) then {
			(_this select 0) call dzn_fnc_gear_editMode_getBoxGear;
		} else {
			(_this select 0) call dzn_fnc_gear_editMode_getGear;
		};
		_colorString = _outputKit call dzn_fnc_gear_editMode_copyToClipboard;
		
		if !(_this select 1) then {
			player addAction [
				format [
					"<t color='%1'>Kit with %2 %3</t>",
					_colorString,
					round(time),
					_outputKit select 1 select 0
				],
				{
					[(_this select 1), _this select 3] call dzn_fnc_gear_assignGear;
					(_this select 3) call dzn_fnc_gear_editMode_copyToClipboard;
				},
				_outputKit,0
			];
		} else {
			player addAction [
				format [
					"<t color='%1'>Kit for Vehicle/Box %2</t>",
					_colorString,
					round(time)
				],
				{
					[cursorTarget, _this select 3] call dzn_fnc_gear_assignBoxGear;
					(_this select 3) call dzn_fnc_gear_editMode_copyToClipboard;
				},
				_outputKit,
				0,true,true,"",
				"(cursorTarget in vehicles)"
			];
		};
	};
	
	// ACTIONS
	
	// Add virtual arsenal action
	player addAction [
		"<t color='#00B2EE'>Open Virtual Arsenal</t>",
		{['Open',true] spawn BIS_fnc_arsenal;}
	];
  
	// Copy to clipboard set of unit's gear in format according to
	// https://github.com/10Dozen/ArmaDesk/blob/master/A3-Gear-Set-Up/Kit%20Examples.sqf
	player addAction [
		"<t color='#8AD2FF'>Copy Current Gear to Clipboard</t>",
		{[(_this select 1), false] call dzn_fnc_gear_editMode_createKit;}
	];
	
	// Copy gear of cursorTarget
	player addAction [
		"<t color='#1DBDF2'>Copy and Assign Gear of Cursor </t><t color='#F2A81D'>Unit</t>",
		{
			private["_kit"];
			_kit = cursorTarget call dzn_fnc_gear_editMode_getGear;
			[(_this select 1), _kit ] call dzn_fnc_gear_assignGear;
			_kit call dzn_fnc_gear_editMode_copyToClipboard;
		},
		"",0,true,true,"",
		"(cursorTarget isKindOf 'CAManBase')"
	];
	
	// Copy gear of cursorTarget == vehicle
	player addAction [
		"<t color='#1DBDF2'>Copy Gear of Cursor </t><t color='#F2A81D'>Vehicle or Box</t>",
		{[cursorTarget, true] spawn dzn_fnc_gear_editMode_createKit;},
		"",0,true,true,"",
		"(cursorTarget in vehicles)"
	];
};




// **************************
// FUNCTIONS
// **************************

if (_isServerSide) then {
	if !(isServer) exitWith {};
};
waitUntil { !isNil "BIS_fnc_selectRandom" };

dzn_fnc_gear_assignKit = {
	/*
		[ unit, gearSetName, isBox ] spawn dzn_gearSetup;
		0:	OBJ			Unit for which gear will be set
		1:	ARRAY or STRING		List of Kits for assignment
		2:	BOOLEAN			Is given unit a box?
		
		Function will change gear of chosen unit with chosen gear set.	
	*/
	private ["_kit","_randomKit"];
	(_this select 0) setVariable ["dzn_gear_assigned", _this select 1];
	
	_kit = [];
	if (!isNil {call compile (_this select 1)}) then {
		_kit = call compile (_this select 1);
		
		if (typename (_kit select 0) != "ARRAY") then {
			_randomKit =  (_kit call BIS_fnc_selectRandom);
			(_this select 0) setVariable ["dzn_gear_assigned", _randomKit];
			_kit = call compile _randomKit;
		};		
		
		if ( !isNil {_this select 2} && { _this select 2 } ) then {
			// Box
			[_this select 0, _kit] call dzn_fnc_gear_assignBoxGear;
		} else {
			// Man
			[_this select 0, _kit] call dzn_fnc_gear_assignGear;
		};
	} else {
		diag_log format ["There is no kit with name %1", (_this select 1)];
		player sideChat format ["There is no kit with name %1", (_this select 1)];
	};
};

dzn_fnc_gear_assignGear = {
	/*
		[ unit, gearSetName ] spawn dzn_gearSetup;
		0:	OBJ		Unit for which gear will be set
		1:	ARRAY	Set of gear
		
		Function will change gear of chosen unit with chosen gear set.	
	*/
	private ["_unit","_kit","_category","_i"];
	
	_unit = _this select 0;
	_kit = _this select 1;
		
	// Clear Gear
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;
	{
		_unit unassignItem _x;
		_unit removeItem _x;
	} forEach ["NVGoggles", "NVGoggles_OPFOR", "NVGoggles_INDEP", "ItemRadio", "ItemGPS", "ItemMap", "ItemCompass", "ItemWatch"];
	removeAllWeapons _unit;
	
	waitUntil { (items _unit) isEqualTo [] };
	
	// Adding gear
	#define cItem(INDEX)		(_category select INDEX)
	#define isItem(INDEX)		(typename cItem(INDEX) == "STRING")
	#define NotEmpty(INDEX)		(cItem(INDEX) != "")
	#define getRandom(INDEX)	(cItem(INDEX) call BIS_fnc_selectRandom)
	#define assignGear(IDX, ACT)	if isItem(IDX) then { if NotEmpty(IDX) then { _unit ACT cItem(IDX); }; } else { _unit ACT getRandom(IDX); };
	
	// Adding UVBHG
	_category = _kit select 0;
	assignGear(0, forceAddUniform)
	assignGear(1, addVest)
	assignGear(2, addBackpack)
	assignGear(3, addHeadgear)
	assignGear(4, addGoggles)

	#define assignWeapon(IDX,WT)	if isItem(IDX) then { if NotEmpty(IDX) then { _unit addWeapon cItem(IDX); }; } else { _unit addWeapon (cItem(IDX) select WT); };
	#define getRandomType(IDX)		if isItem(IDX) then { 0 } else { round(random(count cItem(IDX) - 1)) }
	#define assignMags(IDX, WT)		if (typename (cItem(IDX) select 0) == "STRING") then { _unit addMagazines cItem(IDX); } else { _unit addMagazines (cItem(IDX) select WT); };
	
	// Add Primary, Secondary and Handgun Magazines
	_category = _kit select 5;
	
	_primaryRandom = getRandomType(0);
	_secondaryRandom = getRandomType(1);
	_handgunRandom = getRandomType(2);	
	
	{
		assignMags(_forEachIndex, _x)
	} forEach [_primaryRandom, _secondaryRandom, _handgunRandom];
	
	// for "_i" from 0 to 2 do {
		// assignMags(_i, WT)
		// if !(cItem(_i) select 0 == "") then {_unit addMagazines cItem(_i);};
	// };
	
	// Add Primary Weapon and accessories
	_category = _kit select 1;
	assignWeapon(0,_primaryRandom)
	//assignGear(0, addWeapon);
	for "_i" from 1 to count(_category) do {
		assignGear(_i, addPrimaryWeaponItem);
	};
	
	// Add Secondary Weapon
	_category = _kit select 2;
	assignWeapon(0,_secondaryRandom)
	//assignGear(0, addWeapon);
	
	// Add Handgun and accessories
	_category = _kit select 3;
	assignWeapon(0,_handgunRandom)
	//assignGear(0, addWeapon);
	for "_i" from 1 to count(_category) do {
		assignGear(_i, addHandgunItem);
	};
	
	// Add items
	_category = _kit select 4;
	for "_i" from 0 to count(_category) do {
		assignGear(_i, addWeapon);
	};
	
	// Add Magazines and Grenades
	_category = _kit select 5;
	for "_i" from 3 to count(_category) do {
		if !(cItem(_i) select 0 == "") then {_unit addMagazines cItem(_i);};
	};
	
	// Add additional Items
	_category = _kit select 6;
	for "_i" from 0 to count(_category) do {
		if !(cItem(_i) select 0 == "") then {
			for "_j" from 0 to (cItem(_i) select 1) do {
				_unit addItem (cItem(_i) select 0);
			};
		};		
	};
};

dzn_fnc_gear_assignBoxGear = {
	/*
		[ unit, gearSetName ] spawn dzn_gearSetup;
		0:	OBJ	Unit for which gear will be set
		1:	ARRAY	Set of gear
		
		Function will change gear of chosen unit with chosen gear set.	
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
	
	// Magazines
	_category = (_this select 1) select 1;
	{_box addMagazineCargoGlobal _x;} forEach _category;
	
	// Items
	_category = (_this select 1) select 2;
	{_box addItemCargoGlobal _x;} forEach _category;
	
	// Backpacks
	_category = (_this select 1) select 3;
	{_box addBackpackCargoGlobal _x;} forEach _category;
};

// **************************
// GEARS
// **************************

#include "dzn_gear_kits.sqf"


// **************************
// INITIALIZATION
// **************************
waitUntil { time > 0 };
if !(isServer) exitWith {};
private ["_logics", "_kitName", "_synUnits","_units","_crew"];

// Logics
_logics = entities "Logic";
if !(_logics isEqualTo []) then {	
	{
		#define checkIsGearLogic(PAR)	([PAR, str(_x), false] call BIS_fnc_inString || !isNil {_x getVariable PAR})
		#define	getKitName(PAR,IDX)	if (!isNil {_x getVariable PAR}) then {_x getVariable PAR} else {str(_x) select [IDX]};
		
		if checkIsGearLogic("dzn_gear_box") then {
			_synUnits = synchronizedObjects _x;
			_kitName = getKitName("dzn_gear_box",13)
			{
				if (!(_x isKindOf "CAManBase") || {vehicle (crew _x select 0) != _x}) then {
					_veh = if ((crew _x) isEqualTo []) then {
						_x
					} else {
						vehicle (crew _x select 0)
					};
					[_veh, _kitName, true] spawn dzn_fnc_gear_assignKit;
					sleep 0.1;
				};
			} forEach _synUnits;
			deleteVehicle _x;
		} else {
			if checkIsGearLogic("dzn_gear") then {
				_synUnits = synchronizedObjects _x;
				_kitName = getKitName("dzn_gear",9)
				{
					if (_x  isKindOf "CAManBase") then {
						[_x, _kitName] spawn dzn_fnc_gear_assignKit;
					} else {
						private ["_crew"];
						_crew = crew _x;
						if !(_crew isEqualTo []) then {
							{
								[_x, _kitName] spawn dzn_fnc_gear_assignKit;
								sleep 0.1;
							} forEach _crew;
						};
					};
					sleep 0.2;
				} forEach _synUnits;
				deleteVehicle _x;
			};
		};
	} forEach _logics;
};

// Units
_units = allUnits;
{
	if (!isNil {_x getVariable "dzn_gear"}) then {
		_kitName = _x getVariable "dzn_gear";
		if (_x isKindOf "CAManBase" && isNil {_x getVariable "dzn_gear_done"}) then {
			[_x, _kitName] spawn dzn_fnc_gear_assignKit;
		} else {
			_crew = crew _x;
			if !(_crew isEqualTo []) then {
				{
					if (isNil {_x getVariable "dzn_gear_done"}) then {
						[_x, _kitName] spawn dzn_fnc_gear_assignKit;
					};
					sleep 0.1;
				} forEach _crew;
			};
		};
	} else {
		if (!isNil {_x getVariable "dzn_gear_box"}) then {
			if !(_x isKindOf "CAManBase") then {
				[_x, _x getVariable "dzn_gear_box", true] spawn dzn_fnc_gear_assignKit;
			};
		};
	};
	sleep 0.2;
} forEach _units;
