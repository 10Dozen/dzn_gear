// ******** Gear Zeus Compatibility Plug-in ************
// ****************************************************
//
//
// ******************** Settings **********************



// ********************** FNC ************************
dzn_fnc_gear_zc_initialize = {
	dzn_gear_zc_KitsList = [];
	
};
dzn_fnc_gear_collectKitNamess = {
	{
		private _kitname = _x getVariable ["dzn_gear", ""];
		if ( (_kitname != "") && !(_kitname in dzn_gear_zc_KitsList) ) then {
			dzn_gear_zc_KitsList pushBack _kitname;
		};
	} forEach allUnits;
};

dzn_fnc_gear_handleButtonPress = {

};

