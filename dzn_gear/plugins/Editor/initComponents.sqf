#include "defines.h"




params ["_pluginSettings"];

// dzn_gear_Editor_CoreComponent
ECOB(Editor,Core) = INIT_COMPONENT_WITH_ARGS(Core,_pluginSettings);
ECOB(Editor,Menu) = INIT_COMPONENT_WITH_ARGS(Menu,_pluginSettings);
ECOB(Editor,Arsenal) = INIT_COMPONENT(ACEArsenal);
ECOB(Editor,History) = INIT_COMPONENT(History);
ECOB(Editor,AmmoBearer) = INIT_COMPONENT(AmmoBearer);
ECOB(Editor,CargoComposer) = INIT_COMPONENT(CargoComposer);