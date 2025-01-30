#include "defines.h"

private _declaration = [
    [Q(History), []],

    PREP_COMPONENT_FUNCTION(onButtonClick),
    PREP_COMPONENT_FUNCTION(onSliderChange),
    PREP_COMPONENT_FUNCTION(compose),
];

private _cob = createHashMapObject [_declaration];

_cob
