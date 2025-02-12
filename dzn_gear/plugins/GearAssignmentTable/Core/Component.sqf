#include "defines.h"
params ["_settings"];


private _table = ([
    _settings get "GearAssignmentTable" get "tableFile"
] call dzn_fnc_parseSFML) call _convertKeysToDatatypes;

private _declaration = [
    [Q(Settings), _settings],
    [Q(Table), _table],

    // -- Public
    PREP_COMPONENT_FUNCTION(Assign),
    PREP_COMPONENT_FUNCTION(resolve)
];

private _cob = createHashMapObject [_declaration];

_cob
