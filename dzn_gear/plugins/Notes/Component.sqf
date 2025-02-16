#include "defines.h"

/*
    Personal kit info (copy GearTotals?)
    Squad gear info (Group + Nickname + Main weapon + Launcher

*/


private _declaration = [
    PREP_COMPONENT_FUNCTION(AddNotes),
    PREP_COMPONENT_FUNCTION(getTotals),
    PREP_COMPONENT_FUNCTION(showItemInfo)
];

private _cob = createHashMapObject [_declaration];

_cob
