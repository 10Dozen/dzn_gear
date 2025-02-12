#include "defines.h"

/*
*/

params ["_pluginSettings"];

if (!hasInterface) exitWith {};

ECOB(GAT,Core) = INIT_COMPONENT_WITH_ARGS(Core,_pluginSettings);

ECOB(GAT,Core) call [F(Assign), [player]];