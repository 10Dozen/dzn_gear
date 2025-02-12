#include "defines.h"

params ["_pluginSettings"];

// dzn_gear_Editor_CoreComponent
ECOB(GAT,Core) = INIT_COMPONENT_WITH_ARGS(Core,_pluginSettings);