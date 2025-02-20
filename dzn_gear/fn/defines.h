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


#define MAP_CAT_UNIFORM "uniform"
#define MAP_CAT_VEST "vest"
#define MAP_CAT_BACKPACK "backpack"
#define MAP_CAT_HEADGEAR "headgear"
#define MAP_CAT_FACEWEAR "facewear"
#define MAP_CAT_PRIMARY "primary_weapon"
#define MAP_CAT_LAUNCHER "launcher_weapon"
#define MAP_CAT_HANDGUN "handgun_weapon"
#define MAP_CAT_UNIFORM_ITEMS "uniform_items"
#define MAP_CAT_VEST_ITEMS "vest_items"
#define MAP_CAT_BACKPACK_ITEMS "backpack_items"
#define MAP_CAT_ASSIGNED "assigned_items"
#define MAP_CAT_INDENTITY "identity"
#define MAP_CAT_TAGS "tags"
#define MAP_CAT_SCRIPT "script"
#define MAP_CAT_UNIFORM_TEXTURES "uniform_textures"

#define I_WEAPON_CLASS "class"
#define I_WEAPON_MAG "magazine"
#define I_WEAPON_ATTACHES "attaches"