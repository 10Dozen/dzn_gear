#include "..\macro.h"


#define ThisCOB dzn_gear_ZeusComponent
#define COMPONENT_PATH dzn_gear\plugins\Zeus

#define INIT_COMPONENT(NAME) [] call compileScript ['COMPONENT_PATH\Component.sqf']

#define DBG_PREFIX "(dzn_gear.Zeus) "

#define NEWLINE_AND_TAB toString[10,32,32,32,32]
#define NEWLINE toString[10]

// -- Inlines
#define GET_SELECTED_OBJECTS [((curatorSelected select 0) select { _x isKindOf "CAManBase" }), ((curatorSelected select 0) select { !(_x isKindOf "CAManBase") })]

#define GET_UNITS_BUTTON_STATE(DIALOG) ((DIALOG call ["GetByTag", "btn_units"]) getVariable [Q(Selected), true])
#define GET_CREW_BUTTON_STATE(DIALOG) ((DIALOG call ["GetByTag", "btn_crew"]) getVariable [Q(Selected), true])
#define GET_OBJECTS_BUTTON_STATE(DIALOG) ((DIALOG call ["GetByTag", "btn_objects"]) getVariable [Q(Selected), true])


// -- Palette
#define COLOR_HEX_GOLD SQ(#FFD000)
#define COLOR_HEX_LIGHT_BLUE SQ(#84b0f0)
#define COLOR_HEX_LIGHT_GREEN SQ(#acdb8b)
#define COLOR_HEX_LIME SQ(#7bbf37)
#define COLOR_HEX_AQUA SQ(#12C4FF)
#define COLOR_HEX_BRICK_RED SQ(#eb4f34)

// -- Converts
#define MASS_TO_KG(X) (X * 0.1 * 0.453592) toFixed 2

// -- Menu items
#define MENU_ITEM_BY_TAG(D,T) (D call ["GetByTag", T])

// --   Tags
#define BTN_UNITS Q(btn_units)
#define BTN_CREW Q(btn_crew)
#define BTN_VICS Q(btn_vehicles)
#define DP_KITNAME Q(dp_kitname)
#define INP_KITNAME Q(i_kitname)
#define BTN_APPLY_KIT Q(btn_applyKit)
#define BTN_COPY Q(btn_copy)
#define BTN_APPLY Q(btn_apply)
#define BTN_CREATE Q(btn_create)
#define DP_ITEM Q(d_item)
#define BTN_ADD_ITEM Q(btn_addItem)
#define BTN_REMOVE_ITEM Q(btn_removeItem)
#define BTN_ARSENAL Q(btn_arsenal)
#define BTN_CLEAR Q(btn_clear)

#define BTN_FILTER_TITLE(TITLE,COUNT) format ["<t align='center' size='1.5'>%1 %2</t>", count COUNT, TITLE]


// -- Notif
#define NOTIF_INFO 0
#define NOTIF_OK 1
#define NOTIF_FAIL 2

#define NOTIF_MSG_NOT_SELECTED 1
#define NOTIF_MSG_TOO_MUCH_SELECTED 2
#define NOTIF_MSG_NO_UNIT_SELECTED 3
#define NOTIF_MSG_NO_VEHICLE_SELECTED 4

#define NOTIF_MSG_PERSONAL_GEAR_COPIED 10
#define NOTIF_MSG_PERSONAL_GEAR_APPLIED 11
#define NOTIF_MSG_PERSONAL_GEAR_SAVED 12

#define NOTIF_MSG_CARGO_GEAR_COPIED 30
#define NOTIF_MSG_CARGO_GEAR_APPLIED 31
#define NOTIF_MSG_CARGO_GEAR_SAVED 32

#define NOTIF_MSG_CARGO_CLEARED 40

#define NOTIF_MSG_ITEM_NVG_ADDED 50
#define NOTIF_MSG_ITEM_NVG_REMOVED 51
#define NOTIF_MSG_ITEM_BACKPACK_ADDED 52
#define NOTIF_MSG_ITEM_BACKPACK_REMOVED 53
#define NOTIF_MSG_ITEM_WEAPON_LIGHT_ADDED 54
#define NOTIF_MSG_ITEM_WEAPON_LIGHT_REMOVED 55
#define NOTIF_MSG_ITEM_WEAPON_SUPPRESSOR_ADDED 56
#define NOTIF_MSG_ITEM_WEAPON_SUPPRESSOR_REMOVED 57
#define NOTIF_MSG_ITEM_WEAPON_OPTICS_ADDED 58
#define NOTIF_MSG_ITEM_WEAPON_OPTICS_REMOVED 59
