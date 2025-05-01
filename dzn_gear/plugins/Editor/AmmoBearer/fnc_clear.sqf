#include "defines.h"
#define DBG_FUNC_PREFIX "addMagazine"

params [];
DBG_1("Invoked. Params: %1", _this);
_self set [Q(CurrentMagPool), createHashMap];
_self set [Q(TotalMagCount), 0];
