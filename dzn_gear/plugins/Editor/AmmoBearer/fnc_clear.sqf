#include "defines.h"
#define DBG_FUNC_PREFIX "addMagazine"

params [];
DBG_ "Invoked. Params: %1", _this EOL;
_self set [Q(CurrentMagPool), createHashMap];
_self set [Q(TotalMagCount), 0];