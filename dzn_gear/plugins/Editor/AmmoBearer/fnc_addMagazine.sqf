#include "defines.h"
#define DBG_FUNC_PREFIX "addMagazine"

DBG_ "Invoked. Params: %1", _this EOL;

params ["_magClass", "_count"];
private _pool = _self get Q(CurrentMagPool);
_pool set [_magClass, _count + (_pool getOrDefault [_magClass, 0])];

_self set [Q(TotalMagCount), (_self get Q(TotalMagCount)) + _count];
