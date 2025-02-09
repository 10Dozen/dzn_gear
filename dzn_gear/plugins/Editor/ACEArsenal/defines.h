#include "..\defines.h"

#define DBG_PREFIX "(dzn_gear.Editor.ACEArsenal) "


#define ThisCOB ECOB(Editor,Arsenal)
#define COMPONENT_PATH dzn_gear\plugins\Editor\ACEArsenal


#define IDC_leftTabContent 13
#define IDC_rightTabContent 14
#define IDC_rightTabContentListnBox 15

#define GET_WEAPON_NAME getText (configFile >> "CfgWeapons" >> _this >> "displayName")
#define GET_MAGAZINE_NAME getText (configFile >> "CfgMagazines" >> _this >> "displayName")
#define GET_VEHICLE_NAME getText (configFile >> "CfgVehicles" >> _this >> "displayName")
#define GET_GLASSES_NAME getText (configFile >> "CfgGlasses" >> _this >> "displayName")


// -- ACE Arsenal categories
#define CAT_PRIMARY_WEAPON 2002
#define CAT_LAUNCHER_WEAPON 2006
#define CAT_HANDGUN_WEAPON 2004
#define CAT_WEAPONS [CAT_PRIMARY_WEAPON, CAT_LAUNCHER_WEAPON, CAT_HANDGUN_WEAPON]

#define CAT_HEADGEAR 2008
#define CAT_UNIFORM 2010
#define CAT_VEST 2012
#define CAT_BACKPACK 2014
#define CAT_FACEWEAR 2016
#define CAT_NVG 2018
#define CAT_BINOCULARS 2020
#define CAT_MAPS 2022
#define CAT_TERMINAL 2024
#define CAT_RADIO 2026
#define CAT_NAV 2029
#define CAT_WATCH 2031
#define CAT_FACE 2033
#define CAT_VOICE 2035

#define CAT_OPTICS 22
#define CAT_POINTER 24
#define CAT_MUZZLE 26
#define CAT_BIPOD 28

#define CAT_MAG 3002
#define CAT_MAG2 3004


#define CATS_WITH_SUBCAT [CAT_PRIMARY_WEAPON, CAT_LAUNCHER_WEAPON, CAT_HANDGUN_WEAPON] //, CAT_UNIFORM, CAT_VEST, CAT_BACKPACK]

// -- UI Tags
#define DIALOG_ID_ITEM_POOL "dzn_gear_ItemPool"
#define DIALOG_ID_SUBCAT_ITEM_POOL "dzn_gear_ItemPoolSubcategory"

#define BTN_SHOW "btnCategoryShow"
#define BTN_ADD "btnCategoryAdd"
#define BTN_RESET "btnCategoryReset"

#define BTN_SUB_SHOW "btnSubCategoryShow"
#define BTN_SUB_ADD "btnSubCategoryAdd"
#define BTN_SUB_RESET "btnSubCategoryReset"