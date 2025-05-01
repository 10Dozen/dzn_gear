#include "defines.h"


DBG_1("Params: %1", _this);
params ["_category", "_item"];

private _pool = _self get Q(ItemPools) getOrDefaultCall [_category, { [] }, true];
_pool pushBack _item;
_pool sort true;

DBG_1("PooL: %1", _pool);
