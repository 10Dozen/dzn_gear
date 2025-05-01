#include "defines.h"
#define DBG_FUNC_PREFIX "removeMagazine"

DBG_1("Invoked. Params: %1", _this);

params ["_magClass", "_count"];

private _pool = _self get Q(CurrentMagPool);
private _currentCount = (_pool getOrDefault [_magClass, 0]) - _count;
if (_currentCount < 1) exitWith {
    _pool deleteAt _magClass;
};

_pool set [_magClass, _currentCount];
_self set [Q(TotalMagCount), (_self get Q(TotalMagCount)) - _count];
