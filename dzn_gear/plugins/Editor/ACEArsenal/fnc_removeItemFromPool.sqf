#include "defines.h"

#define DBG_FUNC_PREFIX "onAddButtonClick"

params ["_poolId", "_item"];

private _pool = _self get Q(ItemPools) getOrDefaultCall [_poolId, { [] }, true];

DBG_ "Pool: %1", str(_pool) EOL;
private _idx = _pool find _item;
if (_idx == -1) exitWith {};
_pool deleteAt _idx;

DBG_ "Pool after: %1", str(_pool) EOL;
