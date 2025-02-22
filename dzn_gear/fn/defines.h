#define DBG_PREFIX "(dzn_gear) "
#define DBG_FUNC_PREFIX __FILE_SHORT__
#define DBG_ diag_log format [DBG_PREFIX + "[" + DBG_FUNC_PREFIX + "] " +
#define EOL ]

#define PREP(NAME) dzn_fnc_gear_##NAME = compileScript ['dzn_gear\fn\##NAME##.sqf']

#define L(X) toLowerANSI(X)

#define ARR_CAT_EQUIPMENT "EQUIPEMENT"
#define ARR_CAT_PRIMARY "PRIMARY WEAPON"
#define ARR_CAT_LAUNCHER "LAUNCHER WEAPON"
#define ARR_CAT_HANDGUN "HANDGUN WEAPON"
#define ARR_CAT_UNIFORM_ITEMS "UNIFORM ITEMS"
#define ARR_CAT_VEST_ITEMS "VEST ITEMS"
#define ARR_CAT_BACKPACK_ITEMS "BACKPACK ITEMS"
#define ARR_CAT_ASSIGNED "ASSIGNED ITEMS"
#define ARR_CAT_INDENTITY "IDENTITY"
#define ARR_CAT_SCRIPT "SCRIPT"
#define ARR_CAT_UNIFORM_TEXTURES "UNIFORM TEXTURES"
#define ARR_CAT_TAGS "TAGS"


#define MAP_CAT_UNIFORM "Uniform"
#define MAP_CAT_VEST "Vest"
#define MAP_CAT_BACKPACK "Backpack"
#define MAP_CAT_HEADGEAR "Headgear"
#define MAP_CAT_FACEWEAR "Facewear"
#define MAP_CAT_PRIMARY "PrimaryWeapon"
#define MAP_CAT_LAUNCHER "Launcher"
#define MAP_CAT_HANDGUN "Handgun"
#define MAP_CAT_UNIFORM_ITEMS "UniformItems"
#define MAP_CAT_VEST_ITEMS "VestItems"
#define MAP_CAT_BACKPACK_ITEMS "BackpackItems"
#define MAP_CAT_ASSIGNED "AssignedItems"
#define MAP_CAT_INDENTITY "Identity"
#define MAP_CAT_TAGS "Tags"
#define MAP_CAT_SCRIPT "Script"
#define MAP_CAT_UNIFORM_TEXTURES "UniformTextures"

#define I_WEAPON_CLASS "class"
#define I_WEAPON_MAG "magazine"
#define I_WEAPON_ATTACHES "attaches"