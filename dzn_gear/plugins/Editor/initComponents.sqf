#include "defines.h"

params ["_pluginSettings"];

dzn_gear_CoreComponent = INIT_COMPONENT_WITH_ARGS(Core,_pluginSettings);
dzn_gear_ArsenalComponent = INIT_COMPONENT(ACEArsenal);
dzn_gear_HistoryComponent = INIT_COMPONENT(History);
dzn_gear_AmmoBearerComponent = INIT_COMPONENT(AmmoBearer);
dzn_gear_CargoComposerComponent = INIT_COMPONENT(CargoComposer);