#include "defines.h"

#define DBG_FUNC_PREFIX "onAddButtonClick"

params ["_poolId", "_item"];

private _pool = _self get Q(ItemPools) getOrDefaultCall [_poolId, { [] }, true];
_pool pushBack _item;
_pool sort true;
