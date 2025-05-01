#include "defines.h"
#define DBG_FUNC_PREFIX "addMagazine"

DBG_1("Invoked. Params: %1", _this);

params ["_magClass", "_count"];
private _pool = _self get Q(CurrentMagPool);
_pool set [_magClass, _count + (_pool getOrDefault [_magClass, 0])];

_self set [Q(TotalMagCount), (_self get Q(TotalMagCount)) + _count];
