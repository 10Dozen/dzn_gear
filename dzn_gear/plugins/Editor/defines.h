#include "..\macro.h"


#define COMPONENT_PATH dzn_gear\plugins\Editor

#define INIT_COMPONENT(NAME) [] call compileScript ['COMPONENT_PATH\NAME\Component.sqf']
#define INIT_COMPONENT_WITH_ARGS(NAME,ARGS) [ARGS] call compileScript ['COMPONENT_PATH\NAME\Component.sqf']

// -- Shared defines
#define TOTALS_LABEL_TAG "dzn_Gear_TotalsLbl"

#define NO_OVERRIDE ""
#define OVERRIDE_STANDARD "Standard"
#define OVERRIDE_LEADER "Leader"

#define HISTORY_PERSONAL_KIT "PERSONAL_KIT"
#define HISTORY_CARGO_KIT "CARGO_KIT"
#define HISTORY_COMPOSED "COMPOSED"

#define NOTIF_KIT_COPIED 0
#define NOTIF_GEAR_CLEAR 1
#define NOTIF_GEAR_REMOVE_ALL 2
#define NOTIF_GEAR_BACKPACK_CLEAR 3
#define NOTIF_GEAR_VEHICLE_REMOVE 4
#define NOTIF_HISTORY_COPIED 20
#define NOTIF_BEARER_COPIED 10
#define NOTIF_BEARER_ADDED 11



// -- Converts
#define MASS_TO_KG(X) (X * 0.1 * 0.453592) toFixed 2

