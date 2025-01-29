#include "defines.h"


private _category = _self get Q(CurrentItemPoolId);

forceUnicode 1;
copyToClipboard str(_self get Q(ItemPools) getOrDefault [_category, []]);
forceUnicode -1;