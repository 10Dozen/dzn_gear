// ******** Gear Notes Plug-in ************
// ****************************************************
//
// ******************** Settings **********************

dzn_gear_gnotes_showMyGear = true;
dzn_gear_gnotes_showSquadGear = true;

/*
	RIFLEMAN
	- AK-74 (PK-A, DTK-1)
	- RPG-26

	- 7x 5.45x39 7N10 30Rnd Magazine
	- 2x RGO-2
	- 1x NSP-1
	- 2x Bandages
	- 1x Earplugs

	- 1x Watch
	- 1x Radio SW
	- 1x Compass
	- 1x Map
	
	%1 - Role description
	%2 - Pri Wep if exist
	%3 - Sec Wep if exist
	%4 - Hand Gun if exist
	%5 - Backpack if exists
	%6 - Night Vission if exists
	%7 - Binocular if exists
	%8 - Inventory (magazines, medicine)
	%9 - Assigned Items (map, radio, compass)
*/
dzn_gear_gnotes_myGearTemplate = "<font size='18'>%1</font><br />--------------------%2%3%4%5<br /><font color='#9E9E9E'>%6<br />%7</font>";

/*
	1'1 Squad Leader (AK-74)
	Team Leader (AK-74 (PK-A))
	MachineGunner (PKM)
	Rifleman (AK-74M / RPG-7V (PV-1A))
	
	%1 - Role description
	%2 - Pri Wep if exist
	%3 - Sec Wep if exist
	%4 - Hand Gun if exist
*/
dzn_gear_gnotes_mySquadTemplate = "<br /><font size='12'>%1 <font color='#9E9E9E'>(%2%3%4)</font></font>";

#define ALL_SQUAD_GEARED_UP	private "_r"; _r = true; {if !(_x getVariable ["dzn_gear_done", false]) exitWith { _r = false };} forEach (units group player); _r
dzn_gear_gnotes_waitUntilGroupEvent = { ALL_SQUAD_GEARED_UP };
dzn_gear_gnotes_waitUntilMyEvent = { player getVariable ["dzn_gear_done", false] && !isNil {player getVariable "dzn_gear"} };


// ******************** Functions **********************
#define	DNAME(CLASS)	CLASS call dzn_fnc_getItemDisplayName

if (isNil "dzn_fnc_getItemDisplayName") then {
	dzn_fnc_getItemDisplayName = {	
		private["_name"];			
		_name = if (isText (configFile >> "cfgWeapons" >> _this >> "displayName")) then {
			getText(configFile >> "cfgWeapons" >> _this >> "displayName")
		} else {
			getText(configfile >> "CfgGlasses" >> _this >> "displayName")
		};	
			
		if (_name == "") then {
			_name = getText(configFile >>  "cfgMagazines" >> _this >> "displayName");
			if (_name == "") then {	_name = getText(configFile >> "cfgVehicles" >> _this >> "displayName");	};
		};

		_name
	};
};

dzn_fnc_gear_gnotes_getWeaponInfo = {
	/*
		type: "Primary", "Secondary", "Handgun"
		_mode: "personal", "squad"
	*/
	params["_kit","_type","_mode"];
	private["_id","_output","_attaches"];
	
	_id = switch (toLower(_type)) do {
		case "primary": { 1 };
		case "secondary": { 2 };
		case "handgun": { 3 };		
	};
	_output = "";
	
	if ( (_kit select _id select 1) != "" ) then {		
		if ( toLower(_mode) == "personal" ) then {
			_attaches = "";
			{
				if (_x != "") then {
					_attaches = if (_attaches == "") then { format ["%1", DNAME(_x)] } else { format["%1, %2", _attaches, DNAME(_x)] };					
				};				
			} forEach (_kit select _id select 3);
			_attaches = if (_attaches == "") then { "" } else { format["(%1)", _attaches] };
			
			_output = format ["<br />1x %1 %2", DNAME(_kit select _id select 1), _attaches];
		} else {
			_output = format [
				"%2%1"
				, DNAME(_kit select _id select 1)
				, if (_id == 1) then { "" } else { " / " }
			];
		};
	};

	_output
};

