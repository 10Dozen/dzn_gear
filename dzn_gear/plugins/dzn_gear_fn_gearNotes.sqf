// ******** Gear Notes Plug-in ************
// ****************************************************
//
// ******************** Settings **********************

/*
MyGEAR:


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


- MyUnit
1'1 Squad Leader (AK-74)
Team Leader (AK-74 (PK-A))
MachineGunner (PKM)
Rifleman (AK-74M / RPG-7V (PV-1A)
)
*/

/*
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
	%1 - Role description
	%2 - Pri Wep if exist
	%3 - Sec Wep if exist
	%4 - Hand Gun if exist
*/
dzn_gear_gnotes_myUnitTemplate = "%1 (%2%3%4)";
dzn_gear_gnotes_waitUntilEvent = { !isNil {player getVariable "dzn_gear"} };

// ******************** Functions **********************
#define V_DNAME(CLASS)	getText( configFile >> "CfgVehicles" >> CLASS >> "displayName")
#define	W_DNAME(CLASS)	getText( configFile >> "CfgWeapons" >> CLASS >> "displayName")

dzn_fnc_gear_gnotes_getWeaponInfo = {
	// type: "Primary", "Secondary", "Handgun"
	params["_kit","type"];
	private["_id","_output"];
	
	_id = switch (toLower(type)) do {
		case "primary": { 1 };
		case "secondary": { 2 };
		case "handgun": { 3 };		
	};
	_output = "";
	
	if ( (_kit select _id select 1) != "" ) then {
		{
			if (_x != "") then {
				_output = if (_output == "") then { "(" + W_DNAME(_x) + ")" } else { _output + ", " + W_DNAME(_x) };
			};
		} forEach (_kit select _id select 3);		
		_output = format ["<br /> - %1%2", _kit select _id select 1, _output];
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
			, W_DNAME(_x select 0)
		];
	} forEach ((_kit select 4) call BIS_fnc_consolidateArray);
	
	_output
};

dzn_fnc_gear_gnotes_getItems = {};
	
dzn_fnc_gear_gnotes_addMyGearSubject = {
	/*
		%1 - Role description
		%2 - Pri Wep if exist
		%3 - Sec Wep if exist
		%4 - Hand Gun if exist
		%5 - Backpack if exists
		%6 - Inventory (magazines, medicine)
		%7 - Assigned Items (map, radio, compass)
	*/
	
	_kit = player call dzn_fnc_gear_getGear;
	_text = format [
		dzn_gear_gnotes_myUnitTemplate
		, roleDescription player
		, [_kit,"primary"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, [_kit,"secondary"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, [_kit,"handgun"] call dzn_fnc_gear_gnotes_getWeaponInfo
		, "<br /> - " + V_DNAME(_kit select 0 select 3)
		, call dzn_fnc_gear_gnotes_getItems
		, call dzn_fnc_gear_gnotes_getAssignedItems
	]

};





// ******************** Init **************************
waitUntil { !isNil "dzn_gear_initialized" && { dzn_gear_initialized } };
waitUntil { call dzn_gear_gnotes_waitUntilEvent };


dzn_gear_gnotes_enabled = true;
