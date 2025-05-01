#include "defines.h"
/*
    Resolves and assign kit to unit by gear assignment table, by:
    a. Object varname
    b. Side, Group & Rolename
    c. Side & Rolename
    d. Rolename

    Params:
    0: _unit (OBJECT) - unit to resovle kit for.

    Returns:
    _kitname (STRING) - name of the kit or "" if not found.

*/

#define CALL_ASSIGN_KIT [_unit, _kitname] call dzn_fnc_gear_assignKit;

params ["_unit"];

DBG_1("Params: %1", _this);

// -- Prevent GAT application if unit already loaded with kit
if ((_unit getVariable ["dzn_gear", ""]) isNotEqualTo "") exitWith {};

private _table = dzn_gear_gat_table;

// -- Object VarName (is it working in MP?)
private _kitname = _table getOrDefault [vehicleVarName _unit, ""];
DBG_2("Varname: %1 -> _kitname=%2", vehicleVarName _unit, _kitname);
if (_kitname isNotEqualTo "") exitWith {
    CALL_ASSIGN_KIT;
};

private _groupName = groupid group _unit;
private _sideName = toUpper str(side _unit);
private _roleName = roleDescription _unit;

// -- Max precision (Side - Group - Rolename)
_kitname = [_table, [_sideName, _groupName, _roleName], "", ""] call dzn_fnc_getByPath;
DBG_4("Side-Group-Role: %1, %2, %3 -> _kitname=%4", _sideName, _groupName, _roleName, _kitname);
if (_kitname isNotEqualTo "") exitWith {
    CALL_ASSIGN_KIT;
};

// -- Mid precision (Side - Rolename)
_kitname = [_table, [_sideName, _roleName], "", ""] call dzn_fnc_getByPath;
DBG_3("Side-Role: %1, %2 -> _kitname=%3", _sideName, _roleName, _kitname);
if (_kitname isNotEqualTo "") exitWith {
    CALL_ASSIGN_KIT;
};

// -- Min precision (Rolename)
_kitname = _table getOrDefault [_kitname, ""];
DBG_2("Role: %1 -> _kitname=%2", _roleName, _kitname);
if (_kitname isNotEqualTo "") exitWith {
    CALL_ASSIGN_KIT;
};

// -- No kit found - do nothing

DBG("Not found");
