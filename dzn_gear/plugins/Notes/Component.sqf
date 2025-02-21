#include "defines.h"

/*
    Personal kit info (copy GearTotals?)
    Squad gear info (Group + Nickname + Main weapon + Launcher

*/

params ["_settings"];

private _declaration = [
    [Q(Settings), _settings],
    [Q(RefreshGroupNotes), _settings get "Group" get "enable"],

    PREP_COMPONENT_FUNCTION(AddNotes),
    PREP_COMPONENT_FUNCTION(getTotals),
    PREP_COMPONENT_FUNCTION(showItemInfo)
];

private _cob = createHashMapObject [_declaration];

_cob
