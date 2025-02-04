#include "..\macro.h"


#define COMPONENT_PATH dzn_gear\plugins\Editor

#define INIT_COMPONENT(NAME) [] call compileScript ['COMPONENT_PATH\NAME\Component.sqf']
#define INIT_COMPONENT_WITH_ARGS(NAME,ARGS) [ARGS] call compileScript ['COMPONENT_PATH\NAME\Component.sqf']

// -- Shared defines
#define NO_OVERRIDE ""
#define OVERRIDE_STANDARD "Standard"
#define OVERRIDE_LEADER "Leader"

#define HISTORY_PERSONAL_KIT "PERSONAL_KIT"
#define HISTORY_CARGO_KIT "CARGO_KIT"
#define HISTORY_COMPOSED "COMPOSED"

#define NOTIF_KIT_COPIED 0
#define NOTIF_GEAR_CLEAR 1
#define NOTIF_GEAR_REMOVE 2
#define NOTIF_GEAR_VEHICLE_REMOVE 3
#define NOTIF_HISTORY_COPIED 20
#define NOTIF_BEARER_COPIED 10
#define NOTIF_BEARER_ADDED 11

// -- Palette
#define COLOR_PALE_GREEN [0.54, 0.63, 0.44, 1]
#define COLOR_PALE_RED   [0.63, 0.54, 0.44, 1]
#define COLOR_STEEL_BLUE [0.24, 0.29, 0.34, 0.8]

#define COLOR_DARK_GREEN [0.5, 0.7, 0.6, 1]
#define COLOR_WHITE      [1,1,1,1]
#define COLOR_BLACK      [0,0,0,1]
#define COLOR_GOLD       [0.92, 0.81, 0, 1]

#define COLOR_HEX_GOLD SQ(#FFD000)
#define COLOR_HEX_LIGHT_BLUE SQ(#84b0f0)
#define COLOR_HEX_LIGHT_GREEN SQ(#acdb8b)
#define COLOR_HEX_LIME SQ(#7bbf37)
#define COLOR_HEX_AQUA SQ(#12C4FF)
#define COLOR_HEX_BRICK_RED SQ(#eb4f34)

// -- Converts
#define MASS_TO_KG(X) [X * 0.1 * 0.453592, 2] call BIS_fnc_cutDecimals

