#define DBG_PREFIX "(dzn_gear) "
#define DBG_FUNC_PREFIX __FILE_SHORT__
#define DBG_ diag_log format [DBG_PREFIX + "[" + DBG_FUNC_PREFIX + "] " +
#define EOL ]

#define PREP(NAME) dzn_fnc_gear_##NAME = compileScript ['dzn_gear\fn\##NAME##.sqf']

#define L(X) toLowerANSI(X)

#include "categories.h"