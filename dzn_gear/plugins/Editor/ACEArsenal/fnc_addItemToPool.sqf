#include "defines.h"


DBG_ "Params: %1", _this EOL;
params ["_category", "_item"];

private _pool = _self get Q(ItemPools) getOrDefaultCall [_category, { [] }, true];
_pool pushBack _item;
_pool sort true;

DBG_ "PooL: %1", _pool EOL;
