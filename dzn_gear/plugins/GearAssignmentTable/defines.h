#include "..\macro.h"


#define COMPONENT_PATH dzn_gear\plugins\GearAssignmentTable

#define INIT_COMPONENT(NAME) [] call compileScript ['COMPONENT_PATH\NAME\Component.sqf']
#define INIT_COMPONENT_WITH_ARGS(NAME,ARGS) [ARGS] call compileScript ['COMPONENT_PATH\NAME\Component.sqf']

// -- Shared defines

// -- Converts

