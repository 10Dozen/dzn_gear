#include "defines.h"

/*
    Creates Gear Map from Gear Array

    Params:
    _this (ARRAY) - gear array
*/
DBG_ "Params: %1", _this EOL;
createHashMapObject [
    dzn_gear_gearMapDeclaration,
    _this
];