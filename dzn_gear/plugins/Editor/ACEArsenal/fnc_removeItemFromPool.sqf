#include "defines.h"

#define DBG_FUNC_PREFIX "onAddButtonClick"

params ["_poolId", "_item"];

private _pool = _self get Q(ItemPools) getOrDefaultCall [_poolId, { [] }, true];

DBG_1("Pool: %1", str(_pool));
private _idx = _pool find _item;
if (_idx == -1) exitWith {};
_pool deleteAt _idx;

DBG_1("Pool after: %1", str(_pool));
