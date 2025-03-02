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


// -- Roles map
//     @DisplayName, @ID, @Tags
#define TAG_LEADER "leader"
#define TAG_PLNET "PL_NET"

#define ROLES_DEFS \
    ["Platoon Leader", "pl", [TAG_LEADER,TAG_PLNET]], \
    ["Squad Leader", "sl", [TAG_LEADER,TAG_PLNET]], \
    ["Fireteam Leader", "ftl", [TAG_LEADER]], \
    ["Automatic Rifleman", "ar"], \
    ["Grenadier", "gr"], \
    ["Rifleman", "r"], \
    ["Section Leader", "sl", [TAG_LEADER,TAG_PLNET]], \
    ["2IC", "2ic", [TAG_LEADER]], \
    ["Командир Взвода", "pl", [TAG_LEADER,TAG_PLNET]], \
    ["Командир отделения", "sl", [TAG_LEADER,TAG_PLNET]], \
    ["Наводчик-оператор", "crew"], \
    ["Механик-водитель", "crew"], \
    ["Пулеметчик", "mg"], \
    ["Стрелок-Гранатометчик", "at"], \
    ["Стрелок, помощник гранатометчика", "aat"], \
    ["Старший стрелок", "ar"], \
    ["Стрелок (ГП)", "gr"], \
    ["Стрелок", "r"], \
    ["Снайпер", "mm"]
