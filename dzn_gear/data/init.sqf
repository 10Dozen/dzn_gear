#import "macro.hpp"

params [["_editMode", false], ["_initDelay", 0]];

GVAR(version) = VERSION;

// --- Settings & Functions
INIT_FILE(Settings);
INIT_FILE(data\functions);
INIT_FILE(data\cba_ettings);

// --- Include kits 
INIT_FILE(Kits);

// --- Plugins
INIT_PLUGIN(_editMode, Editor);
INIT_PLUGIN(GVAR(enableGearAssignementTable), AssignementTable);
INIT_PLUGIN(GVAR(enableGearNotes), GearNotes);
INIT_PLUGIN(GVAR(enableZeusCompatibility), ZeusCompatibility);


// --- Initialization
if (_initDelay > 0) then {
	[{ [] call FUNC(initialize) }, nil, _initDelay] call CBA_fnc_waitAndExecute;
} else {
	[] call FUNC(initialize);
};
