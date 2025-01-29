#include "..\macro.h"


#define COMPONENT_PATH dzn_gear\plugins\Editor

#define INIT_COMPONENT(NAME) [] call compileScript ['COMPONENT_PATH\NAME\Component.sqf']