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