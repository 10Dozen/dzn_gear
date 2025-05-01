#include "defines.h"
/*
    Resolve given kit and call function to assign existing kit to unit.
    EXAMPLE: [ @unit, @gearSetName, @isBox ] spawn dzn_fnc_gear_assignKit;
    INPUT:
        0: OBJECT - Unit for which gear will be set
        1: ARRAY or STRING - List of Kits or single kit for assignment: ["kit_r","kit_ar"] or "kit_ar"
        2: BOOLEAN - Is given unit a box?
    OUTPUT: NULL
*/
params ["_unit","_kits",["_isCargo", false]];

DBG_1("Params: %1", _this);

private _kitname = _kits;

// -- In case of nested arrays - select item that is not an array
while {_kitname isEqualType []} do {
    _kitname = selectRandom _kitname;
};

// -- Look for kit name across variables
private _kit = missionNamespace getVariable [_kitname, []];
if (_kit isEqualTo []) exitWith {
    private _msg = format ['There is no kit with name "%1"', _kitname];
    diag_log parseText _msg;
    systemChat _msg;
};

// -- Random Kit: a list of kitnames
if (_kit isEqualType [] && { !((_kit # 0) isEqualType []) }) exitWith {
    [_unit, selectRandom _kit] call dzn_fnc_gear_assignKit;
};

// -- Save selected kitname
_unit setVariable ["dzn_gear", _kitname, true];

if (_isCargo) exitWith {
    [_unit, _kit] call dzn_fnc_gear_assignCargoGear;
};

DBG_1("Goint to convert to GearMap format: %1", _kit);
// Convert gear array to gear map
DBG_1("_kit type == %1", typename _kit);
private _gearMap = dzn_gear_kitnameToGearMap getOrDefaultCall [
    _kitname,
    {
        if (_kit isEqualType []) then {
            DBG("Convert gearArray to gearMap");
            _kit = createHashMapObject [dzn_gear_gearMapDeclaration, _kit];
        };
        DBG("Save gearMap");
        _kit
    },
    true
];
DBG_1("_kit: %1", _kit);
DBG_1("_gearMap: %1", _gearMap);
DBG_1("MAPS: %1", dzn_gear_kitnameToGearMap get _kitname);


if (local _unit) then {
    [_unit, _gearMap] call dzn_fnc_gear_assignGear;
} else {
    [_unit, _gearMap] remoteExec ["dzn_fnc_gear_assignGear", _unit];
};