dzn_fnc_gear_gnotes_getAssignedItems = {	
	private["_kit","_items","_output"];	
	_kit = _this;
	// ["<ASSIGNED ITEMS >>  ","ItemMap","ItemCompass","ItemWatch","ItemRadio","ItemGPS","NVGoggles_OPFOR","Binocular"]

	if (count (_kit select 4) == 1) exitWith { "" };
	_items = (_kit select 4);
	_items deleteAt 0;
	
	_output = "";
	{		
		_output = format [
			"%1<br />%2x %3"
			,_output
			, _x select 1
			, DNAME(_x select 0)
		];
	} forEach ((_items) call BIS_fnc_consolidateArray);
		
	_output
};

dzn_fnc_gear_gnotes_getItems = {	
	private["_kit","_allItems","_items","_output","_i","_j","_item"];	
	_kit = _this;
	
	_allItems = [];
	for "_j" from 5 to 7 do {
		if (count (_kit select _j) > 1) then {
			_allItems = _allItems + (_kit select _j select 1);
		};
	};
	
	_items = [];
	{
		for "_i" from 1 to (_x select 1) do {
			_item = _x select 0;
			switch (_item) do {
				case "PRIMARY MAG": { _item = _kit select 1 select 2; };
				case "SECONDARY MAG": { _item = _kit select 2 select 2; };
				case "HANDGUN MAG": { _item = _kit select 3 select 2; };
			};
			_items pushBack (_item); 
		};
	} forEach _allItems;
	_allItems = _items call BIS_fnc_consolidateArray;
	
	_output = "";
	{
		_output = format [
			"%1<br />%2x %3"
			,_output
			, _x select 1
			, DNAME(_x select 0)
		];
	} forEach _allItems;
	
	_output
};
	
dzn_fnc_gear_gnotes_addMyGearSubject = {
	private["_kit","_output"];
	_kit = player call dzn_fnc_gear_getGear;
	_output = format [
		dzn_gear_gnotes_myGearTemplate
		, roleDescription player
		, [_kit, "primary", "personal"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, [_kit, "secondary", "personal"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, [_kit, "handgun", "personal"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, if (_kit select 0 select 3 != "") then { format ["<br /> - %1", DNAME(_kit select 0 select 3)] } else { "" }		
		, _kit call dzn_fnc_gear_gnotes_getItems
		, _kit call dzn_fnc_gear_gnotes_getAssignedItems
	];

	player createDiaryRecord ["Diary", ["Personal Equipment", _output]];
};

dzn_fnc_gear_gnotes_addSuqadGearSubject = {
	private["_kit","_output"];
	_output = "";
	{
		_kit = _x call dzn_fnc_gear_getGear;
		_output = _output + format [
			dzn_gear_gnotes_mySquadTemplate
			, roleDescription _x
			, [_kit, "primary", "squad"] call dzn_fnc_gear_gnotes_getWeaponInfo
			, [_kit, "secondary", "squad"] call dzn_fnc_gear_gnotes_getWeaponInfo
			, [_kit, "handgun", "squad"] call dzn_fnc_gear_gnotes_getWeaponInfo
		];	
	} forEach (units group player);
	
	player createDiaryRecord ["Diary", ["Squad Equipment", _output]];
};

// ******************** Init **************************
waitUntil { !isNil "dzn_gear_initialized" && { dzn_gear_initialized } };

waitUntil { call dzn_gear_gnotes_waitUntilMyEvent };
if (dzn_gear_gnotes_showMyGear) then { call dzn_fnc_gear_gnotes_addMyGearSubject; };

waitUntil { call dzn_gear_gnotes_waitUntilGroupEvent };
if (dzn_gear_gnotes_showSquadGear) then { call dzn_fnc_gear_gnotes_addSuqadGearSubject };


dzn_gear_gnotes_enabled = true;
