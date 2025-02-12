#include "defines.h"
/*  
    Resolves unit object to some kit in gear assignment table, by:
    a. Object varname 
    b. Side, Group & Rolename
    c. Side & Rolename
    d. Rolename 

    Params:
    0: _unit (OBJECT) - unit to resovle kit for. 

    Returns:
    _kitname (STRING) - name of the kit or "" if not found.

*/
params ["_unit"];

private _table = _self get Q(Table);

private _objectName = vehicleVarName _unit;
private _kitname = _table getOrDefault [_objectName, ""];
if (_kitname isNotEqualTo "") exitWith { _kitname };

private _groupName = groupid group _unit;
private _sideName = toUpper str(side _unit);
private _roleName = roleDescription _unit;

_kitname = [_table, [_sideName, _groupName, _roleName], "", ""] call dzn_fnc_getByPath;
if (_kitname isNotEqualTo "") exitWith { _kitname };

_kitname = [_table, [_sideName, _roleName], "", ""] call dzn_fnc_getByPath;
if (_kitname isNotEqualTo "") exitWith { _kitname };

_kitname = _table getOrDefault [_kitname, ""];
if (_kitname isNotEqualTo "") exitWith { _kitname };
