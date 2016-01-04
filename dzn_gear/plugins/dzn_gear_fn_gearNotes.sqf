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
dzn_gear_gnotes_myGearTemplate = "<font size='1.3'>%1</font><br />%2%3%4%5<br /><br />%6<br /><br />%7"

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
dzn_gear_gnotes_mySquadTemplate = "%1 (%2%3%4)";

dzn_gear_gnotes_waitUntilEvent = { !isNil {player getVariable "dzn_gear"} };

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
	// type: "Primary", "Secondary", "Handgun"
	// _mode: "personal", "squad"
	params["_kit","_type","_mode"];
	private["_id","_output"];
	
	_id = switch (toLower(_type)) do {
		case "primary": { 1 };
		case "secondary": { 2 };
		case "handgun": { 3 };		
	};
	_output = "";
	
	if ( (_kit select _id select 1) != "" ) then {
		{
			if (_x != "") then {
				_output = if (_output == "") then { "(" + DNAME(_x) + ")" } else { _output + ", " + DNAME(_x) };
			};
		} forEach (_kit select _id select 3);	
		
		if ( toLower(_mode) == "personal" ) then {
			_output = format ["<br /> - %1%2", _kit select _id select 1, _output];
		} else {
			_output = format [", %1%2", _kit select _id select 1, _output];
		};
	};

	_output
};

dzn_fnc_gear_gnotes_getAssignedItems = {
	params["_kit"];
	private["_output"];
	
	_output	= "";
	{		
		_output = format [
			"%1<br />%2x %3"
			,_output
			, _x select 1
			, DNAME(_x select 0)
		];
	} forEach ((_kit select 4) call BIS_fnc_consolidateArray);
	_output = "<br />" + _output;
	
	_output
};

dzn_fnc_gear_gnotes_getItems = {
	params["_kit"];
	private["_allItems","_output"];
	
	#define LINEITEMS(ID)	(_kit select ID select 1)
	_allItems = ( LINEITEMS(5) + LINEITEMS(6) + LINEITEMS(7) ) call BIS_fnc_consolidateArray;
	
	_output = "";
	{
		_output = format [
			"%1<br />%2x %3"
			,_output
			, _x select 1
			, DNAME(_x select 0)
		];
	} forEach _allItems;	
	_output = "<br />" + _output;
	
	_output
};
	
dzn_fnc_gear_gnotes_addMyGearSubject = {
	private["_kit","_output"];
	_kit = player call dzn_fnc_gear_getGear;
	_output = format [
		dzn_gear_gnotes_myUnitTemplate
		, roleDescription player
		, [_kit, "primary", "personal"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, [_kit, "secondary", "personal"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, [_kit, "handgun", "personal"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, "<br /> - " + DNAME(_kit select 0 select 3)
		, _kit call dzn_fnc_gear_gnotes_getItems
		, _kit call dzn_fnc_gear_gnotes_getAssignedItems
	]

	player createDiaryRecord ["Diary", ["Personal Equipment", _output]];
};

dzn_fnc_gear_gnotes_addSuqadGearSubject = {
	private["_kit","_output"];

	{
		_kit = _x call dzn_fnc_gear_getGear;
		_output = format [
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
waitUntil { call dzn_gear_gnotes_waitUntilEvent };

if (dzn_gear_gnotes_showSquadGear) then { call dzn_fnc_gear_gnotes_addSuqadGearSubject };
if (dzn_gear_gnotes_showMyGear) then { call dzn_fnc_gear_gnotes_addMyGearSubject; };

dzn_gear_gnotes_enabled = true;
